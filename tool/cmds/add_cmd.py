from typing import Iterable

from cmd import CmdContext


class AddCmdCmd:
    name = "addcmd"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        pass

    @staticmethod
    def execute_inter(ctx: CmdContext) -> Iterable:
        yield

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "addcmd <script name>"
        t << "|-- run a script"
