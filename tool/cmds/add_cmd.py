from typing import Iterable

import flutter
from args import group_args, Args
from cmd import CmdContext, CommandEmptyArgsError, CommandArgError, CommandProtocol
from flutter import ExtraCommandEntry, ExtraCommandsConf


def _get_arg(grouped: dict[str | None, list[Args]], argname: str, allow_empty=False) -> str | None:
    n_argslist = grouped[argname]
    if len(n_argslist) > 1:
        raise CommandArgError(AddCmdCmd, n_argslist[1][0], f"duplicate arg<{argname}> provided")
    n_args = n_argslist[0]
    if n_args.size == 0:
        if allow_empty:
            return None
        raise CommandEmptyArgsError(AddCmdCmd, n_args, f"arg<{argname}> is empty")
    elif n_args.size == 1:
        n_arg = n_args[0]
        return n_arg.full
    else:
        return n_args.full()


class AddCmdCmd:
    name = "addcmd"

    @staticmethod
    def add_cmd(ctx: CmdContext, name: str, fullargs: str, helpinfo: str):
        entry = ExtraCommandEntry(name=name, fullargs=fullargs, helpinfo=helpinfo)
        conf = ctx.proj.settings.get(flutter.extra_commands, settings_type=ExtraCommandsConf)
        overridden = name in conf
        conf[name] = entry
        if overridden:
            ctx.term.both << f'command<{name}> was overriden."'
        else:
            ctx.term.both << f'command<{name}> added."'
        ctx.term.both << f'>> "{fullargs}"'
        ctx.term.both << f'? "{helpinfo}"'

    @staticmethod
    def execute_cli(ctx: CmdContext):
        if ctx.args.isempty:
            raise CommandEmptyArgsError(AddCmdCmd, ctx.args, "no command name given")
        grouped = group_args(ctx.args)
        ungrouped_args = grouped[None][0]
        if not ungrouped_args.isempty:
            name_arg = ungrouped_args[0]
            if name_arg.ispair:
                if name_arg.key == "name":
                    name = name_arg.key
                else:
                    raise CommandArgError(AddCmdCmd, name_arg, "name is a pair but without a key<name>")
            else:
                name = name_arg.key
        else:
            name = _get_arg(grouped, argname="n", allow_empty=False)
        args = _get_arg(grouped, argname="args", allow_empty=False)
        info = _get_arg(grouped, argname="info", allow_empty=True)
        if info is None:
            info = ""
        AddCmdCmd.add_cmd(ctx, name, args, info)

    @staticmethod
    def execute_inter(ctx: CmdContext) -> Iterable:
        yield

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "addcmd --n <cmd name> --args <full args> --info <help info>"
        t << "|-- add a custom cmd with args"
