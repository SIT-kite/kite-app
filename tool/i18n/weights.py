from tags import *

all_tags = [
    StaticTagType("ftype", weight=2000),
    StaticTagType("activity", weight=600),
    StaticTagType("freshman", weight=500),
    StaticTagType(["expense", "tracker"], weight=500),
    LengthTagType(factor=-10),
    AnyTagType(weight=10000),
]
