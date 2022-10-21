from typing import Union, Optional

from filesystem import File, Pathable


class DartFi(File):
    sourcename: str

    def __init__(self, path: Union[str, Pathable]):
        super().__init__(path)
        name = self.name
        if name.endswith(".g.dart"):
            self.sourcename = name.removesuffix(".g.dart")
        else:
            self.sourcename = name.removesuffix(".dart")

    @property
    def is_gen(self) -> bool:
        return self.endswith(".g.dart")

    @staticmethod
    def is_dart(fi: File) -> bool:
        return fi.extendswith("dart")

    @staticmethod
    def cast_dart(fi: File) -> Optional["DartFi"]:
        if DartFi.is_dart(fi):
            return DartFi(fi)
        else:
            return None
