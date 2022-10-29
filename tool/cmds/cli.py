from typing import Iterator

from build import await_input
from cmd import CmdContext, CommandExecuteError
from style import Style
from utils import useRef

_cli_style = Style()


class CliCmd:
    name = "cli"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        raise CommandExecuteError(CliCmd, "only admit interactive mode")

    @staticmethod
    def execute_interactive(ctx: CmdContext) -> Iterator:
        t = ctx.term
        t << "enter the command prompts to run."
        while True:
            yield await_input(ctx, prompt="/", ref=(args := useRef()))
            subctx = ctx.copy()

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "cmd"
        t << "|-- enter the cli mode"
