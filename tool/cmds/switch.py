from typing import Iterator

from build import select_one, replace_settings, await_input
from cmd import CmdContext
from utils import useRef

_new = object()


class Version:
    def __init__(self):
        self.kiteIP = "https://kite.sunnysab.cn"
        self.applicationId = "cn.edu.sit.kite"


def get_all_versions(ctx: CmdContext) -> dict[str, Version]:
    conf = ctx.proj.settings.get("cmd.switch.versions", settings_type=dict)
    if "default" not in conf:
        conf["default"] = Version()
    return conf


class SwitchCmd:
    name = "switch"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        pass

    @staticmethod
    def execute_interactive(ctx: CmdContext) -> Iterator:
        versions = get_all_versions(ctx)
        view = dict(versions)
        view["new"] = _new
        ctx.term << "enter a name to edit."
        yield select_one(ctx, view, prompt="version=", ref=(versionRef := useRef()))
        version = versionRef.deref()
        if version == _new:
            version = Version()
            ctx.term << "enter a version name to create."
            while True:
                yield await_input(ctx, prompt="name=", ref=(nameRef := useRef()))
                new_name = nameRef.deref()
                if nameRef == "new":
                    ctx.term << ctx.style.error('"new" is a builtin name, plz enter another one.')
                elif new_name in versions:
                    ctx.term << ctx.style.error(f'"{new_name}" already exists, plz enter another one.')
                else:
                    break
            versions[new_name] = version

        yield replace_settings(ctx, obj=version)
        ctx.term << "version updated."

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "switch --to <version>"
        t << "switch --set <version>"
