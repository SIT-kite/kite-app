import sys
from filesystem import File, Directory
from typing import Sequence


def shell(cwd: str | Directory, args: Sequence[str]):
    if not isinstance(cwd, Directory):
        cwd = Directory(cwd)


if __name__ == '__main__':
    cmdargs = sys.argv[1:] if len(sys.argv) > 1 else ()
    shell(cwd=Directory("."), args=cmdargs)
