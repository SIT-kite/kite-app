from typing import Iterable

from args import Args, Arg
from build import await_input
from cmd import CmdContext
from utils import useRef


def run_git_cmd(ctx: CmdContext, git_args: Args):
    proc = ctx.proj.runner.run(seq=git_args.compose())
    for line in proc.stdout:
        ctx.term << line.decode("utf-8").splitlines()[0]


class GitCmd:
    name = "git"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        git_args = Arg.by("git") + ctx.args
        run_git_cmd(ctx, git_args)

    @staticmethod
    def execute_interactive(ctx: CmdContext) -> Iterable:
        await_input(ctx, prompt="git ", ref=(argsRef := useRef()))
        args = Args.by(full=argsRef.deref())
        git_args = Arg.by("git") + args
        run_git_cmd(ctx, git_args)
        yield

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "git"
        t << "| it works alike the normal git"
