from typing import Callable

from ui import Terminal


class Context:
    def __init__(self, terminal: Terminal):
        self.terminal = terminal


CommandFunc = Callable[[Context], None]


class Command:
    def __init__(self, func: CommandFunc = None):
        self.func = func

    def execute(self, context: Context):
        self.func(context)

    def __call__(self, *args, **kwargs):
        self.func(*args, **kwargs)


class CommandList:
    name2cmd: dict[str, Command]

    def __init__(self):
        self.name2cmd = {}

    def __getitem__(self, name: str) -> Command | None:
        if name not in self.name2cmd:
            return None
        else:
            return self.name2cmd[name]
