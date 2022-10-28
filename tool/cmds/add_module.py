from typing import Callable, Sequence

import cmd
from args import Args, Arg
from cmd import CmdContext, CommandArgError, CommandArgError
from flutter import CompType, UsingDeclare, ModuleCreation, Usings, Components
from utils import Ref

Mode = Callable[[Arg], None]


def process(args: Args) -> tuple[Components, Usings, bool]:
    excluded: set[CompType] = set()
    included: set[CompType] = set()
    used: set[UsingDeclare] = set()
    simple_module = Ref(False)
    cur_args = args

    def include_mode(arg: Arg):
        module = arg.key
        if module == "*":
            for c in CompType.all.values():
                included.add(c)
        else:
            if module not in CompType.all:
                raise CommandArgError(AddModuleCmd, arg, f"{module} isn't a module")
            included.add(CompType.all[module])

    def exclude_mode(arg: Arg):
        module = arg.key
        if module == "*":
            for c in CompType.all.values():
                excluded.add(c)
        else:
            if module not in CompType.all:
                raise CommandArgError(AddModuleCmd, arg, f"{module} isn't a module")
            excluded.add(CompType.all[module])

    def using_mode(arg: Arg):
        using = arg.key
        if using == "*":
            for u in UsingDeclare.all.values():
                used.add(u)
        else:
            if using not in UsingDeclare.all:
                raise CommandArgError(AddModuleCmd, arg, f"{using} isn't a using")
            used.add(UsingDeclare.all[using])

    def simple_mode(arg: Arg):
        simple_module.obj = True

    name2mode = {
        "include": include_mode,
        "exclude": exclude_mode,
        "using": using_mode,
        "simple": simple_mode,
    }

    def check_mode(arg: Arg) -> Mode | None:
        if not arg.ispair and arg.key.startswith("--"):
            mode_name = arg.key.removeprefix("--")
            if mode_name in name2mode:
                return name2mode[mode_name]
        return None

    mode = None
    while cur_args.hasmore:
        head_arg = cur_args.peekhead()
        mode_pos = check_mode(head_arg)
        if mode_pos is not None:
            mode = mode_pos
            _, cur_args = cur_args.poll()
        if mode is None:
            raise CommandArgError(AddModuleCmd, head_arg, "invalid args")
        else:
            cur_arg, cur_args = cur_args.poll()
            if cur_arg.ispair:
                raise CommandArgError(AddModuleCmd, cur_arg, f"{cur_arg} can't be a pair")
            mode(cur_arg)
    return tuple(included - excluded), tuple(used), simple_module.deref()


class AddModuleCmd:
    name = "addmodule"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        name, extra = ctx.args.poll()
        if name is None:
            raise CommandArgError(AddModuleCmd, None, "module name not given")
        components, usings, simple = process(extra)
        res = ModuleCreation(name.key, components, usings)
        ctx.proj.modules.create(res)

    @staticmethod
    def execute_interactive(ctx: CmdContext):
        pass

    @staticmethod
    def create():
        pass

    @staticmethod
    def help(ctx: CmdContext):
        pass
