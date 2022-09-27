import json
from typing import Callable
from functools import cmp_to_key
import util
from pair import *
import tags
import weights
import split


required_para = [
    "target",
]
ResortMethod = Callable[[RawPairList], PairList]


def do_cleanup(raw_list: RawPairList) -> PairList:
    li, di = convert_pairs(raw_list)
    return li


def do_alphabetically_sort(raw_list: RawPairList, reverse=False) -> PairList:
    li, di = convert_pairs(raw_list)
    if not reverse:
        li.sort(key=lambda x: x.key)
    else:
        li.sort(key=lambda x: ''.join(reversed(x.key)))
    return li


def lexicographical_compr(a: Pair, b: Pair):
    k1 = a.key
    k2 = b.key
    l1 = len(k1)
    l2 = len(k2)
    for i in range(0, min(l1, l2)):
        str1_ch = ord(k1[i])
        str2_ch = ord(k1[i])

        if str1_ch != str2_ch:
            return str1_ch - str2_ch
    # Edge case for strings like
    # a="Liplum" and b="LiplumUwU"
    if l1 != l2:
        return l1 - l2
    else:
        # If none of the above conditions is true,
        # it implies both the strings are equal
        return 0


def do_lexicographical_sort(raw_list: RawPairList) -> PairList:
    li, di = convert_pairs(raw_list)
    li.sort(key=cmp_to_key(lexicographical_compr))
    return li


def lister():
    return []


def attach_tag(p: Pair):
    for tag in weights.all_tags:
        if tag.match(p):
            p_tags = util.getAttrOrSet(p, "tags", lister)
            p_tags.append(tag.tag(p))


def do_tags_sort(raw_list: RawPairList) -> PairList:
    li, di = convert_pairs(raw_list)
    for p in li:
        p.key_parts = split.split_key(p.key)
        attach_tag(p)
    li.sort(key=lambda pr: tags.sum_weight(pr.tags), reverse=True)
    return li


methods: dict[str, ResortMethod] = {
    "cleanup": do_cleanup,
    "alphabetical": lambda li: do_alphabetically_sort(li, reverse=False),
    "-alphabetical": lambda li: do_alphabetically_sort(li, reverse=True),
    "lexicographical": do_lexicographical_sort,
    "tags": do_tags_sort,
}


def wrapper(args):
    paras = util.split_para(args)
    util.check_para_exist(paras, required_para)
    target = paras["target"]
    indent = int(util.From(paras, Get="indent", Or="2"))
    keep_unmatched_meta = util.From(paras, Get="keep_unmatched_meta", Or="n") == "y"
    method_name = util.From(paras, Get="method", Or="cleanup")
    method = util.From(methods, Get=method_name, Or=do_cleanup)
    txt = util.read_fi(target)
    res = resort(txt, method, indent, keep_unmatched_meta)
    util.write_fi(target, res)


def resort(target, method: ResortMethod, indent=2, keep_unmatched_meta=False) -> str:
    l10n = json.loads(target)
    relisted = list(l10n.items())
    pair_list = method(relisted)
    ordered = flatten_pairs(pair_list, keep_unmatched_meta)
    return json.dumps(ordered, ensure_ascii=False, indent=indent)
