from cmds.add_copyright import AddCopyRightCmd
from cmds.add_module import AddModuleCmd
from cmd import CommandList


def load_static_cmd(cmdlist: CommandList):
    cmdlist << AddCopyRightCmd
    # cmdlist << AddModuleCmd
