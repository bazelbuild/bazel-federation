import os
import sys
import tempfile
import traceback
import utils


REPO_PATCHING_REQUIRED_META_DATA_KEY = "repo_patching_required"
REPO_META_DATA_KEY = "prerelease-repo-name"
ARCHIVE_META_DATA_KEY = "distro_path"


def download_repository(org, repo, commit):
    archive = fetch_source(org, repo, commit)
    dest = extract_archive(archive)
    return os.path.join(dest, "{}-{}".format(repo, commit))


def fetch_source(org, repo, commit):
    url = "https://github.com/{}/{}/archive/{}.zip".format(org, repo, commit)
    utils.print_group("Fetching source from {}".format(url))
    dest_path = os.path.join(tempfile.mkdtemp(), "{}.zip".format(repo))
    process = utils.execute_command("curl", "-sSL", url, "-o", dest_path)

    if process.returncode:
        raise Exception("Unable to download from {}: {}".format(url, process.stderr))

    return dest_path


def extract_archive(archive_path):
    utils.print_group("Extracting {}".format(archive_path))
    dest = tempfile.mkdtemp()
    process = utils.execute_command("unzip", archive_path, "-d", dest)

    if process.returncode:
        raise Exception("Failed to extract {} to {}: {}".format(archive_path, dest, process.stderr))

    return dest


def build_distro(repo_dir, target):
    utils.print_group("Building distro {} in {}".format(target, repo_dir))
    os.chdir(repo_dir)

    process = utils.execute_command("bazel", "build", target)
    if process.returncode:
        raise Exception("Failed to build {}: {}".format(target, process.stderr))

    print(process.stdout)

    process = utils.execute_command(
        "find", "-L", os.path.join(repo_dir, "bazel-bin"), "-name", "*.tar.gz"
    )
    if process.returncode:
        raise Exception("Unable to find tar.gz output file: {}".format(process.stderr))

    lines = process.stdout.split("\n")
    files = [l for l in lines if l.strip()]
    if len(files) != 1:
        raise Exception(
            "Expected exactly one tar.gz file, not {}: {}".format(len(files), ", ".join(files))
        )

    return files[0]


def save_distro(distro_path):
    utils.print_group("Uploading distro from {}".format(distro_path))
    # Don't upload from distro_path directly since Buildkite will keep the long path
    # as part of the artifact name.
    dirname, basename = os.path.split(distro_path)
    os.chdir(dirname)
    utils.upload_file(basename)
    utils.set_meta_data(ARCHIVE_META_DATA_KEY, basename)


def request_repo_patching():
    utils.print_group("Requesting repositories patching in subsequent steps {}")
    utils.set_meta_data(REPO_PATCHING_REQUIRED_META_DATA_KEY, "True")


def main(argv=None):
    if argv is None:
        argv = sys.argv[1:]

    utils.PRINT_COMMANDS = True

    try:
        repo = utils.get_meta_data(REPO_META_DATA_KEY)
        gh_org = utils.get_meta_data("prerelease-gh-org")
        gh_repo = utils.get_meta_data("prerelease-gh-repo")
        commit = utils.get_meta_data("prerelease-commit")
        target = utils.get_meta_data("prerelease-distro-target")

        text = f"Testing {repo} distro (<a href='https://github.com/{gh_org}/{gh_repo}/commit/{commit}'>{gh_org}/{gh_repo} @ {commit}</a>)"
        utils.execute_command(
            "buildkite-agent", "annotate", "--style", "info", "--context", "distro", text
        )

        repo_dir = download_repository(gh_org, gh_repo, commit)
        distro_path = build_distro(repo_dir, target)
        save_distro(distro_path)
        request_repo_patching()
    except Exception as ex:
        utils.eprint("".join(traceback.format_exception(None, ex, ex.__traceback__)))
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())

