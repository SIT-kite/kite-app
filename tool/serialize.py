from types import NoneType
from typing import Any
import json
from pydoc import locate

_primitives = (str, int, float, bool, list, dict, tuple, NoneType)


class Object:
    pass


def is_primitive(obj: Any) -> bool:
    return isinstance(obj, _primitives)


def get_fullname(obj: Any):
    klass = obj.__class__
    module = klass.__module__
    if module == 'builtins':
        return klass.__qualname__  # avoid outputs like 'builtins.str'
    return module + '.' + klass.__qualname__


class Serializer:
    """
    A serializer can convert dict or json to an object recursively.
    """

    def __init__(self):
        self._name2type: dict[str, type] = {}
        self._type2name: dict[type, str] = {}
        self.respect_private = None
        self.auto_type = True

    def __setitem__(self, name: str, t: type):
        self._name2type[name] = t
        self._type2name[t] = name

    def __getitem__(self, item: str | type) -> type | str | None:
        if isinstance(item, str):
            if item in self._name2type:
                return self._name2type[item]
        elif isinstance(item, type):
            if item in self._type2name:
                return self._type2name[item]
        return None

    def __lshift__(self, t: type):
        name = get_fullname(t)
        self._name2type[name] = t
        self._type2name[t] = name

    def get_typename(self, obj: Any) -> str:
        t = type(obj)
        typename = self[t]
        if typename is not None:
            return typename
        elif self.auto_type:
            return get_fullname(obj)
        else:
            raise ValueError(f"type<{t}> isn't registered")

    # noinspection PyTypeChecker
    def name2type(self, name: str) -> type:
        t = self[name]
        if t is not None:
            return t
        elif self.auto_type:
            return locate(name)
        else:
            raise ValueError(f"type name<{name}> isn't registered")

    def obj2json(self, obj: Any, indent=2) -> str:
        d = self.obj2dict(obj)
        res = json.dumps(d, ensure_ascii=False, indent=indent)
        return res

    def obj2dict(self, obj: Any) -> Any:
        if is_primitive(obj):
            return obj
        else:
            res = {
                "type": self.get_typename(obj)
            }
            for k, v in vars(obj).items():
                k: str
                if self.respect_private and k.startswith("_"):
                    continue
                res[k] = self.obj2dict(v)
            return res

    def dict2obj(self, d: dict[str, Any]) -> Any:
        if "type" in d:
            typename = d["type"]
            t = self.name2type(typename)
            obj = t()
            for k, v in d.items():
                if k == "type":
                    continue
                if hasattr(obj, k):
                    if isinstance(v, dict):
                        v = self.dict2obj(v)
                    setattr(obj, k, v)
            return obj
        else:
            obj = Object()
            for k, v in d.items():
                setattr(obj, k, v)
            return obj

    def json2obj(self, j: str) -> Any:
        d = json.loads(j)
        res = self.dict2obj(d)
        return res