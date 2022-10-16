import shlex
from typing import Sequence, Iterable


class Arg:
    def __init__(self, key: str, value: str = None):
        self.key = key.strip()
        if value is not None:
            value = value.strip()
        self.value = value

    @property
    def ispair(self) -> bool:
        return self.value is not None

    @staticmethod
    def by(arg: str) -> "Arg":
        parts = arg.split("=")
        if len(parts) == 1:
            return Arg(key=parts[0])
        else:
            return Arg(key=parts[0], value=parts[1])

    def __str__(self):
        if self.ispair:
            return f"{self.key}:{self.value}"
        else:
            return f"{self.key}"

    def __repr__(self):
        return str(self)


class Args:
    def __init__(self, ordered: Sequence[str]):
        self._args = ordered

    @staticmethod
    def by(*, full: str) -> "Args":
        args = shlex.split(full)
        return Args(args)

    @property
    def size(self):
        return len(self._args)

    @property
    def hasmore(self):
        return self.size > 0

    def poll(self) -> tuple[Arg | None, "Args"]:
        """
        consume the head
        """
        if len(self._args) == 0:
            return None, Args(())
        else:
            return Arg.by(self._args[0]), Args(self._args[1:])

    def polling(self) -> Iterable[tuple[Arg, "Args"]]:
        """
        consuming the head
        """
        for i, arg in enumerate(self._args):
            yield Arg(arg), Args(self._args[i + 1:])

    def pop(self) -> tuple[Arg | None, "Args"]:
        """
        consume the last
        """
        if len(self._args) == 0:
            return None, Args(())
        else:
            return Arg.by(self._args[-1]), Args(self._args[0:-1])

    def popping(self) -> Iterable[tuple[Arg, "Args"]]:
        """
        consuming the last
        """
        for i, arg in enumerate(reversed(self._args)):
            yield Arg(arg), Args(self._args[0:-1])

    def __iter__(self):
        return iter(self._args)

    def peekhead(self) -> Arg | None:
        if self.hasmore:
            return Arg.by(self._args[0])
        else:
            return None

    def __str__(self):
        return str(self._args)

    def __repr__(self):
        return str(self)
