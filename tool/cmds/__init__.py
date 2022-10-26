from cmds.add_copyright import AddCopyRightCmd
from cmds.add_module import AddModuleCmd
from cmds.lint import LintCmd
from cmds.run import RunCmd
from cmd import CommandList


def load_static_cmd(cmdlist: CommandList):
    cmdlist << AddCopyRightCmd
    cmdlist << RunCmd
    cmdlist << LintCmd
