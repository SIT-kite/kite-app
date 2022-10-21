from cmd import CmdContext, CommandArgError
from filesystem import File

COPYRIGHT_STRING = """
/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
"""


def already_has_copyright(content: str) -> bool:
    """ 通过判断前 5 行是否有 copyright 字样, 判断是否存在版权信息 """
    return 'copyright' in (''.join(content.split('\n')[:5])).lower()


def need_copyright(fi: File) -> bool:
    return fi.extendswith(".dart") and not fi.endswith("g.dart")


class AddCopyRightCmd:
    name = "addcopyright"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        if not ctx.args.isempty:
            raise CommandArgError(AddCopyRightCmd, ctx.args[0], "no arg required")
        AddCopyRightCmd.execute(ctx)

    @staticmethod
    def execute_inter(ctx: CmdContext):
        AddCopyRightCmd.execute(ctx)

    @staticmethod
    def execute(ctx: CmdContext):
        for source in ctx.proj.lib_folder.walking(when=need_copyright):
            content = source.read(silent=True)
            if not already_has_copyright(content):
                new = COPYRIGHT_STRING + content
                source.write(new)
                ctx.term.both << f"📄 {source}"

    @staticmethod
    def help(ctx: CmdContext):
        ctx.term << "insert copyright at head of .dart files in /lib."
