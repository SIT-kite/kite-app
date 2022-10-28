from typing import Generic, TypeVar, Any

T = TypeVar("T")


class Ref(Generic[T]):
    def __init__(self, obj=None):
        self.obj = obj

    def deref(self) -> T:
        return self.obj

    def __eq__(self, other):
        if isinstance(other, Ref):
            return self.obj == other.obj
        else:
            return self.obj == other

    def __getattr__(self, item):
        return getattr(self.obj, item)

    def __setattr__(self, key, value):
        if key == "obj":
            super(Ref, self).__setattr__("obj", value)
        else:
            setattr(self.obj, key, value)

    def __bool__(self) -> bool:
        return bool(self.obj)


def useRef(obj=None) -> Any | Ref: return Ref(obj)


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
