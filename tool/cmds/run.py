from typing import Iterable, Any

from args import Args
from cmd import CmdContext, CommandProtocol, CommandArgError, CommandExecuteError, CommandEmptyArgsError
from flutter import KiteScript
from ui import Terminal


class RunTerminal(Terminal):

    def __init__(self, inner: Terminal):
        super().__init__()
        self.inner = inner

    def print(self, *args):
        self.inner.print("| ", *args)

    def log(self, *args):
        self.inner.log(*args)

    def input(self, prompt: str) -> str:
        return self.inner.input(f"| {prompt}")

    def print_log(self, *args):
        self.print(*args)
        self.log(*args)


def run_cmd(parent: CmdContext, raw_args: str):
    args = Args.by(full=raw_args)
    if args.isempty:
        raise CommandExecuteError(RunCmd, "no command specified")
    arg0, args = args.poll()
    cmd = parent.cmdlist[arg0.name]
    if cmd is None:
        raise CommandArgError(RunCmd, arg0, f"command<{arg0.name}> not found")
    subctx = parent.copy(args=args)
    parent.term << f"-->> [{cmd.name}]"
    cmd.execute_cli(subctx)
    parent.term << f"--<< [{cmd.name}]"


def execute_kitescript(ctx: CmdContext, script: KiteScript):
    cmds = script.file.read().splitlines()
    outer = ctx.copy(term=RunTerminal(ctx.term))
    for i, cmd in enumerate(cmds):
        raw = cmd.strip()
        if len(raw) > 0:
            run_cmd(outer, raw)


class RunCmd:
    name = "run"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        if ctx.args.isempty:
            raise CommandEmptyArgsError(RunCmd, ctx.args, "no script name given")
        name = ctx.args[0]
        if name.ispair:
            raise CommandArgError(RunCmd, name, "script name can't be a pair")
        script = ctx.proj.scripts[name.key]
        if script is None:
            raise CommandArgError(RunCmd, name, f"script<{name.key}> not found")
        if isinstance(script, KiteScript):
            execute_kitescript(ctx, script)

    @staticmethod
    def execute_inter(ctx: CmdContext) -> Iterable:
        pass

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "run <script name>"
        t << "| run a script"


def build_globals(g: dict[str, Any]):
    g["int"] = int
    g["type"] = type
    g["str"] = str
    from flutter import Proj
    g["Proj"] = Proj
