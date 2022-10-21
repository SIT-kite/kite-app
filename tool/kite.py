from flutter import CompType, Proj, UsingDeclare


def load(proj: Proj):
    load_comps(proj)
    load_usings(proj)
    load_essentials(proj)
    load_unmodule(proj)


def load_comps(proj: Proj):
    proj.add_comp(CompType("entity"))
    proj.add_comp(CompType("dao"))
    proj.add_comp(CompType("storage"))
    proj.add_comp(CompType("service"))
    proj.add_comp(CompType("page"))
    proj.add_comp(CompType("mock"))
    proj.add_comp(CompType("cache"))
    proj.add_comp(CompType("user_widget"))


def load_usings(proj: Proj):
    proj.add_using(UsingDeclare("i18n", [
        "../shared/i18n.dart"
    ]))
    proj.add_using(UsingDeclare("networking", [
        "../shared/networking.dart"
    ]))


def load_essentials(proj: Proj):
    proj.add_essentials("init")
    proj.add_essentials("using")
    proj.add_essentials("symbol")


def load_unmodule(proj: Proj):
    proj.add_unmodule("shared")
