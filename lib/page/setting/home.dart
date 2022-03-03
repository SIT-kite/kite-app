/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

// class HomeSettingPage extends StatefulWidget {
//   const HomeSettingPage({Key? key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _HomeSettingPageState();
// }
//
// class _HomeSettingPageState extends State<HomeSettingPage> {
//   List<HomeFunctionButton> homeItems;
//
//   @override
//   Widget build(BuildContext context) {
//     return ReorderableListView(
//       header: Container(
//         alignment: const Alignment(-0.9, 0),
//         height: 45,
//         padding: const EdgeInsets.only(top: 15),
//         child: const Text('例子'),
//       ),
//       children: list.map((item) {
//         return Container(
//             key: Key(item.toString()),
//             height: 45,
//             width: double.infinity,
//             margin: EdgeInsets.only(top: 5),
//             color: Colors.white,
//             child: Text(item.toString()));
//       }).toList(),
//       onReorder: (int oldIndex, int newIndex) {
//         setState(() {
//           //交换数据
//           if (newIndex > oldIndex) {
//             newIndex -= 1;
//           }
//           final int item = list.removeAt(oldIndex);
//           list.insert(newIndex, item);
//         });
//       },
//     );
//   }
// }
