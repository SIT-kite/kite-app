from typing import List, Dict, TypeVar, Callable

T = TypeVar("T")


def split_para(args: List[str],
               heading="", equal="=") -> Dict[str, str]:
    paras = {}
    for arg in args:
        arg.removeprefix(heading)
        name2para = arg.split(equal)
        if len(name2para) == 2:
            paras[name2para[0]] = name2para[1]
    return paras


def check_para_exist(test: Dict[str, str], required: List[str]):
    for name in required:
        if name not in test.keys():
            raise Exception(f"parameter \"{name}\" is missing")


def From(dic: Dict[str, T], Get: str, Or: T = None) -> T:
    if Get not in dic:
        return Or
    return dic[Get]


def getAttrOrSet(obj, name: str, default: Callable[[], T]) -> T:
    if hasattr(obj, name):
        return getattr(obj, name)
    else:
        new = default()
        setattr(obj, name, new)
        return new


class Ref:
    def __init__(self, value=None):
        self.value = value


def contains(small, big) -> bool:
    for i in range(len(big) - len(small) + 1):
        for j in range(len(small)):
            if big[i + j] != small[j]:
                break
        else:
            return True
    return False


def read_fi(path: str, mode="r"):
    with open(path, mode=mode, encoding="UTF-8") as f:
        return f.read()


def write_fi(path: str, content: str, mode="w"):
    with open(path, mode=mode, encoding="UTF-8") as f:
        f.write(content)
