import datetime
import ntpath
import os.path
import sys
import traceback
from typing import Sequence, Iterator

import build
import cmd
import log
import strings
from args import Args
from cmd import CommandList, CmdContext, CommandProtocol, CommandExecuteError, CommandArgError
from coroutine import TaskDispatcher, DispatcherState
from filesystem import File, Directory
from flutter import Proj
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
        if cur.sub_isfi(flutter.pubspec_yaml):
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


def clear_old_log(log_dir: Directory):
    now = datetime.datetime.now()
    for logfi in log_dir.listing_fis():
        delta = now - logfi.modify_datetime
        if delta.days > 7:
            logfi.delete()


def main():
    script_path = sys.argv[0]
    script_abs_path = os.path.abspath(script_path)
    parent, _ = ntpath.split(script_abs_path)
    cmdargs = sys.argv[1:] if len(sys.argv) > 1 else ()
    # finding starts with the parent folder of main.py
    root = find_project_root(start=parent)
    if root is not None:
        proj = Proj(root)
        clear_old_log(proj.kite_log_dir)
        logger = log.FileLogger(proj.kite_log)
        File.logger = logger
        Directory.logger = logger
        t = BashTerminal(logger)
        cmds = CommandList(logger=logger)
        shell(proj=proj, cmdlist=cmds, terminal=t, cmdargs=cmdargs)
    else:
        print(f"❌ project root not found")


def shell(*, proj: Proj, cmdlist: CommandList, terminal: Terminal, cmdargs: Sequence[str]):
    terminal.logging << f'Project root found at "{proj.root}".'
    terminal.both << f'🪁 Kite Tool v{version}'
    import yml
    proj.pubspec = yml.load(proj.pubspec_fi.read())
    terminal.both << f'Project loaded: "{proj.name} {proj.version}".'
    terminal.both << f'Description: "{proj.desc}".'
    import kite
    kite.load(proj)
    import loader
    loader.load_modules(terminal, proj)
    load_cmds(proj=proj, cmdlist=cmdlist, terminal=terminal)
    if len(cmdargs) == 0:
        interactive_mode(proj=proj, cmdlist=cmdlist, terminal=terminal)
    else:
        cli_mode(proj=proj, cmdlist=cmdlist, terminal=terminal, cmdargs=cmdargs)
    terminal.both << "🪁 Kite Tool exits."


def log_traceback(terminal: Terminal):
    if terminal.has_logger:
        terminal.logging << traceback.format_exc()
        terminal << "ℹ️ full traceback was printed into log."


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
            terminal.both << f'❗ command<{command.key}> not found.'
            return
        else:
            ctx = CmdContext(proj, terminal, cmdlist, args)
            terminal.both << _get_header_entry(executable)
            try:
                executable.execute_cli(ctx)
            except CommandArgError as e:
                cmd.print_cmdarg_error(terminal, e)
                log_traceback(terminal)
            except CommandExecuteError as e:
                log_traceback(terminal)
            terminal.both << _get_header_existence(executable)


def interactive_mode(*, proj: Proj, cmdlist: CommandList, terminal: Terminal):
    terminal.line(48)
    terminal << '[interactive mode], enter "#" to exit current layer.'
    all_cmd = ', '.join(cmdlist.keys())
    all_cmd_prompt = f"all commands = [{all_cmd}]"

    def running() -> Iterator:
        dispatcher = TaskDispatcher()
        while True:
            terminal << all_cmd_prompt
            select_task = build.select_one(cmdlist.name2cmd, terminal, prompt="cmd=", fuzzy_match=True)
            yield select_task
            executable: CommandProtocol = select_task.result
            terminal.both << _get_header_entry(executable)
            ctx = CmdContext(proj, terminal, cmdlist)
            dispatcher.run(executable.execute_inter(ctx))
            state = dispatcher.dispatch()
            terminal.both << _get_header_existence(executable)
            if state == DispatcherState.Abort:
                yield

    global_dispatcher = TaskDispatcher()
    while True:
        global_dispatcher.run(running())
        global_state = global_dispatcher.dispatch()
        if global_state == DispatcherState.Abort:
            return


if __name__ == '__main__':
    main()
