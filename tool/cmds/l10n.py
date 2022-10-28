from typing import Iterable, Any, Callable

from cmd import CmdContext, CommandArgError, CommandEmptyArgsError
from flutter import Proj


def template_and_others(proj: Proj) -> tuple[str, list[str]]:
    template = proj.template_arb_fi
    template_name = template.name
    others = []
    for fi in proj.l10n_dir.listing_fis():
        if fi.name != template_name:
            others.append(fi.path)
    return template.path, others


def resort(ctx: CmdContext):
    import l10n.resort as res
    for fi in ctx.proj.l10n_dir.listing_fis():
        if fi.extendswith("arb"):
            new = res.resort(fi.read(), res.methods[res.Alphabetical])
            fi.write(new)


def serve(ctx: CmdContext):
    import l10n.serve as ser
    template, others = template_and_others(ctx.proj)
    ser.start(template, others, terminal=ctx.term)


feature2function: dict[str, Callable[[CmdContext], None]] = {
    "resort": resort,
    "serve": serve
}


class L10nCmd:
    name = "l10n"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        args = ctx.args
        if len(args) == 0:  # only None
            raise CommandEmptyArgsError(L10nCmd, args, "no function specified")
        elif len(args) == 1:
            func_name = args[0].full.removeprefix("--")
            if func_name not in feature2function:
                raise CommandArgError(L10nCmd, args[0], f"function<{func_name}> not found")
            else:
                func = feature2function[func_name]
                func(ctx)
        else:  # including None
            raise CommandArgError(L10nCmd, args[1], "only allow one function")

    @staticmethod
    def execute_interactive(ctx: CmdContext) -> Iterable:
        yield

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "l10 --<function>"
        t << "|-- resort: resort .arb files alphabetically"
        t << "|-- serve: watch the change of .arb files"
