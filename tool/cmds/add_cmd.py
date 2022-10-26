from typing import Iterable

from cmd import CmdContext


class ExtraCommandsSettings:
    def __init__(self):
        self.name2cmdargs: dict[str, str] = {}


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
