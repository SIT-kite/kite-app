import re
import shlex
from io import StringIO
from typing import Sequence, Iterable, Optional, Union, TypeVar, Callable

_empty_args = ()
T = TypeVar("T")


class Arg:
    def __init__(self, key: str, value: str = None):
        self.key = key.strip()
        if value is not None:
            value = value.strip()
        self.value = value
        self.parent: Optional["Args"] = None
        self.parent_index = 0

    def __copy__(self) -> "Arg":
        new = Arg(self.key, self.value)
        new.parent = self.parent
        new.parent_index = self.parent_index
        return new

    def copy(self, **kwargs) -> "Arg":
        cloned = self.__copy__()
        for k, v in kwargs.items():
            setattr(cloned, k, v)
        return cloned

    @property
    def name(self) -> str:
        return self.key

    @property
    def ispair(self) -> bool:
        return self.value is not None

    def startswith(self, prefix: str) -> bool:
        return self.key.startswith(prefix)

    def endswith(self, suffix: str) -> bool:
        return self.key.endswith(suffix)

    def removeprefix(self, prefix) -> str:
        return self.key.removeprefix(prefix)

    def removesuffix(self, suffix) -> str:
        return self.key.removesuffix(suffix)

    @staticmethod
    def by(arg: str) -> "Arg":
        parts = arg.split("=")
        if len(parts) == 1:
            return Arg(key=parts[0])
        else:
            return Arg(key=parts[0], value=parts[1])

    def __str__(self):
        if self.ispair:
            return f"{self.key}={self.value}"
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

    # noinspection PyProtectedMember
    def __add__(self, args: "Args") -> "Args":
        """
        plus operator overloading
        :param args:  added at last
        :return: a new Args object with no parent
        """
        inner = list(args._args)
        inner.append(self)
        res = Args.lateinit()
        res._args = res.copy_args(inner)
        return res

    def __eq__(self, b):
        if isinstance(b, Arg):
            return self.key == b.key and \
                   self.value == b.value and \
                   self.parent == b.parent and \
                   self.parent_index == b.parent_index
        else:
            return False


class ArgPosition:
    def __init__(self, start: int, end: int):
        self.start = start
        self.end = end


# noinspection SpellCheckingInspection
class Args:
    """
    Args is a pure data class whose fields are immutable
    and all methods are pure that return a new Args object.

    You should never change the inner list [Args.ordered].
    """

    def __init__(self, args: Sequence[Arg]):
        """
        :param args: [lateinit] whose parent and parent_index should be initialized to this.
        """
        self._args = args
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
        subargs = []
        sub = Args.lateinit()
        for i, arg in enumerate(self._args[start:end]):
            subargs.append(arg.copy(parent=sub, parent_index=i))
        sub._args = subargs
        sub.parent = self
        sub.loffset = start
        sub.roffset = len(self._args) - end
        return sub

    def __getitem__(self, item: slice | int) -> Union["Args", Arg, None]:
        size = len(self._args)
        if size == 0:
            if isinstance(item, slice) and item.start is None and item.stop is None and item.step is None:
                return self.sub_empty()
            elif isinstance(item, int):
                return None
            else:
                raise Exception("args is empty")
        if isinstance(item, slice):
            start = 0 if item.start is None else item.start
            start = max(0, start)
            end = size if item.stop is None else item.stop
            end = min(end, size)
            if start <= end:
                return self.sub(start, end)
            else:
                return self.sub_empty()
        elif isinstance(item, int):
            index = item % size
            return self._args[index]
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
    def by(*, full: str = None, seq: Sequence[str] = None) -> "Args":
        if full is not None:
            args = shlex.split(full)
        elif seq is not None:
            args = seq
        else:
            raise ValueError("neither full nor seq is given")
        res = Args.lateinit()
        res._args = res.gen_args(args)
        return res

    def sub_empty(self) -> "Args":
        sub = Args(_empty_args)
        sub.parent = self
        return sub

    @staticmethod
    def lateinit() -> "Args":
        return Args(_empty_args)

    def gen_args(self, raw: Sequence[str]) -> Sequence[Arg]:
        res = []
        for i, s in enumerate(raw):
            arg = Arg.by(s)
            arg.parent = self
            arg.parent_index = i
            res.append(arg)
        return res

    def copy_args(self, args: Sequence[Arg]) -> Sequence[Arg]:
        res = []
        for i, arg in enumerate(args):
            res.append(arg.copy(parent=self, parent_index=i))
        return res

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
            return None, self.sub_empty()
        else:
            return self[0], self[1:]

    def polling(self) -> Iterable[tuple[Arg, "Args"]]:
        """
        consuming the head
        """
        for i in range(len(self._args)):
            yield self[i], self[i + 1:]

    def pop(self) -> tuple[Arg | None, "Args"]:
        """
        consume the last
        """
        if len(self._args) == 0:
            return None, self.sub_empty()
        else:
            return self[-1], self[0:-1]

    def popping(self) -> Iterable[tuple[Arg, "Args"]]:
        """
        consuming the last
        """
        for i in range(len(self._args)):
            yield self[-i], self[0:-i]

    def __add__(self, arg: Arg | str) -> "Args":
        """
        plus operator overloading
        :param arg: added at last
        :return: a new Args object with no parent
        """
        if isinstance(arg, str):
            arg = Arg.by(arg)
        inner = list(self._args)
        inner.insert(0, arg)
        res = Args.lateinit()
        res._args = res.copy_args(inner)
        return res

    def __iter__(self) -> Iterable[Arg]:
        return iter(self._args)

    def peekhead(self) -> Arg | None:
        if self.hasmore:
            return self[0]
        else:
            return None

    def located_full(self, target: int) -> tuple[str, ArgPosition]:
        if self.isroot:
            return _join_pos(self._args, target, mapping=str)
        else:
            raise Exception(f"{self} isn't a root args")

    def full(self) -> str:
        if self.isroot:
            return _join(self._args, mapping=str)
        else:
            raise Exception(f"{self} isn't a root args")

    def __str__(self):
        return _join(self._args, mapping=str)

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


