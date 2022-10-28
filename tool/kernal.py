from typing import Protocol


class BackgroundTask(Protocol):
    name: str

    def terminate(self):
        pass


class Background:
    def __init__(self):
        self._tasks: dict[str, BackgroundTask] = {}

    def __contains__(self, name: str):
        return name in self._tasks

    def __lshift__(self, task: BackgroundTask):
        self.add_task(task)

    def add_task(self, task: BackgroundTask):
        name = task.name
        if name in self._tasks:
            self._tasks[name].terminate()
        self._tasks[name] = task


class Kernel:
    def __init__(self):
        self.background = Background()
