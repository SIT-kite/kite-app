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

import 'package:catcher/catcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kite/route.dart';

typedef MyWidgetBuilder<T> = Widget Function(BuildContext context, T data);

class MyFutureBuilderController {
  late State<MyFutureBuilder> _state;
  void _bindState(State<MyFutureBuilder> state) => _state = state;

  void refresh() => (_state as _MyFutureBuilderState).refresh();
}

class MyFutureBuilder<T> extends StatefulWidget {
  final Future<T>? future;
  final MyWidgetBuilder<T>? builder;
  final MyWidgetBuilder? onErrorBuilder;
  final MyFutureBuilderController? controller;
  const MyFutureBuilder({
    Key? key,
    required this.future,
    required this.builder,
    this.onErrorBuilder,
    this.controller,
  }) : super(key: key);

  @override
  State<MyFutureBuilder<T>> createState() => _MyFutureBuilderState<T>();
}

class _MyFutureBuilderState<T> extends State<MyFutureBuilder<T>> {
  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      key: UniqueKey(),
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return widget.builder == null ? Text(data.toString()) : widget.builder!(context, snapshot.data as T);
          } else if (snapshot.hasError) {
            final error = snapshot.error;

            // 单独处理网络连接错误，且不上报
            if (error is DioError && (error).type == DioErrorType.connectTimeout) {
              return Center(
                child: Column(
                  children: [
                    const Text('网络连接超时，请检查是否连接到校园网环境'),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pushReplacementNamed(RouteTable.connectivity),
                      child: const Text('进入网络工具检查'),
                    )
                  ],
                ),
              );
            }

            Catcher.reportCheckedError(error, snapshot.stackTrace);

            if (widget.onErrorBuilder != null) {
              return widget.onErrorBuilder!(context, error);
            }

            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(error.toString()),
                  ],
                ),
              ),
            );
          } else {
            throw Exception('snapshot has no data or error');
          }
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void initState() {
    if (widget.controller != null) widget.controller?._bindState(this);
    super.initState();
  }
}