def _join(split_command, mapping: Callable[[T], str] = None):
    """Return a shell-escaped string from *split_command*."""
    return ' '.join(_quote(arg) if mapping is None else _quote(mapping(arg)) for arg in split_command)


def _join_pos(split_command: Sequence[T], target: int, mapping: Callable[[T], str] = None) -> tuple[str, ArgPosition]:
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
            if mapping is not None:
                arg = mapping(arg)
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


def split_multicmd(full: Args, separator="+") -> Sequence[Args]:
    """
    split multi-cmd by [separator].
    :return: a list of cmd args with no parent
    """
    res = []
    queue = []
    args = Args.lateinit()
    total = 0
    for i, arg in enumerate(full):
        if not arg.ispair and arg.key == separator:
            if len(queue) > 0:
                args._args = queue
                res.append(args)
                args = Args.lateinit()
                queue = []
        else:
            queue.append(arg.copy(parent=args, parent_inex=total - i))
        total += 1
    if len(queue) > 0:
        args._args = queue
        res.append(args)
    return res


def _get_or(di: dict, key, fallback) -> T:
    if key in di:
        return di[key]
    else:
        v = fallback()
        di[key] = v
        return v


def _append_group(di, group, args):
    grouped: list[Args] = _get_or(di, group, fallback=list)
    grouped.append(args)


def group_args(args: Args, group_head: str = "--") -> dict[str | None, list[Args]]:
    """
    grouped by "--xxx" as default.
    :return: {*group_name:[*matched_args],None:[ungrouped]}
    """
    res = {}
    group = None
    grouped_start = -1
    cur_group_start = 0
    for i, arg in enumerate(args):
        if not arg.ispair and arg.startswith(group_head):
            if grouped_start < 0:
                grouped_start = i
            # it's a group. now group up the former.
            if group is not None:
                # plus 1 to ignore group name itself
                _append_group(res, group, args[cur_group_start + 1:i])
            group = arg.removeprefix(group_head)
            cur_group_start = i
    if group is not None:
        _append_group(res, group, args[cur_group_start + 1:args.size])
    if grouped_start < 0:
        grouped_start = args.size
    _append_group(res, None, args[0:grouped_start])
    return res
