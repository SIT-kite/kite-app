import sys

import log
from cmd import CommandList
from filesystem import File, Directory, is_dir
from typing import Sequence

from flutter import Proj
from strings import s
from ui import Terminal, BashTerminal

logo = """
    ██╗  ██╗ ██╗ ████████╗ ███████╗
    ██║ ██╔╝ ██║ ╚══██╔══╝ ██╔════╝
    █████╔╝  ██║    ██║    █████╗
    ██╔═██╗  ██║    ██║    ██╔══╝
    ██║  ██╗ ██║    ██║    ███████╗
    ╚═╝  ╚═╝ ╚═╝    ╚═╝    ╚══════╝
"""

logo_lines = (
    " ██╗  ██╗ ██╗ ████████╗ ███████╗",
    " ██║ ██╔╝ ██║ ╚══██╔══╝ ██╔════╝",
    " █████╔╝  ██║    ██║    █████╗",
    " ██╔═██╗  ██║    ██║    ██╔══╝",
    " ██║  ██╗ ██║    ██║    ███████╗",
    " ╚═╝  ╚═╝ ╚═╝    ╚═╝    ╚══════╝",
)

version = 1


def find_project_root(start: str | Directory, max_depth=20) -> Directory | None:
    """
    find the best match of project root.
    project root always has a "pubspec.yaml" file.
    :param max_depth: how deep the finding can reach
    :param start: where to start
    :return: the project root
    """
    # Go through until upper bound
    if isinstance(start, str):
        start = Directory(start)
    start = start.to_abs()
    max_depth = max(0, max_depth)
    layer = 0
    cur = start
    while True:
        if layer > max_depth:
            return None
        import flutter
        if cur.sub_isfile(flutter.pubspec_yaml):
            return cur
        parent, _ = cur.split()
        if parent is None:
            return None
        else:
            cur = parent
        layer += 1


def shell(*, proj: Proj, terminal: Terminal, cmds: CommandList, args: Sequence[str]):
    terminal.loging << f"Project root found at {s(proj.root)}."
    terminal.both << f"Kite Tool v{version}"
    import yml
    proj.pubspec = yml.load(proj.pubspec_fi().read())
    terminal.both << f"Project loaded: \"{proj.name} {proj.version}\"."
    terminal.both << f"Description: \"{proj.desc}\"."


def main():
    cmdargs = sys.argv[1:] if len(sys.argv) > 1 else ()
    root = find_project_root(start=".")
    if root is not None:
        proj = Proj(root)
        logger = log.FileLogger(proj.kite_log())
        t = BashTerminal(logger)
        cmds = CommandList()
        shell(proj=proj, terminal=t, cmds=cmds, args=cmdargs)
    else:
        print(f"project root not found")


if __name__ == '__main__':
    main()
