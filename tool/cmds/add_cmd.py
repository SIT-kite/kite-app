from typing import Iterable

from cmd import CmdContext, CommandEmptyArgsError, CommandArgError, CommandProtocol


class AddCmdCmd:
    name = "addcmd"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        if ctx.args.isempty:
            raise CommandEmptyArgsError(AddCmdCmd, ctx.args, "no command name given")

    @staticmethod
    def execute_inter(ctx: CmdContext) -> Iterable:
        yield

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "addcmd -n <cmd name> -args <full args>"
        t << "|-- add a custom cmd with args"
