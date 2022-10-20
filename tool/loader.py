from filesystem import Directory
from flutter import Module, CompPage, CompPageType, Proj
from ui import Terminal


def load_modules():
    pass


def load(t: Terminal, proj: Proj, parent: Directory) -> Module:
    """
    :param proj:
    :param t:
    :param parent: lib or parent module
    :return:
    """
    module = Module()
    files, dirs = parent.lists()
    file_names = [f.name_without_extension for f in files]
    dir_names = [d.basename for d in dirs]
    for fi in files:
        name = fi.name_without_extension
        if name in proj.comps:
            comp = proj.comps[name]
            page = CompPage(fi, CompPageType.File)
            module.components[comp] = page
        elif name in proj.uncomps:
            module.uncomps[name] = fi
        else:
            t.both << f"❓ file[{fi}] isn't a component."
    for folder in dirs:
        pass
    return module


class DuplicateNameCompError(BaseException):
    pass
