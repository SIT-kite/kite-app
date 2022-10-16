from flutter import UsingDeclare

i18n: UsingDeclare
dao: UsingDeclare


def load():
    global i18n, dao
    i18n = UsingDeclare("i18n", [
        "../shared/i18n.dart"
    ])
    dao = UsingDeclare("networking", [
        "../shared/networking.dart"
    ])
