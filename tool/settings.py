import json
from typing import Any

from filesystem import File
from serialize import Serializer, FallbackType


def _cast_type(source: FallbackType, t: type):
    res = t()
    for k, v in vars(source).items():
        if hasattr(res, k):
            setattr(res, k, v)
    return res


class SettingsBox:
    def __init__(self, serializer: Serializer, box: File):
        self.box = box
        self.serializer = serializer
        self._name2settings = {}

    def load(self):
        content = self.box.read()
        di: dict[str, Any] = json.loads(content)
        for name, v in di.items():
            settings = self.serializer.dict2obj(v)
            self._name2settings[name] = settings

    def save(self):
        res = {}
        for name, v in self._name2settings.items():
            di = self.serializer.obj2dict(v)
            res[name] = di
        content = json.dumps(res, ensure_ascii=False, indent=2)
        self.box.write(content)

    def get(self, name: str, settings_type: type = Any) -> Any:
        if name in self._name2settings:
            recast = self._name2settings[name]
            if not isinstance(recast, settings_type):
                recast = _cast_type(recast, settings_type)
                self._name2settings[name] = recast
            return recast
        else:
            settings = settings_type()
            self._name2settings[name] = settings
            return settings
