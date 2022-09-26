import json
import pair
import util
from pair import *

OrderedJson = OrderedDict[str, Any]
jcoder = json.JSONDecoder(object_hook=OrderedDict)
required_para = [
    "target"
]


def wrapper(args):
    paras = util.split_para(args)
    util.check_para_exist(paras, required_para)
    target = paras["target"]
    indent = int(util.From(paras, Get="indent", Or="2"))
    keep_unmatched_meta = util.From(paras, Get="keep_unmatched_meta", Or="n") == "y"
    with open(target, mode="r", encoding="UTF-8") as f:
        txt = f.read()
    res = cleanup(txt, indent, keep_unmatched_meta)
    with open(target, mode="w", encoding="UTF-8") as f:
        f.write(res)


def cleanup(target, indent=2, keep_unmatched_meta=False) -> str:
    l10n = json.loads(target)
    relisted = list(l10n.items())
    ordered = _do_clean(relisted, keep_unmatched_meta)
    return json.dumps(ordered, ensure_ascii=False, indent=indent)


def _do_clean(raw_list: RawPairList, keep_unmatched_meta) -> OrderedJson:
    li, di = pair.convert_pairs(raw_list)
    ordered = pair.flatten_pairs(li, keep_unmatched_meta)
    return ordered
