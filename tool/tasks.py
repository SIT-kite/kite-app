from typing import Iterator

from coroutine import Task, STOP


class InputTask(Task):
    """
    when input is a hash sign "#", the coroutine will abort instantly
    """
    result: str
    abort_sign = "#"

    def __init__(self, terminal, prompt: str):
        super().__init__()
        self.terminal = terminal
        self.prompt = prompt

    def execute(self) -> Iterator:
        inputted = self.terminal.input(self.prompt)
        if inputted == InputTask.abort_sign:
            yield STOP
        else:
            self.result = inputted
            yield None
