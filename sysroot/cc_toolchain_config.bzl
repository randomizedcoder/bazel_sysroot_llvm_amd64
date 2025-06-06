#
# cc_toolchain_config.bzl
#

load("@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl", "action_config", "feature", "feature_set", "flag_group", "flag_set", "tool", "tool_path", "variable_with_value", "with_feature_set")
load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")

def _impl(ctx):
    toolchain_identifier = "llvm_amd64"
    host_system_name = "local"
    target_system_name = "local"
    target_cpu = "k8"
    target_libc = "local"
    compiler = "clang"
    abi_version = "local"
    abi_libc_version = "local"
    cc_target_os = None
    builtin_sysroot = None
    action_configs = []

    unfiltered_compile_flags = [
        "-fno-canonical-system-headers",
        "-Wno-builtin-macro-redefined",
        "-D__DATE__=\\"redacted\\"",
        "-D__TIMESTAMP__=\\"redacted\\"",
        "-D__TIME__=\\"redacted\\"",
    ]

    default_compile_flags = [
        "-Wall",
        "-fPIC",
        "-fno-omit-frame-pointer",
        "-fstack-protector",
        "-fcolor-diagnostics",
        "-fno-common",
        "-Woverloaded-virtual",
        "-Wno-free-nonheap-object",
        "-fno-omit-frame-pointer",
    ]

    default_link_flags = [
        "-fuse-ld=lld",
        "-Wl,-no-as-needed",
        "-Wl,-z,relro,-z,now",
        "-pass-exit-codes",
        "-lstdc++",
        "-lm",
    ]

    cxx_builtin_include_directories = [
        "/include",
        "/include/c++/v1",
        "/include/x86_64-unknown-linux-gnu",
        "/include/x86_64-linux-gnu",
        "/include/clang",
        "/include/clang-c",
    ]

    tool_paths = [
        tool_path(name = "ar", path = "bin/llvm-ar"),
        tool_path(name = "cpp", path = "bin/clang-cpp"),
        tool_path(name = "gcc", path = "bin/clang"),
        tool_path(name = "gcov", path = "bin/llvm-cov"),
        tool_path(name = "ld", path = "bin/ld.lld"),
        tool_path(name = "nm", path = "bin/llvm-nm"),
        tool_path(name = "objcopy", path = "bin/llvm-objcopy"),
        tool_path(name = "objdump", path = "bin/llvm-objdump"),
        tool_path(name = "strip", path = "bin/llvm-strip"),
    ]

    features = [
        feature(
            name = "default_compile_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        ACTION_NAMES.c_compile,
                        ACTION_NAMES.cpp_compile,
                        ACTION_NAMES.linkstamp_compile,
                        ACTION_NAMES.assemble,
                        ACTION_NAMES.preprocess_assemble,
                        ACTION_NAMES.cpp_header_parsing,
                        ACTION_NAMES.cpp_module_compile,
                        ACTION_NAMES.cpp_module_codegen,
                        ACTION_NAMES.clif_match,
                        ACTION_NAMES.lto_backend,
                    ],
                    flag_groups = [flag_group(flags = default_compile_flags)],
                ),
            ],
        ),
        feature(
            name = "default_link_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        ACTION_NAMES.cpp_link_executable,
                        ACTION_NAMES.cpp_link_dynamic_library,
                        ACTION_NAMES.cpp_link_nodeps_dynamic_library,
                    ],
                    flag_groups = [flag_group(flags = default_link_flags)],
                ),
            ],
        ),
        feature(
            name = "supports_pic",
            enabled = True,
        ),
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = features,
        action_configs = action_configs,
        artifact_name_patterns = [],
        cxx_builtin_include_directories = cxx_builtin_include_directories,
        toolchain_identifier = toolchain_identifier,
        host_system_name = host_system_name,
        target_system_name = target_system_name,
        target_cpu = target_cpu,
        target_libc = target_libc,
        compiler = compiler,
        abi_version = abi_version,
        abi_libc_version = abi_libc_version,
        tool_paths = tool_paths,
        make_variables = [],
        builtin_sysroot = builtin_sysroot,
        cc_target_os = cc_target_os,
    )

cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {},
    provides = [CcToolchainConfigInfo],
)