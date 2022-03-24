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
import 'package:kite/feature/game/page/wordle/widgets/alert_dialog.dart';

typedef MyWidgetBuilder<T> = Widget Function(BuildContext context, T data);

class MyFutureBuilder<T> extends StatelessWidget {
  final Future<T>? future;
  final MyWidgetBuilder<T>? builder;
  final MyWidgetBuilder? onErrorBuilder;
  const MyFutureBuilder({
    Key? key,
    this.future,
    this.builder,
    this.onErrorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return builder == null ? Text(data.toString()) : builder!(context, snapshot.data!);
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            if (error is DioError && error.type == DioErrorType.connectTimeout) {
              Future.delayed(Duration.zero, () async {
                await showAlertDialog(
                  context,
                  title: '网络连接超时',
                  content: [
                    const Text('连接超时,请确认您连接了校园网环境\n(当然也有可能是学校服务器崩了)'),
                  ],
                  actionText: '进入网络工具',
                  onAction: () {
                    Navigator.of(context).popAndPushNamed('/connectivity');
                  },
                );
              });
            }
            Catcher.reportCheckedError(error, snapshot.stackTrace);
            if (onErrorBuilder != null) {
              return onErrorBuilder!(context, error);
            }

            return Center(child: Text(error.toString()));
          } else {
            throw Exception('snapshot has no data or error');
          }
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
