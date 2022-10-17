from typing import Callable

import fuzzy
from args import Args
from flutter import Proj
from ui import Terminal


class CmdContext:
    def __init__(self, proj: Proj, terminal: Terminal, args: Args = None):
        self.proj = proj
        self.term = terminal
        self.args = args

    @property
    def is_cli(self) -> bool:
        return self.args is not None


CommandFunc = Callable[[CmdContext], None]


class Command:
    """
    Command is a protocol, you don't need to inherit it,
    and you can even implement it as a class object.

    Command protocol:
    - name:str -- the name of command
    - help(ctx) -- help info of command
    - execute(ctx) -- execute the command
    - call as a function, args: [ctx]. the same as execute(ctx)
    """

    def __init__(self, func: CommandFunc = None):
        self.func = func
        self.name = "__default__"

    def execute(self, ctx: CmdContext):
        self.func(ctx)

    def help(self, ctx: CmdContext):
        self.func(ctx)

    def __call__(self, *args, **kwargs):
        self.execute(*args, **kwargs)


CommandProtocol = Command | type


# noinspection SpellCheckingInspection
class CommandList:
    name2cmd: dict[str, CommandProtocol]

    def __init__(self, logger=None):
        self.name2cmd = {}
        self.logger = logger

    def log(self, *args):
        if self.logger is not None:
            self.logger.log(*args)

    def __setitem__(self, key: str, cmd: CommandProtocol):
        self.log(f"command<{key}> loaded.")
        self.name2cmd[key] = cmd

    def __getitem__(self, name: str) -> CommandProtocol | None:
        if name not in self.name2cmd:
            return None
        else:
            return self.name2cmd[name]

    def add(self, cmd: CommandProtocol):
        name = cmd.name
        self.log(f"command<{name}> loaded.")
        self.name2cmd[name] = cmd

    def __lshift__(self, cmd: CommandProtocol):
        self.add(cmd)

    @property
    def size(self):
        return len(self.name2cmd)

    @property
    def isempty(self):
        return self.size > 0

    def __contains__(self, name: str) -> bool:
        return name in self.name2cmd

    def __iter__(self):
        return iter(self.name2cmd.items())

    @property
    def keys(self):
        return iter(self.name2cmd.keys())

    @property
    def values(self):
        return iter(self.name2cmd.values())

    def fuzzy_match(self, name: str, threshold: float) -> CommandProtocol | None:
        candidate, radio = fuzzy.match(name, self.name2cmd.keys())
        if radio < threshold:
            return None
        else:
            return self.name2cmd[candidate]


class CommandArgsParseError(Exception):
    def __init__(self, cmd: CommandProtocol, args: Args, *more):
        super(CommandArgsParseError, self).__init__(cmd.name, args, *more)
        self.cmd = cmd


class CommandArgsError(Exception):
    def __init__(self, cmd: CommandProtocol, args: Args, *more):
        super(CommandArgsError, self).__init__(cmd.name, args, *more)
        self.cmd = cmd


class CommandExecuteError(Exception):
    def __init__(self, cmd: CommandProtocol, *args):
        super(CommandExecuteError, self).__init__(cmd.name, *args)
        self.cmd = cmd
