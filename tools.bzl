def assert_unmodified_repositories(previous_existing_rules, whitelist=None):
    """This function ensures that no http_archive or git_repository deps have been added or modified."""
    whitelist = {w: False for w in whitelist or []}
    violations = ["Illegal modification of external dependencies:"]

    for name, rule in native.existing_rules().items():
        if name in whitelist or not _is_relevant_rule(rule):
            continue

        if name not in previous_existing_rules:
            violations.append("{} {} was added".format(rule["kind"], name))
        else:
            key = _get_version_key(rule)
            if rule[key] != previous_existing_rules[name][key]:
                violations.append(
                    "{} {}: attribute {} was changed from '{}' to '{}'".format(
                        rule["kind"], name, key, rule[key], previous_existing_rules[name][key]
                    )
                )

    if len(violations) > 1:
        fail("\n- ".join(violations))

def _is_relevant_rule(rule):
    return rule["kind"] in ("http_archive", "git_repository")

def _get_version_key(rule):
    # TODO: extract the version for http_archive rules instead of using sha256sum as proxy
    return "sha256" if rule["kind"] == "http_archive" else "commit"

def assert_repository_has_version(name, expected_version):
    # TODO: extract the version for http_archive rules instead of using sha256sum as proxy
    rule = native.existing_rules().get(name, None)
    if not rule:
        fail("No repository '{}'".format(name))

    if not _is_relevant_rule(rule):
        fail("Unsupported rule kind '{}'".format(rule["kind"]))

    key = _get_version_key(rule)
    if rule[key] != expected_version:
        fail("{} {}: attribute {} has value '{}', not '{}'".format(rule["kind"], name, key, rule[key], expected_version))

