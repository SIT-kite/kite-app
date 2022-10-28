from typing import Iterable

from cmd import CmdContext
from dart import DartFormatConf


def lint(ctx: CmdContext):
    conf = ctx.proj.settings.get("cmd.lint.conf", DartFormatConf)
    proc = ctx.proj.runner.format(conf)
    for line in proc.stdout:
        ctx.term << line.decode("utf-8").splitlines()[0]


class LintCmd:
    name = "lint"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        lint(ctx)

    @staticmethod
    def execute_interactive(ctx: CmdContext) -> Iterable:
        lint(ctx)
        yield

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "lint"
        t << "|-- format .dart files"
