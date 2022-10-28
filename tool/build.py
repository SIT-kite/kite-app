from io import StringIO
from typing import Iterator, Any, Callable

import fuzzy
from cmd import CommandProtocol
from coroutine import Task, STOP
from tui.colortxt import FG
from tui.colortxt.txt import Palette
from ui import Terminal
from utils import cast_int, cast_bool, useRef, Ref


class InputTask:
    """
    when input is a hash sign "#", the coroutine will abort instantly
    """
    abort_sign = "#"

    def __init__(self, t: Terminal, prompt: str, ref: Ref):
        self.terminal = t
        self.prompt = prompt
        self.ref = ref

    def __call__(self, *args, **kwargs) -> Iterator:
        inputted = self.terminal.input(self.prompt)
        if inputted == InputTask.abort_sign:
            yield STOP
        else:
            self.ref.obj = inputted
            yield


def await_input(
        terminal: Terminal, prompt: str, *, ref: useRef
) -> InputTask:
    return InputTask(terminal, prompt, ref)


_num = Palette(fg=FG.Emerald)
_name = Palette(fg=FG.Azure)
_usrcmd = Palette(fg=FG.Gold)


def _tint_cmd(cmd: CommandProtocol) -> str:
    if hasattr(cmd, "created_by_user"):
        if getattr(cmd, "created_by_user"):
            return _usrcmd.tint(cmd.name)
    return _name.tint(cmd.name)


_TintFunc = Callable[[str], str]


def _build_contents(
        t: Terminal, candidates: dict[str, Any], row: int,
        tint_num: _TintFunc, tint_name: _TintFunc,
):
    s = StringIO()
    for i, pair in enumerate(candidates.items()):
        key, value = pair
        if i != 0 and i % row == 0:
            t << f"👀 {s.getvalue()}"
            s.close()
            s = StringIO()
        else:
            s.write(f"{tint_num(f'#{i}')}={tint_name(key)}\t")
    if s.readable():
        t << f"👀 {s.getvalue()}"
        s.close()


def select_many(
        candidates: dict[str, Any],
        t: Terminal, prompt: str,
        *, ignore_case=True,
        row=4, ref: Ref | Any
) -> Task:
    return _select_many(
        candidates,
        t, prompt, ignore_case=ignore_case,
        row=row, ref=ref,
        tint_num=lambda num: _num.tint(num),
        tint_name=lambda name: _name.tint(name)
    )


def select_many_cmds(
        candidates: dict[str, CommandProtocol],
        t: Terminal, prompt: str,
        *, ignore_case=True,
        row=4, ref: Ref | Any
) -> Task:
    return _select_many(
        candidates,
        t, prompt, ignore_case=ignore_case,
        row=row, ref=ref,
        tint_num=lambda num: _num.tint(num),
        tint_name=lambda cmd: _tint_cmd(candidates[cmd]) if cmd in candidates else _name.tint(cmd)
    )


def _select_many(
        candidates: dict[str, Any],
        t: Terminal, prompt: str,
        *, ignore_case=True,
        row=4, ref: Ref | Any,
        tint_num: _TintFunc, tint_name: _TintFunc,
) -> Task:
    li = list(candidates.items())
    while True:
        _build_contents(t, candidates, row, tint_num, tint_name)
        t << '[multi-select] enter "*" to select all or split each by ",".'
        inputted: str = useRef()
        yield await_input(t, prompt, ref=inputted)
        inputted = inputted.strip()
        if inputted == "*":
            ref.obj = candidates.values()
            yield
        res = []
        failed = False
        for entry in inputted.split(","):
            entry = entry.strip()
            if entry.startswith("#"):
                # numeric mode
                entry = entry.removeprefix("#")
                num = cast_int(entry)
                if num is None:
                    t << f"❗ {entry} isn't an integer, plz try again."
                    failed = True
                    break
                else:
                    key, value = li[num]
                    res.append(value)
            else:
                # name mode
                if ignore_case:
                    entry = entry.lower()
                # name mode
                if entry in candidates:
                    res.append(candidates[entry])
                else:
                    t << f'❗ "{entry}" not found, plz try again.'
                    failed = True
                    break
        if not failed:
            ref.obj = res
            yield


