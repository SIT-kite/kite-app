import os


COPYRIGHT_STRING = \
"""/*
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


def add_copyright(content: str) -> str:
    return COPYRIGHT_STRING + content


def walk(file: str):
    if not file.endswith('.dart') or file.endswith('.g.dart'):
        return

    with open(file, 'r', encoding='utf-8') as fp:
        content = fp.read()

    if not already_has_copyright(content):
        with open(file, 'w', encoding='utf-8') as fp:
            fp.write(add_copyright(content))


if __name__ == '__main__':
    for root, dirs, files in os.walk("../../lib/", topdown=False):
        for name in files:
            complete_path = os.path.join(root, name)
            walk(complete_path)
            print(complete_path)
