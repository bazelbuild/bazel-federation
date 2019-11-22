def assert_unmodified_repositories(previous_existing_rules, whitelist=None):
    whitelist = {w: False for w in whitelist or []}
    violations = ["Illegal modification of external dependencies:"]

    for name, rule in native.existing_rules().items():
        if name in whitelist:
            continue

        if (
            rule["kind"] in ("http_archive", "git_repository")
            and name not in previous_existing_rules
        ):
            violations.append("{} {} was added".format(rule["kind"], name))
        else:
            # TODO: extract the version for http_archive rules instead of using sha256sum as proxy
            key = "sha256sum" if rule["kind"] == "http_archive" else "commit"
            if rule[key] != previous_existing_rules[name][key]:
                violations.append(
                    "{} {}: attribute {} was changed from {} to {}".format(
                        rule["kind"], name, field, rule[key], previous_existing_rules[name][key]
                    )
                )

    if len(violations) > 1:
        fail("\n".join(violations))


def assert_repository_has_version(name, expected_version):
    # TODO: extract the version for http_archive rules instead of using sha256sum as proxy
    rule = native.existing_rules().get(name, None)
    if not rule:
        fail("No repository '{}'".format(name))

    key = "sha256sum" if rule["kind"] == "http_archive" else "commit"
    if rule[key] != expected_version:
        fail("{} {}: attribute {} has value {}, not {}".format(rule["kind"], name, key, rule[key], expected_version))

