from cmd import Command, CmdContext, CommandList


class HelpCmd(Command):
    def __init__(self, name: str, cmdlist: CommandList):
        super().__init__()
        self.name = name
        self.cmdlist = cmdlist

    def execute(self, ctx: CmdContext):
        super().execute(ctx)

    def help(self, ctx: CmdContext):
        ctx.term << ""
