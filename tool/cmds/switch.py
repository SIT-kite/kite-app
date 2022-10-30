import re
from typing import Iterator

from args import group_args, Args
from build import select_one, replace_settings, await_input
from cmd import CmdContext, CommandArgError, CommandEmptyArgsError
from filesystem import File
from utils import useRef

_new = object()
_to = object()
_builtins = {
    "new": _new,
    "to": _to
}


class Version:
    def __init__(self):
        self.kiteIP = "https://kite.sunnysab.cn"
        self.applicationId = "cn.edu.sit.kite"


def get_all_versions(ctx: CmdContext) -> dict[str, Version]:
    conf = ctx.proj.settings.get("cmd.switch.versions", settings_type=dict)
    if "default" not in conf:
        conf["default"] = Version()
    return conf


def _get_arg(grouped: dict[str | None, list[Args]], argname: str, allow_empty=False) -> str | None:
    if argname not in grouped and allow_empty:
        return None
    n_argslist = grouped[argname]
    if len(n_argslist) > 1:
        raise CommandArgError(SwitchCmd, n_argslist[1][0], f"duplicate arg<{argname}> provided")
    n_args = n_argslist[0]
    if n_args.size == 0:
        if allow_empty:
            return None
        raise CommandEmptyArgsError(SwitchCmd, n_args, f"arg<{argname}> is empty")
    elif n_args.size == 1:
        n_arg = n_args[0]
        return n_arg.full
    else:
        return n_args.full()


class SwitchCmd:
    name = "switch"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        grouped = group_args(ctx.args)
        if "set" in grouped:
            set_argslist = grouped["set"]
            if len(set_argslist) == 0:
                raise CommandEmptyArgsError(SwitchCmd, "")

    @staticmethod
    def execute_interactive(ctx: CmdContext) -> Iterator:
        versions = get_all_versions(ctx)
        view = dict(versions)
        view.update(_builtins)
        ctx.term << "enter a name to edit or perform."
        yield select_one(ctx, view, prompt="version=", ref=(versionRef := useRef()))
        version = versionRef.deref()

        if version == _new:
            version = Version()
            yield SwitchCmd.create_version(ctx, versions, new=version)
            yield replace_settings(ctx, obj=version)
            ctx.term << "version updated."
        elif version == _to:
            yield SwitchCmd.switch_to(ctx, versions)
            ctx.term << "switch succeeded."
        else:
            yield replace_settings(ctx, obj=version)
            ctx.term << "version updated."

    @staticmethod
    def switch_to(ctx: CmdContext, versions: dict[str, Version]) -> Iterator:
        yield select_one(ctx, versions, prompt="to=", ref=(versionRef := useRef()))
        version: Version = versionRef.deref()
        switch_to(ctx, version)
        yield

    @staticmethod
    def create_version(ctx: CmdContext, versions: dict[str, Version], new: Version) -> Iterator:
        ctx.term << "enter a version name to create."
        while True:
            yield await_input(ctx, prompt="name=", ref=(nameRef := useRef()))
            new_name = nameRef.deref()
            if new_name in _builtins:
                ctx.term << ctx.style.error(f'"{new_name}" is builtin, plz enter another one.')
            elif new_name in versions:
                ctx.term << ctx.style.error(f'"{new_name}" already exists, plz enter another one.')
            else:
                break
        versions[new_name] = new
        yield

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "switch --to <version>"
        t << "switch --set <version> <name>=<value>"


def switch_to(ctx: CmdContext, to: Version):
    set_android_applicationId(ctx.proj.android_build_gradle, to.applicationId)


_appid_rex = re.compile(r'(?<=applicationId\s[\"\']).*(?=[\"\'])')


def set_android_applicationId(gradle: File, new: str):
    full = gradle.read()
    lines = full.splitlines()
    for i, line in enumerate(lines):
        found = _appid_rex.findall(line)
        if len(found) > 0:
            appid = found[0]
            lines[i] = line.replace(appid, new)
    gradle.write('\n'.join(lines))
