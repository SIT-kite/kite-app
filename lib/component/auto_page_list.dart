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
