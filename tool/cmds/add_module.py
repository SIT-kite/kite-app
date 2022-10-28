from typing import Callable, TypeVar

from args import Args, Arg, group_args, flatten_args
from cmd import CmdContext, CommandEmptyArgsError, CommandArgError
from flutter import ModuleCreation

Mode = Callable[[Arg], None]


def _check_name(ctx: CmdContext, name_argslist: list[Args]) -> tuple[Arg, str]:
    size = len(name_argslist)
    if size == 0:
        raise CommandEmptyArgsError(AddModuleCmd, ctx.args, "no arg<n> given")
    elif size > 0:
        raise CommandArgError(AddModuleCmd, name_argslist[1][0], "duplicate name specified")
    else:
        name_args = name_argslist[0]
        if name_args.size > 1:
            raise CommandArgError(AddModuleCmd, name_args[1], "duplicate name specified")
        else:
            name_arg = name_args[0]
            if name_arg.ispair:
                raise CommandArgError(AddModuleCmd, name_arg, "arg<n> can't be a pair")
            else:
                return name_arg, name_arg.key


def _get_list(ctx: CmdContext, name: str, grouped: dict[str, list[Args]]) -> list[Arg]:
    if name not in grouped:
        raise CommandEmptyArgsError(AddModuleCmd, ctx.args, "no arg<c> given")
    else:
        return flatten_args(grouped[name])


T = TypeVar("T")


def _resolve(total: dict[str, T], args: list[Arg], kind: str) -> tuple[T]:
    included = set()
    excluded = set()

    def try_find() -> T:
        if name not in total:
            raise CommandArgError(AddModuleCmd, arg, f"{name} isn't a {kind}")
        else:
            return total[name]

    for arg in args:
        name = arg.full
        if name == "*":
            for c in total.values():
                included.add(c)
        else:
            if name.startswith("~"):
                name = name.removeprefix("~")
                excluded.add(try_find())
            else:
                included.add(try_find())
    return tuple(included - excluded)


class AddModuleCmd:
    name = "addmodule"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        grouped = group_args(ctx.args)
        # find name
        if "n" in grouped:
            name_arg, name = _check_name(ctx, grouped["n"])
        else:
            ungrouped = grouped[None]
            name_arg, name = _check_name(ctx, ungrouped)
        if name in ctx.proj.modules:
            raise CommandArgError(AddModuleCmd, name_arg, f"module<{name}> already exists")
        # get names
        component_names = _get_list(ctx, "c", grouped)
        using_names = _get_list(ctx, "u", grouped)
        # resolve
        components = _resolve(ctx.proj.comps, component_names, "component")
        usings = _resolve(ctx.proj.usings, using_names, "usings")
        # creating
        res = ModuleCreation(name, components, usings)
        ctx.proj.modules.create(res)

    @staticmethod
    def execute_interactive(ctx: CmdContext):
        pass

    @staticmethod
    def create():
        pass

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "addmodule --n <name> --c <..components> --u <..using>"
        t << '| ..components: *=all, "~"-prefix=exclude'
        t << '| ..using: *=all, "~"-prefix=exclude'
        t << '| eg: addmodule --n test --c entity service dao --u l10n'
