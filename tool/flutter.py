import re
from typing import Sequence, Literal

from filesystem import Directory, File

dart_tool = ".dart_tool"
kite_tool = ".kite_tool"
pubspec_yaml = "pubspec.yaml"


class Proj:
    def __init__(self, root: Directory | str):
        if isinstance(root, str):
            self.root = Directory(root)
        else:
            self.root = root
        self.pubspec = None
        self.modules = None

    @property
    def name(self) -> str:
        return self.pubspec["name"]

    @property
    def version(self) -> str:
        return self.pubspec["version"]

    @property
    def desc(self) -> str:
        return self.pubspec["description"]

    def pubspec_fi(self) -> File:
        return self.root.subfi(pubspec_yaml)

    def dart_tool(self) -> Directory:
        return self.root.subdir(dart_tool)

    def kite_tool(self) -> Directory:
        return self.root.subdir(dart_tool, kite_tool)

    def kite_log(self) -> File:
        from datetime import date
        d = date.today().isoformat()
        return self.root.subfi(dart_tool, kite_tool, "log", f"{d}.log")

    def lib_folder(self) -> Directory:
        return self.root.subdir("lib")

    def module_folder(self) -> Directory:
        return self.root.subdir("lib", "module")


# noinspection SpellCheckingInspection
class ComponentType:
    all: dict[str, "ComponentType"] = {}

    def __init__(self, name: str):
        self.name = name
        ComponentType.all[name] = self

    def create(self, moduledir: Directory, mode: Literal["file", "dir"]) -> bool:
        if mode == "file":
            pass
        elif mode == "dir":
            pass
        raise Exception(f"unknown module creation mode {mode}")


class UsingDeclare:
    all: dict[str, "UsingDeclare"] = {}

    def __init__(self, name: str):
        self.name = name
        UsingDeclare.all[name] = self


class Module:
    pass


Components = Sequence[ComponentType]
Usings = Sequence[UsingDeclare]


class ModuleCreation:
    def __init__(self, name: str, components: Components, usings: Usings):
        self.name = name
        self.components = components
        self.usings = usings

    def __str__(self):
        components = self.components
        usings = self.usings
        return f"{components=},{usings=}"

    def __repr__(self):
        return str(self)


class Modules:
    def __init__(self, proj: Proj):
        self.proj = proj

    def create(self, creation: ModuleCreation) -> bool:
        pass
