from io import StringIO
from enum import Enum, auto


class Align(Enum):
    Left = auto()
    Right = auto()


def center_text_in_line(
        text: str, length: int,
        align: Align = Align.Left,
        repeat: str = "-"
) -> str:
    rest = length - len(text)
    half = rest // 2
    if align == Align.Left:
        left = half
        right = rest - half
    else:
        left = rest - half
        right = half
    with StringIO() as s:
        for i in range(left):
            s.write(repeat)
        s.write(text)
        for i in range(right):
            s.write(repeat)
        return s.getvalue()
