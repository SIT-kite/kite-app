from typing import Callable, Sequence

import cmd
from args import Args, Arg
from cmd import CmdContext, CommandArgsParseError, CommandArgsError
from flutter import ComponentType, UsingDeclare, ModuleCreation, Usings, Components

Mode = Callable[[Arg], None]


def process(args: Args) -> tuple[Components, Usings]:
    excluded: set[ComponentType] = set()
    included: set[ComponentType] = set()
    used: set[UsingDeclare] = set()
    cur_args = args

    def include_mode(arg: Arg):
        module = arg.key
        if module not in ComponentType.all:
            raise CommandArgsError(AddModuleCmd, cur_args, f"{module} isn't a module")
        excluded.add(ComponentType.all[module])

    def exclude_mode(arg: Arg):
        module = arg.key
        if module not in ComponentType.all:
            raise CommandArgsError(AddModuleCmd, cur_args, f"{module} isn't a module")
        included.add(ComponentType.all[module])

    def using_mode(arg: Arg):
        using = arg.key
        if using not in UsingDeclare.all:
            raise CommandArgsError(AddModuleCmd, cur_args, f"{using} isn't a using")
        used.add(UsingDeclare.all[using])

    name2mode = {
        "include": include_mode,
        "exclude": exclude_mode,
        "using": using_mode,
    }

    def check_mode(arg: Arg) -> Mode | None:
        if not arg.ispair and arg.key.startswith("--"):
            mode_name = arg.key.removeprefix("--")
            if mode_name in name2mode:
                return name2mode[mode_name]
        return None

    mode = None
    while cur_args.hasmore:
        mode_pos = check_mode(cur_args.peekhead())
        if mode_pos is not None:
            mode = mode_pos
            _, cur_args = cur_args.poll()
        if mode is None:
            raise CommandArgsParseError(AddModuleCmd, cur_args, "invalid args")
        else:
            cur_arg, cur_args = cur_args.poll()
            if cur_arg.ispair:
                raise CommandArgsParseError(AddModuleCmd, cur_args, f"{cur_arg} can't be a pair")
            mode(cur_arg)
    return tuple(included - excluded), tuple(used)


class AddModuleCmd:
    name = "addmodule"

    @staticmethod
    def execute(ctx: CmdContext):
        if ctx.is_cli:
            AddModuleCmd.cli(ctx)
        else:
            AddModuleCmd.interactive(ctx)

    @staticmethod
    def interactive(ctx: CmdContext):
        pass

    @staticmethod
    def cli(ctx: CmdContext):
        name, extra = ctx.args.poll()
        if name is None:
            raise CommandArgsError(AddModuleCmd, ctx.args, "module name not given")
        components, usings = process(extra)
        res = ModuleCreation(name.key, components, usings)
        ctx.proj.modules.create(res)

    @staticmethod
    def create():
        pass

    @staticmethod
    def help(ctx: CmdContext):
        pass
