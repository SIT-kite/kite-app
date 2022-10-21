import re
import shlex
from io import StringIO
from typing import Sequence, Iterable, Optional, Union


class Arg:
    def __init__(self, key: str, value: str = None):
        self.key = key.strip()
        if value is not None:
            value = value.strip()
        self.value = value
        self.parent: Optional["Args"] = None
        self.parent_index = 0

    @property
    def name(self) -> str:
        return self.key

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

    @property
    def root(self) -> Optional["Args"]:
        if self.parent is None:
            return None
        return self.parent.root

    @property
    def raw_index(self) -> int:
        if self.parent is None:
            return 0
        else:
            return self.parent_index + self.parent.total_loffset


class ArgPosition:
    def __init__(self, start: int, end: int):
        self.start = start
        self.end = end


# noinspection SpellCheckingInspection
class Args:
    def __init__(self, ordered: Sequence[str]):
        self._args = ordered
        self.parent: Args | None = None
        self.loffset = 0
        """
        the left offset relative to the parent
        """
        self.roffset = 0
        """
        the right offset relative to the parent
        """

    def sub(self, start: int, end: int) -> "Args":
        """
        :param start: included
        :param end: excluded
        """
        sub = Args(self._args[start:end])
        sub.parent = self
        sub.loffset = start
        sub.roffset = len(self._args) - end
        return sub

    def __getitem__(self, item: slice | int) -> Union["Args", Arg]:
        size = len(self._args)
        if size == 0:
            if isinstance(item, slice) and item.start is None and item.stop is None and item.step is None:
                res = Args(())
                res.parent = self
                return res
            else:
                raise Exception("args is empty")
        if isinstance(item, slice):
            start = 0 if item.start is None else item.start
            start = max(0, start)
            end = size if item.stop is None else item.stop
            end = min(end, size)
            return self.sub(start, end)
        elif isinstance(item, int):
            index = item % size
            arg = Arg.by(self._args[index])
            arg.parent = self
            arg.parent_index = index
            return arg
        raise Exception(f"unsupported type {type(item)}")

    @property
    def total_loffset(self) -> int:
        total = 0
        cur = self
        while cur is not None:
            total += cur.loffset
            cur = cur.parent
        return total

    @property
    def total_roffset(self) -> int:
        total = 0
        cur = self
        while cur is not None:
            total += cur.roffset
            cur = cur.parent
        return total

    @staticmethod
    def by(*, full: str) -> "Args":
        args = shlex.split(full)
        return Args(args)

    @property
    def size(self):
        return len(self)

    @property
    def isempty(self) -> bool:
        return len(self) == 0

    def __len__(self):
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
            return self[0], self[1:]

    def polling(self) -> Iterable[tuple[Arg, "Args"]]:
        """
        consuming the head
        """
        for i, arg in enumerate(self._args):
            res = Arg.by(arg)
            res.parent = self
            res.parent_index = i
            yield res, self[i + 1:]

    def pop(self) -> tuple[Arg | None, "Args"]:
        """
        consume the last
        """
        if len(self._args) == 0:
            return None, Args(())
        else:
            return self[-1], self[0:-1]

    def popping(self) -> Iterable[tuple[Arg, "Args"]]:
        """
        consuming the last
        """
        for i, arg in enumerate(reversed(self._args)):
            res = Arg.by(arg)
            res.parent = self
            res.parent_index = i % len(self._args)
            yield res, self[0:-1]

    def __iter__(self):
        return iter(self._args)

    def peekhead(self) -> Arg | None:
        if self.hasmore:
            return self[0]
        else:
            return None

    def located_full(self, target: int) -> tuple[str, ArgPosition]:
        if self.isroot:
            return _join(self._args, target)
        else:
            raise Exception(f"{self} isn't a root args")

    def full(self) -> str:
        if self.isroot:
            return shlex.join(self._args)
        else:
            raise Exception(f"{self} isn't a root args")

    def __str__(self):
        return shlex.join(self._args)

    def __repr__(self):
        return str(self)

    @property
    def isroot(self):
        return self.parent is None

    @property
    def root(self) -> Optional["Args"]:
        cur = self
        while cur.parent is not None:
            cur = cur.parent
        return cur


def _join(split_command: Sequence[str], target: int) -> tuple[str, ArgPosition]:
    """
    Return a tuple:

    [0] = shell-escaped string from *split_command*

    [1] = the *target* argument position
    """
    size = len(split_command)
    start = 0
    end = 0
    counter = 0
    with StringIO() as s:
        for i, arg in enumerate(split_command):
            if i == target:
                start = counter
            quoted = _quote(arg)
            counter += len(quoted)
            if i == target:
                end = counter
            s.write(quoted)
            if i < size - 1:
                s.write(' ')
                counter += 1
        return s.getvalue(), ArgPosition(start, end)


_find_unsafe = re.compile(r'[^\w@%+=:,./-]', re.ASCII).search


def _quote(s):
    """Return a shell-escaped version of the string *s*."""
    if not s:
        return "''"
    if _find_unsafe(s) is None:
        return s

    # use single quotes, and put single quotes into double quotes
    # the string $'b is then quoted as '$'"'"'b'
    return "'" + s.replace("'", "'\"'\"'") + "'"
