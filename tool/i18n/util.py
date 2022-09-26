from typing import List, Dict, TypeVar

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
