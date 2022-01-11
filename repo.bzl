_build_file_content = """
alias(
    name = "doxygen",
    visibility = ["//visibility:public"],
    actual = "{DOXYGEN_VERSION}/doxygen.exe",
)
"""

_known_archives = {
    "1.9.3": {
        "windows64": struct(
            urls = ["http://pan.aqrose.com/seafhttp/files/f835b9ca-d8b0-40f8-ba35-30b549edb2b6/rules_doxygen-master.zip"],
            strip_prefix = "",
            sha256 = "575b1a27cb907675d24f2c348a4d95d9cdd6a2000f6a8d8bfc4c3a20b2e120f5",
            build_file_content = _build_file_content,
        ),
        "linux64": struct(
            urls = ["http://pan.aqrose.com/seafhttp/files/14dbaf6d-7df1-4958-91d9-8905381b1664/doxygen-1.9.3.linux.bin.tar.gz"],
            strip_prefix = "",
            sha256 = "e4db0a99e4f078ba4d8a590b6e3f6fdc2ff9207c50b1308a072be965e70f4141",
            build_file_content = _build_file_content,
        ),
    },
}

def _os_key(os):
    if os.name.find("windows") != -1:
        return "windows64"
    elif os.name.find("linux") != -1:
        return "linux64"
    return os.name

def _get_doxygen_archive(rctx):
    doxygen_version = rctx.attr.doxygen_version
    archives = _known_archives.get(doxygen_version)

    if not archives:
        fail("rules_doxygen unsupported doxygen_version: {}".format(doxygen_version))

    archive = archives.get(_os_key(rctx.os))

    if not archive:
        fail("rules_doxygen unknown doxygen version / operating system combo: doxygen_version={} os=".format(doxygen_version, rctx.os.name))

    return archive

def _doxygen_repository(rctx):
    archive = _get_doxygen_archive(rctx)
    rctx.download_and_extract(archive.urls, output = rctx.attr.doxygen_version, stripPrefix = archive.strip_prefix, sha256 = archive.sha256)
    rctx.file("BUILD.bazel", archive.build_file_content.format(DOXYGEN_VERSION = rctx.attr.doxygen_version), executable = False)

doxygen_repository = repository_rule(
    implementation = _doxygen_repository,
    attrs = {
        "doxygen_version": attr.string(
            default = "1.9.3",
            values = _known_archives.keys(),
        ),
    },
)
