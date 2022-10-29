from io import StringIO
from typing import Iterator, Any, Callable

import fuzzy
from cmd import CommandLike, CmdContext
from coroutine import Task, STOP
from utils import cast_int, cast_bool, useRef, Ref


def await_input(
        ctx: CmdContext, prompt: str, *, ref: useRef,
        abort_sign="#"
) -> Task:
    """
    when input is a hash sign "#", the coroutine will abort instantly
    """

    def task():
        inputted = ctx.term.input(ctx.style.inputting(prompt))
        if inputted == abort_sign:
            yield STOP
        else:
            ref.obj = inputted
            yield

    return task


def _tint_cmd(ctx: CmdContext, cmd: CommandLike) -> str:
    if hasattr(cmd, "created_by_user"):
        if getattr(cmd, "created_by_user"):
            return ctx.style.usrcmdname(cmd.name)
    return ctx.style.cmdname(cmd.name)


_TintFunc = Callable[[str], str]


def _build_contents(
        ctx: CmdContext, candidates: dict[str, Any], row: int,
        tint_num: _TintFunc, tint_name: _TintFunc,
):
    s = StringIO()
    t = ctx.term
    for i, pair in enumerate(candidates.items()):
        key, value = pair
        if i != 0 and i % row == 0:
            t << f"👀 {s.getvalue()}"
            s.close()
            s = StringIO()
        s.write(f"{tint_num(f'#{i}')}={tint_name(key)}\t")
    if s.readable():
        t << f"👀 {s.getvalue()}"
        s.close()


def select_many(
        candidates: dict[str, Any],
        ctx: CmdContext, prompt: str,
        *, ignore_case=True,
        row=4, ref: Ref | Any
) -> Task:
    return _select_many(
        candidates,
        ctx, prompt, ignore_case=ignore_case,
        row=row, ref=ref,
        tint_num=lambda num: ctx.style.number(num),
        tint_name=lambda name: ctx.style.cmdname(name)
    )


def select_many_cmds(
        candidates: dict[str, CommandLike],
        ctx: CmdContext, prompt: str,
        *, ignore_case=True,
        row=4, ref: Ref | Any
) -> Task:
    return _select_many(
        candidates,
        ctx, prompt, ignore_case=ignore_case,
        row=row, ref=ref,
        tint_num=lambda num: ctx.style.number(num),
        tint_name=lambda cmd: _tint_cmd(ctx, candidates[cmd]) if cmd in candidates else ctx.style.cmdname(cmd)
    )


def _select_many(
        candidates: dict[str, Any],
        ctx: CmdContext, prompt: str,
        *, ignore_case=True,
        row=4, ref: Ref | Any,
        tint_num: _TintFunc, tint_name: _TintFunc,
) -> Task:
    li = list(candidates.items())
    t = ctx.term
    while True:
        _build_contents(ctx, candidates, row, tint_num, tint_name)
        t << '[multi-select] enter "*" to select all or split each by ",".'
        inputted: str = useRef()
        yield await_input(ctx, prompt, ref=inputted)
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
        ctx: CmdContext, prompt: str,
        *, ignore_case=True,
        fuzzy_match=False,
        row=4, ref: Ref | Any
) -> Task:
    return _select_one(
        candidates,
        ctx, prompt, ignore_case=ignore_case,
        fuzzy_match=fuzzy_match,
        row=row, ref=ref,
        tint_num=lambda num: ctx.style.number(num),
        tint_name=lambda cmd: _tint_cmd(ctx, candidates[cmd]) if cmd in candidates else ctx.style.cmdname(cmd)
    )


def select_one(
        candidates: dict[str, Any],
        ctx: CmdContext, prompt: str,
        *, ignore_case=True,
        fuzzy_match=False,
        row=4, ref: Ref | Any
) -> Task:
    return _select_one(
        candidates,
        ctx, prompt, ignore_case=ignore_case,
        fuzzy_match=fuzzy_match,
        row=row, ref=ref,
        tint_num=lambda num: ctx.style.number(num),
        tint_name=lambda cmd: ctx.style.cmdname(cmd)
    )


def _select_one(
        candidates: dict[str, Any],
        ctx: CmdContext, prompt: str,
        *, ignore_case=True,
        fuzzy_match=False,
        row=4, ref: Ref | Any,
        tint_num: _TintFunc, tint_name: _TintFunc,
) -> Task:
    def task() -> Iterator:
        t = ctx.term
        li = list(candidates.items())
        while True:
            _build_contents(ctx, candidates, row, tint_num, tint_name)
            inputted: str = useRef()
            yield await_input(ctx, prompt, ref=inputted)
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
                        yield await_input(ctx, prompt="y/n=", ref=inputted)
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
        ctx: CmdContext, prompt: Callable[[list[str]], str],
        end_sign="EOF", *, ref: Ref | Any
) -> Task:
    lines = []

    def task() -> Iterator:
        while True:
            inputted = useRef()
            yield await_input(ctx, prompt=prompt(lines), ref=inputted)
            line = inputted.strip()
            if line == end_sign:
                break
            lines.append(line)
        yield

    ref.obj = lines
    return task


def yes_no(
        ctx: CmdContext, *, ref: Ref | Any
) -> Task:
    def task() -> Iterator:
        inputted: str = useRef()
        yield await_input(ctx, prompt="y/n=", ref=inputted)
        reply = inputted.strip()
        ref.obj = cast_bool(reply)
        yield

    return task
