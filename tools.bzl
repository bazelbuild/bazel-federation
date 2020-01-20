def assert_unmodified_repositories(previous_existing_rules, whitelist=None):
    """This function ensures that no repository dependencies have been added or modified."""
    # There are no simple sets in Starlark.
    whitelist = {w: False for w in whitelist or []}
    violations = ["Illegal modification of external dependencies:"]

    for name, rule in native.existing_rules().items():
        if name in whitelist:
            continue

        if name not in previous_existing_rules:
            violations.append("{}(name = '{}') was added".format(rule["kind"], name))
        elif rule["kind"] not in ("bind", "local_repository"):
            prev_key, prev_value = _get_version(previous_existing_rules[name])
            key, value = _get_version(rule)

            if prev_key != key:
                violations.append(
                    "Repository {}: changed from {}({} = '...') to {}({} = ...)".format(
                        name, previous_existing_rules[name]["kind"], prev_key, rule["kind"], key
                    )
                )
            elif prev_value != value:
                violations.append(
                    "{}({}): attribute {} was changed from '{}' to '{}'".format(
                        rule["kind"], name, key, prev_value, value
                    )
                )

    if len(violations) > 1:
        fail("\n- ".join(violations))


def _get_version(rule):
    for key in ("tag", "commit", "remote", "url"):
        value = rule.get(key, None)
        if value:
            return key, value

    urls = rule.get("urls", None)
    if urls:
        return "urls", "-".join(sorted(urls))

    fail("Could not determine version for {}({})".format(rule["kind"], rule["name"]))


def assert_repository_has_version(name, version_attr, expected_version):
    # TODO: extract the version for http_archive rules instead of using sha256sum as proxy
    rule = native.existing_rules().get(name, None)
    if not rule:
        fail("No repository '{}'".format(name))

    if version_attr not in rule.keys():
        fail("Rule kind '{}' has no attribute '{}'".format(rule["kind"], version_attr))

    if rule[version_attr] != expected_version:
        fail(
            "{}({}): attribute {} has value '{}', not '{}'".format(
                rule["kind"], name, version_attr, rule[version_attr], expected_version
            )
        )

