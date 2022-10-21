from filesystem import Directory
from flutter import Module, CompPage, CompPageType, Proj, Modules
from ui import Terminal


def load_modules(t: Terminal, proj: Proj):
    modules = Modules(proj)
    for folder in proj.module_folder.listing_dirs():
        name = folder.name
        if name not in proj.unmodules:
            module = load(t, proj, module_name=name, parent=folder)
            modules.name2modules[name] = module
    t.both << f"modules loaded: [{', '.join(modules.name2modules.keys())}]"
    proj.modules = modules


def load(t: Terminal, proj: Proj, module_name: str, parent: Directory) -> Module:
    """
    :param module_name:
    :param proj:
    :param t:
    :param parent: lib or parent module
    :return:
    :except DuplicateNameCompError: if a component is already here
    """
    module = Module(module_name)
    files, dirs = parent.lists()
    for fi in files:
        if not fi.extendswith("dart") or fi.path.endswith("g.dart"):
            # only detect .dart file and ignore .g.dart
            continue
        name = fi.name_without_extension
        if name in proj.comps:
            # the file is a component
            comp = proj.comps[name]
            if comp in module.components:
                raise DuplicateNameCompError(comp.name)
            module.add_page(comp, fi)
        elif name in proj.essentials:
            # the file is an essential
            module.essentials[name] = fi
        else:
            t.both << f"❓ {fi.name} isn't a component or an essential in {parent}."
    for folder in dirs:
        name = folder.name
        if name in proj.comps:
            # the folder is a component
            comp = proj.comps[name]
            if comp in module.components:
                raise DuplicateNameCompError(comp.name)
            module.add_page(comp, folder)
        elif is_submodule(folder):
            # the folder is a submodule
            sub = load(t, proj, module_name=name, parent=folder)
            sub.parent = module
            module.sub[name] = sub
    return module


def is_submodule(folder: Directory) -> bool:
    return folder.sub_isfi("using.dart") or folder.sub_isfi("symbol.dart")


class DuplicateNameCompError(Exception):

    def __init__(self, name: str, *args: object) -> None:
        super().__init__(*args)
        self.name = name
