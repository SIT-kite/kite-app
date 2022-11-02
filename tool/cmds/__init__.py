from cmds.add_copyright import AddCopyRightCmd
from cmds.add_module import AddModuleCmd
from cmds.lint import LintCmd
from cmds.run import RunCmd
from cmds.alias import AliasCmd
from cmds.l10n import L10nCmd
from cmds.cli import CliCmd
from cmds.switch import SwitchCmd
from cmds.native_cmd import NativeCmd
from cmd import CommandList


def load_static_cmd(cmdlist: CommandList):
    cmdlist << AddCopyRightCmd
    cmdlist << AddModuleCmd
    # cmdlist << RunCmd
    cmdlist << LintCmd
    cmdlist << AliasCmd
    cmdlist << L10nCmd
    cmdlist << CliCmd
    cmdlist << SwitchCmd
    cmdlist << NativeCmd("git")
    cmdlist << NativeCmd("flutter")
    cmdlist << NativeCmd("dart")
