from threading import Thread
from typing import Iterable, Callable

from build import select_one
from cmd import CmdContext, CommandArgError, CommandEmptyArgsError, CommandLike
from filesystem import File
from project import Proj
from utils import useRef


class ServeTask:
    name = "l10n_serve"

    def __init__(self):
        self.running = True

    def terminate(self):
        self.running = False


def template_and_others(proj: Proj) -> tuple[File, list[File]]:
    template = proj.template_arb_fi
    template_name = template.name
    others = []
    for fi in proj.l10n_dir.listing_fis():
        if fi.name != template_name:
            others.append(fi)
    return template, others


def resort(ctx: CmdContext):
    import l10n.resort as res
    for fi in ctx.proj.l10n_dir.listing_fis():
        if fi.extendswith("arb"):
            new = res.resort(fi.read(), res.methods[res.Alphabetical])
            fi.write(new)
            ctx.term << f"{fi.path} resorted."


def serve(ctx: CmdContext):
    import l10n.serve as ser
    template, others = template_and_others(ctx.proj)
    task = ServeTask()
    thread = Thread(
        target=lambda: ser.start(
            template.path,
            [f.path for f in others],
            terminal=ctx.term,
            is_running=lambda: task.running)
    )
    thread.daemon = True
    ctx.proj.kernel.background << task
    ctx.term << "l10n is serving in background"


name2function: dict[str, Callable[[CmdContext], None]] = {
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
            if func_name not in name2function:
                raise CommandArgError(L10nCmd, args[0], f"function<{func_name}> not found")
            else:
                func = name2function[func_name]
                func(ctx)
        else:  # including None
            raise CommandArgError(L10nCmd, args[1], "only allow one function")

    @staticmethod
    def execute_interactive(ctx: CmdContext) -> Iterable:
        selected = useRef()
        yield select_one(ctx, name2function, prompt="func=", fuzzy_match=True, ref=selected)
        selected(ctx)

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "l10 resort: resort .arb files alphabetically"
        t << "l10 serve: watch the change of .arb files"
