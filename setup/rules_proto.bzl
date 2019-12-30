
load("@rules_proto//proto:repositories.bzl", "rules_proto_toolchains")

def rules_proto_setup():
    # Do not call rules_proto_dependencies() since it also call dependencies of com_google_protobuf
    rules_proto_toolchains()
