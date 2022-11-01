import shlex
from typing import Union, Optional, Sequence

from filesystem import File, Pathable, Directory

import subprocess


class DartFi(File):
    sourcename: str

    def __init__(self, path: Union[str, Pathable]):
        super().__init__(path)
        name = self.name
        if name.endswith(".g.dart"):
            self.sourcename = name.removesuffix(".g.dart")
        else:
            self.sourcename = name.removesuffix(".dart")

    @property
    def is_gen(self) -> bool:
        return self.endswith(".g.dart")

    @staticmethod
    def is_dart(fi: File) -> bool:
        return fi.extendswith("dart")

    @staticmethod
    def cast(fi: File) -> Optional["DartFi"]:
        if DartFi.is_dart(fi):
            return DartFi(fi)
        else:
            return None


class DartFormatConf:
    def __init__(self):
        self.length = 120


class DartRunner:
    def __init__(self, root: Directory):
        self.root = root

    def run(self, *, full: str = None, seq: Sequence[str] = None) -> subprocess.Popen:
        if full is not None:
            args = shlex.split(full)
        elif seq is not None:
            args = seq
        else:
            raise Exception("no full or seq given as command line args")
        return subprocess.Popen(
            args=args,
            bufsize=-1, shell=True,
            cwd=self.root.abs_path,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )

    def format(self, config: DartFormatConf) -> subprocess.Popen:
        args = ["dart", "format", "."]
        length = config.length
        if length is not None:
            args.append("-l")
            args.append(str(length))
        return self.run(seq=args)
