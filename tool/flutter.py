from enum import Enum, auto
from io import StringIO
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
        self.usings: dict[str, "UsingDeclare"] = {}
        self.comps: dict[str, "CompType"] = {}
        self.uncomps: set[str] = set()

    @property
    def name(self) -> str:
        return self.pubspec["name"]

    @property
    def version(self) -> str:
        return self.pubspec["version"]

    @property
    def desc(self) -> str:
        return self.pubspec["description"]

    @property
    def pubspec_fi(self) -> File:
        return self.root.subfi(pubspec_yaml)

    @property
    def dart_tool(self) -> Directory:
        return self.root.subdir(dart_tool)

    @property
    def kite_tool(self) -> Directory:
        return self.root.subdir(dart_tool, kite_tool)

    @property
    def kite_log_dir(self) -> Directory:
        return self.root.subdir(dart_tool, kite_tool, "log")

    @property
    def kite_log(self) -> File:
        from datetime import date
        d = date.today().isoformat()
        return self.root.subfi(dart_tool, kite_tool, "log", f"{d}.log")

    @property
    def lib_folder(self) -> Directory:
        return self.root.subdir("lib")

    @property
    def module_folder(self) -> Directory:
        return self.root.subdir("lib", "module")

    def __str__(self):
        name = self.name
        if name is None:
            return "UNLOADED PROJECT"
        else:
            return name

    def __repr__(self):
        return str(self)


# noinspection SpellCheckingInspection
class CompType:

    def __init__(self, name: str):
        self.name = name

    def create(self, moduledir: Directory, mode: str | Literal["file", "dir"]):
        if mode == "file":
            moduledir.createfi(f"{self.name}.dart")
        elif mode == "dir":
            moduledir.createdir(self.name)
        else:
            raise BaseException(f"unknown module creation mode {mode}")

    def __str__(self):
        return self.name

    def __repr__(self):
        return self.name


# noinspection SpellCheckingInspection
class UsingDeclare:

    def __init__(self, name: str, refs: list[str] = None):
        self.name = name
        if refs is None:
            refs
        self.refs = refs

    # TODO: Known issue: it can't resolve the relative path of submodule
    def create(self, usingfi: File):
        with StringIO() as res:
            for ref in self.refs:
                res.write(f"export '{ref}'\n")
            usingfi.append(res.getvalue())

    def __str__(self):
        return f"{self.name},{self.refs}"

    def __repr__(self):
        return self.name


class CompPageType(Enum):
    File = auto()
    Dir = auto()


# noinspection PyTypeChecker
class CompPage:
    def __init__(self, file: Directory | File, typec: CompPageType):
        self.file = file
        self.type = typec


class Module:
    def __init__(self):
        self.uncomps: dict[str, File] = {}
        self.components: dict[CompType, CompPage] = {}
        self.sub: dict[str, Module] = {}
        self.parent: Module | None = None

    def __getitem__(self, item: CompType) -> CompPage | None:
        if item in self:
            return self.components[item]
        else:
            return None

    def __contains__(self, item: CompType) -> bool:
        return item in self.components


Components = Sequence[CompType]
Usings = Sequence[UsingDeclare]


class ModuleCreation:
    def __init__(self, name: str, components: Components, usings: Usings, simple=False):
        self.name = name.strip()
        self.components = components
        self.usings = usings
        self.simple = simple

    def __str__(self):
        components = self.components
        usings = self.usings
        simple = self.simple
        return f"{components=},{usings=},{simple=}"

    def __repr__(self):
        return str(self)


class Modules:
    def __init__(self, proj: Proj):
        self.proj = proj
        self.name2modules = {}

    def create(self, creation: ModuleCreation):
        name = creation.name
        if name in self.name2modules:
            raise BaseException(f"duplicate module name {name}")
        moduledir = self.proj.module_folder.subdir(name)
        for component in creation.components:
            mode = "file" if creation.simple else "dir"
            component.create(moduledir, mode)
        for using in creation.usings:
            using.create(moduledir.subfi("using.dart"))
