import util
from pair import *
import json


class ArbFile:
    path: str
    plist: PairList
    pmap: PairMap
    re: PairList

    def __init__(self, path: str, plist: PairList, pmap: PairMap):
        self.path = path
        self.plist = plist
        self.pmap = pmap
        self.re = []

    def __repr__(self):
        return f"{self.path}"


OrderedJson = OrderedDict[str, Any]
jcoder = json.JSONDecoder(object_hook=OrderedDict)


def load_arb(path=None, content=None) -> tuple[PairList, PairMap]:
    if path is None and content is None:
        raise Exception("No .arb path or content is given")
    if path is not None and content is None:
        content = util.read_fi(path)
    l10n = jcoder.decode(content)
    relisted = list(l10n.items())
    return convert_pairs(relisted)
