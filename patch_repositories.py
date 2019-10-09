import argparse
import build_project_distro
import os
import re
import sys
import tempfile
import utils


def download_distro(project_name):
    src_path = utils.get_meta_data(build_project_distro.ARCHIVE_META_DATA_KEY)
    dest_dir = tempfile.mkdtemp()

    # Buildkite wants a trailing slash
    if not dest_dir.endswith("/"):
        dest_dir += "/"

    utils.print_group("Downloading {} distro from Buildkite".format(project_name))
    process = utils.execute_command("buildkite-agent", "artifact", "download", src_path, dest_dir)
    if process.returncode:
        raise Exception("Failed to download distro from {}: {}".format(src_path, process.stderr))

    return os.path.join(dest_dir, src_path)


def extract_distro(project_name, archive_path):
    utils.print_group("Extracting {} distro from {}".format(project_name, archive_path))
    dest_dir = tempfile.mkdtemp()
    process = utils.execute_command("tar", "-xf", archive_path, "-C", dest_dir)
    if process.returncode:
        raise Exception(
            "Failed to extract {} distro to {}: {}".format(project_name, dest_dir, process.stderr)
        )

    # Unlike other repository rules, local_repository requires the presence of a WORKSPACE file
    # (even though its content is being ignored).
    # However, most distributions don't contain a WORKSPACE file, hence we create one in that case.
    process = utils.execute_command("touch", os.path.join(dest_dir, "WORKSPACE"))
    if process.returncode:
        raise Exception("Failed to ensure that a WORKSPACE file exists: {}".format(process.stderr))

    return dest_dir


def rewrite_repositories_file(repositories_file, project_name, project_root):
    utils.print_group(
        "Rewriting {} to point {} at {}".format(repositories_file, project_name, project_root)
    )
    transformations = [
        lambda content: fix_function(repositories_file, content, project_name, project_root)
    ]
    rewrite_file(repositories_file, transformations)


def rewrite_file(path, transformations):
    with open(path, "r") as file:
        content = file.read()

    for t in transformations:
        content = t(content)

    with open(path, "w") as file:
        file.write(content)


def fix_function(repositories_file, content, project_name, project_root):
    lines = content.split("\n")

    function_index = find_function_index(repositories_file, project_name, lines)
    next_element_index = find_next_element_index(lines, function_index)

    old_function_lines = lines[function_index:next_element_index]
    function_lines = create_function_lines(old_function_lines, project_name, project_root)
    lines = lines[:function_index] + function_lines + lines[next_element_index:]
    return "\n".join(lines)


def find_function_index(path, function_name, lines):
    prefix = "def {}(".format(function_name)
    for i, l in enumerate(lines):
        if l.startswith(prefix):
            return i

    raise Exception("There is no function {}() in {}".format(function_name, path))


def find_next_element_index(lines, function_index):
    index = function_index + 1
    while index < len(lines):
        l = lines[index]
        if not l or l[0] not in (" ", "\t"):
            break

        index += 1

    # First line that no longer belongs to the function
    return index


def create_function_lines(old_lines, project_name, project_root):
    result = ["def {}():".format(project_name)]

    # Very simple and error-prone algorithm.
    # TODO: improve if necessary
    indent = get_indent(old_lines)
    deps_func = "{}_deps()".format(project_name)
    if has_function_call(old_lines, deps_func):
        result.append("{}{}".format(indent, deps_func))

    # Windows: We need to escape backslashes
    project_root = project_root.replace("\\", "\\\\")
    result += [
        f"{indent}native.local_repository(",
        f'{indent}{indent}name = "{project_name}",',
        f'{indent}{indent}path = "{project_root}",',
        f"{indent})",
    ]
    return result


def get_indent(function_lines):
    # Very simple and error-prone algorithm.
    # TODO: improve if necessary
    first_body_line = function_lines[1]
    match = re.search(r"\s+", first_body_line)
    if not match:
        raise Exception("Something went wrong :(")

    return match.group(0)


def has_function_call(function_lines, function_name):
    for l in function_lines:
        if l.lstrip().startswith(function_name):
            return True

    return False


def upload_repositories_file(repositories_file):
    utils.print_group("Uploading {} file".format(repositories_file))
    utils.upload_file(repositories_file)


def main(argv=None):
    if argv is None:
        argv = sys.argv[1:]

    utils.PRINT_COMMANDS = True

    parser = argparse.ArgumentParser(description="Bazel Federation CI Patch Repositories Script")
    parser.add_argument(
        "--repositories_file",
        type=str,
        default="repositories.bzl",
        help="Path of the file that contains the repository functions.",
    )

    args = parser.parse_args(argv)

    utils.print_group("Executing patch_repositories.py...")

    patching_required = utils.get_meta_data(
        build_project_distro.REPO_PATCHING_REQUIRED_META_DATA_KEY, ""
    )
    if not patching_required:
        utils.eprint("Running as part of a regular presubmit -> no repositories patching required")
        return 0

    project_name = utils.get_meta_data(build_project_distro.REPO_META_DATA_KEY)
    archive_path = download_distro(project_name)
    project_root = extract_distro(project_name, archive_path)
    rewrite_repositories_file(args.repositories_file, project_name, project_root)
    upload_repositories_file(args.repositories_file)

    return 0


if __name__ == "__main__":
    sys.exit(main())

