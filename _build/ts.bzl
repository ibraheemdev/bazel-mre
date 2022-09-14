"""Typescript macros"""

load("@aspect_rules_ts//ts:defs.bzl", "ts_project", "ts_config")
load("@aspect_rules_js//npm:defs.bzl", "npm_package")
load("@aspect_rules_js//js:defs.bzl", "js_library", "js_binary")

def ts_standard(name, srcs = None, source_map = True, declaration = True, visibility = ["//visibility:public"], tsconfig = "//:tsconfig", deps = [], **kwargs):
    ts_project(
        name = name,
        srcs = srcs,
        visibility = visibility,
        data = [name_copy],
        tsconfig = tsconfig,
        incremental = True,
        source_map = source_map,
        declaration = declaration,
        deps = deps,
        **kwargs
    )

def ts_binary(name, deps = [], entry_point = "index.js", visibility = ["//visibility:public"], **kwargs):
    # Standard deps to include
    deps = deps + [
        "//:node_modules/@types/node",
        "//:node_modules/source-map-support",
        "//:node_modules/typescript",
    ]

    name_lib = name + ".lib"
    ts_standard(name_lib, deps = deps, visibility = ["//visibility:private"], **kwargs)

    js_binary(
        name = name,
        entry_point = entry_point,
        data = [":%s" % name_lib] + deps,
        visibility = visibility,
    )

def ts_library(name, data = [], visibility = ["//visibility:public"], tsconfig = "//:tsconfig", **kwargs):
    npm_package(
        name = name,
        srcs = [
            "package.json",
            ":dist",
        ],
        package = "@x/%s" % name,
        visibility = ["//visibility:public"],
    )

    ts_standard("dist-ts", visibility = ["//visibility:private"], **kwargs)

    js_library(
        name = "dist",
        srcs = [":dist-ts", "package.json"],
        visibility = visibility,
    )
