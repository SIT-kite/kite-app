from io import StringIO
from typing import Iterator, Any, Collection

import fuzzy
from coroutine import Task, STOP
from ui import Terminal
from utils import cast_int, cast_bool


class InputTask(Task):
    """
    when input is a hash sign "#", the coroutine will abort instantly
    """
    result: str
    abort_sign = "#"

    def __init__(self, t: Terminal, prompt: str):
        super().__init__()
        self.terminal = t
        self.prompt = prompt

    def execute(self) -> Iterator:
        inputted = self.terminal.input(self.prompt)
        if inputted == InputTask.abort_sign:
            yield STOP
        else:
            self.result = inputted
            yield


def await_input(terminal: Terminal, prompt: str) -> InputTask:
    return InputTask(terminal, prompt)


def _build_contents(t: Terminal, candidates: dict[str, Any], row: int):
    li = list(candidates.items())
    s = StringIO()
    for i, pair in enumerate(li):
        key, value = pair
        if i != 0 and i % row == 0:
            t << f"👀 {s.getvalue()}"
            s.close()
            s = StringIO()
        else:
            s.write(f"#{i}={key}, ")
    if s.readable():
        t << f"👀 {s.getvalue()}"
        s.close()


class SelectOneTask(Task):
    result: Any

    def __init__(self, candidates: dict[str, Any], t: Terminal, prompt, fuzzy_match=False, ignore_case=True, row=4):
        super().__init__()
        self.candidates = candidates
        self.t = t
        self.prompt = prompt
        self.fuzzy_match = fuzzy_match
        self.ignore_case = ignore_case
        self.row = max(1, row)

    def execute(self) -> Iterator:
        t = self.t
        li = list(self.candidates.items())
        while True:
            _build_contents(t, self.candidates, self.row)
            input_task = await_input(t, self.prompt)
            yield input_task
            inputted = input_task.result
            if inputted.startswith("#"):
                # numeric mode
                inputted = inputted.removeprefix("#")
                num = cast_int(inputted)
                if num is None:
                    t << f"❗ {inputted} isn't an integer, plz try again."
                else:
                    if 0 <= num < len(li):
                        key, value = li[num]
                        self.result = value
                        yield
                    else:
                        t << f"❗ {num} is out of range[0,{len(li)}), plz try again."
            else:
                if self.ignore_case:
                    inputted = inputted.lower()
                # name mode
                if inputted in self.candidates:
                    self.result = self.candidates[inputted]
                    yield
                elif self.fuzzy_match:
                    matched, radio = fuzzy.match(inputted, self.candidates.keys())
                    if radio >= fuzzy.at_least:
                        t << f'do you mean "{matched}"?'
                        input_task = await_input(t, prompt="y/n=")
                        yield input_task
                        inputted = input_task.result
                        yes = inputted == "" or cast_bool(inputted)
                        if yes:
                            self.result = self.candidates[matched]
                            yield
                        else:
                            t << f"alright, let's start all over again."
                    else:
                        t << f'❗ "{inputted}" not found, plz try again.'
                else:
                    t << f'❗ "{inputted}" not found, plz try again.'


class SelectManyTask(Task):
    result: Collection[Any]

    def __init__(self, candidates: dict[str, Any], t: Terminal, prompt, ignore_case=True, row=4):
        super().__init__()
        self.candidates = candidates
        self.t = t
        self.prompt = prompt
        self.ignore_case = ignore_case
        self.row = max(1, row)

    def execute(self) -> Iterator:
        t = self.t
        li = list(self.candidates.items())
        while True:
            _build_contents(t, self.candidates, self.row)
            t << '[multi-select] enter "*" to select all or split each by ",".'
            input_task = await_input(t, self.prompt)
            yield input_task
            inputted = input_task.result
            if inputted == "*":
                self.result = self.candidates.values()
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
                    if self.ignore_case:
                        entry = entry.lower()
                    # name mode
                    if entry in self.candidates:
                        res.append(self.candidates[entry])
                    else:
                        t << f'❗ "{entry}" not found, plz try again.'
                        failed = True
                        break
            if not failed:
                self.result = res
                yield


def select_many(
        candidates: dict[str, Any],
        terminal: Terminal, prompt: str,
        *, ignore_case=True,
        row=4
) -> SelectManyTask:
    return SelectManyTask(candidates, terminal, prompt, ignore_case, row)


def select_one(
        candidates: dict[str, Any],
        terminal: Terminal, prompt: str,
        *, ignore_case=True,
        fuzzy_match=False,
        row=4
) -> SelectOneTask:
    return SelectOneTask(candidates, terminal, prompt, fuzzy_match, ignore_case, row)
