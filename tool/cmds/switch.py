import re
from typing import Iterator

from args import group_args2
from build import select_one, replace_settings, await_input, settings_from_str
from cmd import CmdContext, CommandArgError, CommandEmptyArgsError
from dart import DartFi
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


class SwitchCmd:
    name = "switch"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        groups = group_args2(ctx.args)
        versions = get_all_versions(ctx)
        # set then to would be nice
        if groups.has(args="set"):
            settings = groups.get_args(name="set")
            real_settings = []
            name = None
            for setting in settings:
                if setting.ispair:
                    real_settings.append(setting)
                else:
                    name = setting.name
            if name is None:
                raise CommandEmptyArgsError(SwitchCmd, ctx.args, "no version name given")
            name4display = ctx.style.name(name)
            if name not in versions:
                version = Version()
                ctx.term << f"version<{name4display}> created."
            else:
                version = versions[name]
            settings_from_str(version, {pair.key: pair.value for pair in settings})
            ctx.term << f"version<{name4display}> updated."
        if groups.has(args="to"):
            name_arglist = groups.get_args(name="to")
            if len(name_arglist) > 1:
                raise CommandArgError(SwitchCmd, name_arglist[1], "redundant arg<to> given")
            name_arg = name_arglist[0]
            if name_arg.ispair:
                raise CommandArgError(SwitchCmd, name_arg, "arg<to> can't be a pair")
            name = name_arg.key
            if name not in versions:
                raise CommandArgError(SwitchCmd, name_arg, f"version<{name}> not found")
            else:
                name4display = ctx.style.name(name)
                version = versions[name]
                switch_to(ctx, version)
                ctx.term << f"switched to version<{name4display}>."

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
    set_backend_config(ctx.proj.backend_dart, {
        "kite": f'"{to.kiteIP}"'
    })


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


_field_rex = re.compile(f'(?<=static const).*(?=;)')
_field_name_rex = re.compile(r'(?<=static const ).*(?= =)')
_field_value_rex = re.compile(r'(?<== ).*(?=;)')


def set_backend_config(fi: DartFi, setting: dict[str, str]):
    full = fi.read()
    lines = full.splitlines()
    for i, line in enumerate(lines):
        found = _field_rex.search(line)
        if found:  # it's a field
            field_name = _field_name_rex.findall(line)[0]
            if field_name in setting:
                field_value = _field_value_rex.findall(line)[0]
                new_value = setting[field_name]
                lines[i] = line.replace(field_value, new_value)
    fi.write('\n'.join(lines))
    fi.append("\n")
