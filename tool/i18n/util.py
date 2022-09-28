from typing import List, Dict, TypeVar, Callable, Iterable, Any
from difflib import SequenceMatcher
import re

T = TypeVar("T")

all_true = ["true", "yes", "y", "ok"]


def to_bool(s: str, empty_means=False) -> bool:
    if len(s) == 0 and empty_means: # empty_means True
        return True
    else:
        return s.lower() in all_true


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


def From(dic: Dict[str, T], *, Get: str, Or: T | Any = None) -> T:
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


def fuzzy_match(target: str, candidates: Iterable[str]) -> tuple[str, float]:
    largest = None
    largest_num = 0.0
    for candidate in candidates:
        matcher = SequenceMatcher(isjunk=None, a=target, b=candidate)
        ratio = matcher.ratio()
        if largest is None or ratio > largest_num:
            largest = candidate
            largest_num = ratio
    return largest, largest_num


key_regex = re.compile("[A-Za-z0-9_]*$")


def validate_key(key: str) -> bool:
    if len(key) <= 0:
        return False
    if key[0].isupper():
        return False
    if " " in key:
        return False
    if key_regex.match(key) is None:
        return False
    return True
