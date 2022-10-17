import ntpath
import os.path
import sys

import cmd
import log
import strings
from args import Args
from cmd import CommandList, CmdContext, CommandProtocol, CommandExecuteError, CommandArgError
from coroutine import Task, TaskDispatcher
from filesystem import File, Directory, isdir
from typing import Sequence, Iterator, Callable

from flutter import Proj, ComponentType
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


def load_cmds(*, proj: Proj, cmdlist: CommandList, terminal: Terminal):
    import cmds
    cmds.load_static_cmd(cmdlist)
    from cmds.help import HelpCmd
    cmdlist << HelpCmd(cmdlist)


_header_entry_cache = {}
_header_existence_cache = {}
_header_length = 48


def _get_header_entry(command: CommandProtocol) -> str:
    if command in _header_entry_cache:
        return _header_entry_cache[command]
    else:
        line = strings.center_text_in_line(f">>[{command.name}]<<", length=_header_length)
        _header_entry_cache[command] = line
        return line


def _get_header_existence(command: CommandProtocol) -> str:
    if command in _header_existence_cache:
        return _header_existence_cache[command]
    else:
        line = strings.center_text_in_line(f"<<[{command.name}]>>", length=_header_length)
        _header_existence_cache[command] = line
        return line


def main():
    script_path = sys.argv[0]
    script_abs_path = os.path.abspath(script_path)
    parent, _ = ntpath.split(script_abs_path)
    cmdargs = sys.argv[1:] if len(sys.argv) > 1 else ()
    # finding starts with the parent folder of main.py
    root = find_project_root(start=parent)
    if root is not None:
        proj = Proj(root)
        logger = log.FileLogger(proj.kite_log())
        File.logger = logger
        Directory.logger = logger
        t = BashTerminal(logger)
        cmds = CommandList(logger=logger)
        shell(proj=proj, cmdlist=cmds, terminal=t, cmdargs=cmdargs)
    else:
        print(f"project root not found")


def shell(*, proj: Proj, cmdlist: CommandList, terminal: Terminal, cmdargs: Sequence[str]):
    terminal.logging << f'Project root found at "{proj.root}".'
    terminal.both << f'Kite Tool v{version}'
    import yml
    proj.pubspec = yml.load(proj.pubspec_fi().read())
    terminal.both << f'Project loaded: "{proj.name} {proj.version}".'
    terminal.both << f'Description: "{proj.desc}".'
    import kite.using
    kite.using.load()
    import kite.compoenet
    kite.compoenet.load()
    load_cmds(proj=proj, cmdlist=cmdlist, terminal=terminal)
    from args import Args
    if len(cmdargs) == 0:
        interactive_mode(proj=proj, cmdlist=cmdlist, terminal=terminal)
    else:
        cli_mode(proj=proj, cmdlist=cmdlist, terminal=terminal, cmdargs=cmdargs)
    terminal.both << "Kite tool exits."


def cli_mode(*, proj: Proj, cmdlist: CommandList, terminal: Terminal, cmdargs: Sequence[str]):
    args = Args(cmdargs)
    # read first args as command
    command, args = args.poll()
    if command.ispair:
        terminal.both << f'invalid command format "{command}".'
        return
    else:
        executable = cmdlist[command.key]
        if executable is None:
            terminal.both << f'command<{command.key}> not found.'
            return
        else:
            ctx = CmdContext(proj, terminal, cmdlist, args)
            terminal.both << _get_header_entry(executable)
            try:
                executable.execute(ctx)
            except CommandArgError as e:
                cmd.print_cmdarg_error(terminal, e)
            except CommandExecuteError as e:
                pass
            terminal.both << _get_header_existence(executable)


def interactive_mode(*, proj: Proj, cmdlist: CommandList, terminal: Terminal):
    terminal << 'interactive mode is on, enter "#" to exit current layer.'
    all_cmd = ', '.join(cmdlist.keys())
    all_cmd_prompt = f"all commands = [{all_cmd}]"
    while True:
        terminal << all_cmd_prompt
        selected_cmd = terminal.input("cmd=")
        if selected_cmd == "#":
            return
        executable = cmdlist[selected_cmd]
        if executable is not None:
            terminal.both << _get_header_entry(executable)
            ctx = CmdContext(proj, terminal, cmdlist)
            dispatcher = TaskDispatcher()
            dispatcher.run(executable.execute_inter(ctx))
            dispatcher.dispatch()
            terminal.both << _get_header_existence(executable)


if __name__ == '__main__':
    main()
