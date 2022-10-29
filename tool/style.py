from tui.colortxt import FG
from tui.colortxt.txt import Palette


class Style:
    number = Palette(fg=FG.Emerald)
    cmdname = Palette(fg=FG.Azure)
    usrcmdname = Palette(fg=FG.Gold)
    error = Palette(fg=FG.Red)
    inputting = Palette(fg=FG.Rose)
    arrow = Palette(fg=FG.Gold)
    highlight = Palette(fg=FG.Cyan)

    def __init__(self, setter: dict[str, Palette] = None):
        if setter is not None:
            self.merge(setter)

    def merge(self, override: dict[str, Palette]):
        for name, palette in override.items():
            setattr(self, name, override)
