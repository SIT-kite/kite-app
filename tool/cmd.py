from io import StringIO
from typing import Callable, Iterable

import fuzzy
import strings
from args import Args, Arg, split_multicmd
from flutter import Proj
from tui.colortxt import FG
from tui.colortxt.txt import Palette
from ui import Terminal


class CmdContext:
    def __init__(self, proj: Proj, terminal: Terminal, cmdlist: "CommandList", args: Args = None):
        self.proj = proj
        self.term = terminal
        self.cmdlist = cmdlist
        self.args = args

    @property
    def is_cli(self) -> bool:
        return self.args is not None

    def __str__(self):
        return f"{self.proj},{self.args}"

    def __repr__(self):
        return str(self)

    def __copy__(self) -> "CmdContext":
        return CmdContext(self.proj, self.term, self.cmdlist, self.args)

    def copy(self, **kwargs) -> "CmdContext":
        cloned = self.__copy__()
        for k, v in kwargs.items():
            setattr(cloned, k, v)
        return cloned


CommandFunc = Callable[[CmdContext], None]


class Command:
    """
    Command is a protocol, you don't need to inherit it,
    and you can even implement it as a class object.
    So DO NOT check the hierarchy of any command.

    - name:str -- the name of command

    - help(ctx) -- help info of command

    - execute_cli(ctx) -- execute the command in cli mode

    - execute_interactive(ctx) -- execute the command in interactive mode. return an Iterator as a coroutine
    """

    def __init__(self, name="__default__"):
        self.name = name

    def execute_cli(self, ctx: CmdContext):
        pass

    def execute_interactive(self, ctx: CmdContext) -> Iterable:
        pass

    def help(self, ctx: CmdContext):
        pass


CommandProtocol = Command | type


# noinspection SpellCheckingInspection
class CommandList:
    name2cmd: dict[str, CommandProtocol]

    def __init__(self, logger=None):
        self.name2cmd = {}
        self.builtins = set()
        self.logger = logger

    def log(self, *args):
        if self.logger is not None:
            self.logger.log(*args)

    def add_cmd(self, name: str, cmd: CommandProtocol):
        name = name.lower()
        if name in self.name2cmd:
            raise Exception(f"{name} command has already registered")
        self.log(f"command<{name}> loaded.")
        self.name2cmd[name] = cmd

    def is_builtin(self, name: str) -> bool:
        return name in self.builtins

    def __setitem__(self, key: str, cmd: CommandProtocol):
        self.add_cmd(key, cmd)

    def __getitem__(self, name: str) -> CommandProtocol | None:
        if name not in self.name2cmd:
            return None
        else:
            return self.name2cmd[name]

    def add(self, cmd: CommandProtocol):
        self.add_cmd(cmd.name, cmd)

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

    def keys(self):
        return iter(self.name2cmd.keys())

    def values(self):
        return iter(self.name2cmd.values())

    def items(self):
        return iter(self.name2cmd.items())

    def fuzzy_match(self, name: str, threshold: float) -> CommandProtocol | None:
        candidate, radio = fuzzy.match(name, self.name2cmd.keys())
        if radio < threshold:
            return None
        else:
            return self.name2cmd[candidate]

    def __str__(self):
        return f"[{', '.join(self.name2cmd.keys())}]"

    def __repr__(self):
        return str(self)

    def __len__(self) -> int:
        return self.size

    def browse_by_page(self, cmd_per_page: int) -> Iterable[tuple[int, Iterable[CommandProtocol]]]:
        cur = []
        for i, cmd in enumerate(self.name2cmd.values()):
            if i % cmd_per_page == 0 and i != 0:
                yield i // cmd_per_page, cur
                cur.clear()
            else:
                cur.append(cmd)
        if len(cur) > 0:
            yield (self.size - 1) // cmd_per_page, cur

    def calc_total_page(self, cmd_per_page: int) -> int:
        return self.size // cmd_per_page


class CommandArgError(Exception):
    def __init__(self, cmd: CommandProtocol, arg: Arg | None, *more):
        super(CommandArgError, self).__init__(*more)
        self.arg = arg
        self.cmd = cmd


class CommandEmptyArgsError(Exception):
    def __init__(self, cmd: CommandProtocol, cmdargs: Args, *more):
        super(CommandEmptyArgsError, self).__init__(*more)
        self.cmdargs = cmdargs
        self.cmd = cmd


class CommandExecuteError(Exception):
    def __init__(self, cmd: CommandProtocol, *args):
        super(CommandExecuteError, self).__init__(*args)
        self.cmd = cmd


_er = Palette(fg=FG.Red)
_er0 = _er.tint('×').get()
_er1 = _er.tint('│').get()
_er2 = _er.tint('╰─>').get()

_arr = Palette(fg=FG.Gold)
_arrow = _arr.tint("^").get()

_highlight = Palette(fg=FG.Cyan)


def print_cmdarg_error(t: Terminal, e: CommandArgError):
    index = e.arg.raw_index
    full, pos = e.arg.root.located_full(index)
    t.both << f"{_er0} {full[:pos.start]}{_highlight.tint(full[pos.start:pos.end]).get()}{full[pos.end:]}"
    with StringIO() as s:
        s.write(_er1)
        s.write(" ")
        s.write(strings.repeat(pos.start))
        s.write(_arr.tint(strings.repeat(pos.end - pos.start, "^")).get())
        t.both << s.getvalue()
    t.both << _er.tint(f'╰─> {type(e).__name__}: {e}').get()


def print_cmdargs_empty_error(t: Terminal, e: CommandEmptyArgsError):
    full = e.cmdargs.root.full()
    t.both << f"{_er0} {full}"
    with StringIO() as s:
        s.write(strings.repeat(len(full)))
        s.write(_arrow)
        t.both << f"{_er1} {s.getvalue()}"
    t.both << _er.tint(f'╰─> {type(e).__name__}: {e}').get()


class CommandDelegate(Command):
    def __init__(self, name: str, fullargs: str, helpinfo: str):
        super().__init__(name)
        self.fullargs = fullargs
        self.helpinfo = helpinfo

    def execute(self, ctx: CmdContext):
        args = Args.by(full=self.fullargs)
        all_cmdargs = split_multicmd(args)
        # prepare commands to run
        exe_args = []
        # check if all of them are executable
        for command, args in (args.poll() for args in all_cmdargs):
            cmdname = command.full
            executable = ctx.cmdlist[cmdname]
            if executable is None:
                raise CommandArgError(self, command, f"command<{cmdname}> not found")
            exe_args.append((executable, args))
        for i, pair in enumerate(exe_args):
            executable, args = pair
            subctx = ctx.copy(args=args)
            executable.execute_cli(subctx)

    def execute_cli(self, ctx: CmdContext):
        self.execute(ctx)

    def execute_interactive(self, ctx: CmdContext) -> Iterable:
        self.execute(ctx)
        yield

    def help(self, ctx: CmdContext):
        for line in self.helpinfo.splitlines():
            ctx.term << line