def select_one_cmd(
        candidates: dict[str, Any],
        t: Terminal, prompt: str,
        *, ignore_case=True,
        fuzzy_match=False,
        row=4, ref: Ref | Any
) -> Task:
    return _select_one(
        candidates,
        t, prompt, ignore_case=ignore_case,
        fuzzy_match=fuzzy_match,
        row=row, ref=ref,
        tint_num=lambda num: _num.tint(num),
        tint_name=lambda cmd: _tint_cmd(candidates[cmd]) if cmd in candidates else _name.tint(cmd)
    )


def select_one(
        candidates: dict[str, Any],
        t: Terminal, prompt: str,
        *, ignore_case=True,
        fuzzy_match=False,
        row=4, ref: Ref | Any
) -> Task:
    return _select_one(
        candidates,
        t, prompt, ignore_case=ignore_case,
        fuzzy_match=fuzzy_match,
        row=row, ref=ref,
        tint_num=lambda num: _num.tint(num),
        tint_name=lambda cmd: _name.tint(cmd)
    )


def _select_one(
        candidates: dict[str, Any],
        t: Terminal, prompt: str,
        *, ignore_case=True,
        fuzzy_match=False,
        row=4, ref: Ref | Any,
        tint_num: _TintFunc, tint_name: _TintFunc,
) -> Task:
    def task() -> Iterator:
        li = list(candidates.items())
        while True:
            _build_contents(t, candidates, row, tint_num, tint_name)
            inputted: str = useRef()
            yield await_input(t, prompt, ref=inputted)
            inputted = inputted.strip()
            if inputted.startswith("#"):
                # numeric mode
                inputted = inputted.removeprefix("#")
                num = cast_int(inputted)
                if num is None:
                    t << f"❗ {inputted} isn't an integer, plz try again."
                else:
                    if 0 <= num < len(li):
                        key, value = li[num]
                        ref.obj = value
                        yield
                    else:
                        t << f"❗ {num} is out of range[0,{len(li)}), plz try again."
            else:
                if ignore_case:
                    inputted = inputted.lower()
                # name mode
                if inputted in candidates:
                    ref.obj = candidates[inputted]
                    yield
                elif fuzzy_match:
                    matched, radio = fuzzy.match(inputted, candidates.keys())
                    if radio >= fuzzy.at_least:
                        t << f'do you mean "{matched}"?'
                        inputted = useRef()
                        yield await_input(t, prompt="y/n=", ref=inputted)
                        inputted = inputted.strip()
                        yes = inputted == "" or cast_bool(inputted)
                        if yes:
                            ref.obj = candidates[matched]
                            yield
                        else:
                            t << f"alright, let's start all over again."
                    else:
                        t << f'❗ "{inputted}" not found, plz try again.'
                else:
                    t << f'❗ "{inputted}" not found, plz try again.'

    return task


def input_multiline(
        terminal: Terminal, prompt: Callable[[list[str]], str],
        end_sign="EOF", *, ref: Ref | Any
) -> Task:
    lines = []

    def task() -> Iterator:
        while True:
            inputted = useRef()
            yield await_input(terminal, prompt=prompt(lines), ref=inputted)
            line = inputted.strip()
            if line == end_sign:
                break
            lines.append(line)
        yield

    ref.obj = lines
    return task


def yes_no(
        t: Terminal, *, ref: Ref | Any
) -> Task:
    def task() -> Iterator:
        inputted: str = useRef()
        yield await_input(t, prompt="y/n=", ref=inputted)
        reply = inputted.strip()
        ref.obj = cast_bool(reply)
        yield

    return task
