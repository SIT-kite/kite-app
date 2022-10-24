from typing import Iterable

import build
from cmd import Command, CmdContext, CommandList, CommandArgError
from ui import Terminal


class HelpBoxTerminal(Terminal):

    def __init__(self, inner: Terminal):
        super().__init__()
        self.inner = inner

    def print(self, *args):
        self.inner.print("|--", *args)

    def log(self, *args):
        self.inner.log(*args)

    def input(self, prompt: str) -> str:
        return self.inner.input(f"|-- {prompt}")

    def print_log(self, *args):
        self.print(*args)
        self.log(*args)


class HelpCmd(Command):
    def __init__(self, cmdlist: CommandList):
        super().__init__()
        self.name = "help"
        self.cmdlist = cmdlist

    def execute_inter(self, ctx: CmdContext) -> Iterable:
        all_cmd = ', '.join(ctx.cmdlist.keys())
        ctx.term << f"all commands = [{all_cmd}]"
        while True:
            ctx.term << f'plz select commands to show info.'
            select_task = build.select_many(ctx.cmdlist.name2cmd, ctx.term, prompt="I want=")
            yield select_task
            ctx.term.line(48)
            selected = select_task.result
            help_ctx = ctx.copy(term=HelpBoxTerminal(ctx.term))
            for cmd in selected:
                HelpCmd.show_help_info(cmd, ctx, help_ctx)
            ctx.term.line(48)

    def execute_cli(self, ctx: CmdContext):
        cmd, args = ctx.args.poll()
        if cmd.ispair:
            raise CommandArgError(self, cmd, "pair arg isn't allowed")
        help_ctx = ctx.copy(term=HelpBoxTerminal(ctx.term))
        if cmd.name == "*":
            for cmd_obj in ctx.cmdlist.values():
                HelpCmd.show_help_info(cmd_obj, ctx, help_ctx)
        else:
            cmd_obj = ctx.cmdlist[cmd.key]
            if cmd_obj is None:
                raise CommandArgError(self, cmd, f"❌ command<{cmd.name}> not found")
            HelpCmd.show_help_info(cmd_obj, ctx, help_ctx)

    @staticmethod
    def show_help_info(cmd: Command, ctx: CmdContext, help_box: CmdContext):
        ctx.term << cmd.name
        cmd.help(help_box)

    def help(self, ctx: CmdContext):
        ctx.term << 'help <command name>'
        ctx.term << "|- show help info of a command"
