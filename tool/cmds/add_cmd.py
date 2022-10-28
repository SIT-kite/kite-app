from typing import Iterable

import flutter
from args import group_args, Args
from build import InputTask, input_multiline, yes_no
from cmd import CmdContext, CommandEmptyArgsError, CommandArgError, CommandProtocol
from flutter import ExtraCommandEntry, ExtraCommandsConf
from utils import Ref


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
    def add_cmd(conf: ExtraCommandsConf, name: str, fullargs: str, helpinfo: str):
        entry = ExtraCommandEntry(name=name, fullargs=fullargs, helpinfo=helpinfo)
        conf[name] = entry

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
        conf = ctx.proj.settings.get(flutter.extra_commands, settings_type=ExtraCommandsConf)
        AddCmdCmd.add_cmd(conf, name, args, info)

    @staticmethod
    def execute_interactive(ctx: CmdContext) -> Iterable:
        t = ctx.term
        t << f"plz enter a unique name."
        while True:
            inputted = InputTask(t, prompt="name=")
            yield inputted
            name = inputted.result.strip()
            if ctx.cmdlist.is_builtin(name):
                t << f"❌ {name} is a builtin command."
            else:
                break
        t.logging << f"name is {name}"
        t << f'plz enter cmd&args, enter "EOF" to end multi-line.'
        lines = []
        while True:
            prompt = "+ " if len(lines) > 0 else "args="
            inputted = InputTask(t, prompt=prompt)
            yield inputted
            line = inputted.result.strip()
            if line == "EOF":
                break
            lines.append(line)
        fullargs = " + ".join(lines)
        t.logging << f"fullargs is {fullargs}"
        t << f'plz enter help info, enter "EOF" to end multi-line.'
        inputted = input_multiline(t, prompt=lambda res: "\\n " if len(res) > 0 else "info=")
        yield inputted
        info: list[str] = inputted.result
        helpinfo = "\n".join(info)
        t.logging << f"helpinfo is {helpinfo}"
        conf = ctx.proj.settings.get(flutter.extra_commands, settings_type=ExtraCommandsConf)
        overridden = name in conf
        if overridden:
            reply = Ref()
            t << f"{name} already exists, comfort to override it?"
            yield yes_no(t, ref=reply)
            if not reply.obj:
                t.both << f"adding command<{name}> aborted"
                return
        t.both << AddCmdCmd.add_cmd(conf, name, fullargs, helpinfo)
        t.both << f'command<{name}> added."'

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "addcmd --n <cmd name> --args <full args> --info <help info>"
        t << "|-- add a custom cmd with args"
