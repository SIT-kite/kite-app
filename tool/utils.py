class Ref:
    def __init__(self, obj=None):
        self.obj = obj


# noinspection PyBroadException
def cast_int(s: str) -> int | None:
    try:
        return int(s)
    except:
        return None


true_list = {
    "y", "yes", "true", "yep", "yeah", "ok"
}


def cast_bool(s: str) -> bool:
    return s.lower() in true_list
