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
        return self.root.subfi(dart_tool, kite_tool, f"{d}.log")
