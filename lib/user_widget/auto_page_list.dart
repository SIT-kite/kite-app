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

import 'package:flutter/material.dart';

/// 自动分页组件
///
///
/// 用例分析
///
/// 初次打开时触发
/// 第一次进页面需要刷新加载数据,显示一个转圈加载
///   直到通过回调函数返回一个Widget列表后停止加载，若返回空列表则需显示一些提示
///   当获取出错后显示错误信息并上报异常
///
/// 下拉时刷新页面
///   通过回调函数返回的一个Widget列表进行下拉刷新
///   出错时弹框
///
/// 上拉时加载更多
///   通过回调函数获取下一页的Widget列表,若返回空列表，则表示已加载完毕，需要提示一些东西
///   出错时显示错误
///
class AutoPageList extends StatelessWidget {
  const AutoPageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
