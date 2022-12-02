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

import 'dart:async';

import 'package:flutter/material.dart';

enum FutureState { loading, failed, end }

typedef PlaceholderWidgetBuilder<T> = Widget Function(BuildContext context, T? data, FutureState state);

class PlaceholderBuilderController<T> {
  late _PlaceholderFutureBuilderState<T> _state;

  void _bindState(State<PlaceholderFutureBuilder<T>> state) => _state = state as _PlaceholderFutureBuilderState<T>;

  Future<T> refresh() => _state.refresh();
}

class PlaceholderFutureBuilder<T> extends StatefulWidget {
  final Future<T>? future;
  final PlaceholderWidgetBuilder<T> builder;
  final PlaceholderBuilderController? controller;

  final Future<T> Function()? futureGetter;

  const PlaceholderFutureBuilder({
    super.key,
    this.future,
    required this.builder,
    this.controller,
    this.futureGetter,
  });

  @override
  State<PlaceholderFutureBuilder<T>> createState() => _PlaceholderFutureBuilderState<T>();
}

class _PlaceholderFutureBuilderState<T> extends State<PlaceholderFutureBuilder<T>> {
  Completer<T> completer = Completer();

  @override
  void initState() {
    widget.controller?._bindState(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      key: UniqueKey(),
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return widget.builder(context, snapshot.data, FutureState.end);
          } else if (snapshot.hasError) {
            return widget.builder(context, null, FutureState.failed);
          } else {
            if (!completer.isCompleted) completer.complete();
            throw Exception('snapshot has no data or error');
          }
        }
        return widget.builder(context, null, FutureState.loading);
      },
    );
  }

  Future<T> refresh() {
    setState(() {});
    return completer.future;
  }

  Future<T> fetchData() async {
    var getter = widget.futureGetter;
    if (getter != null) {
      return await getter();
    }
    var future = widget.future;
    if (future != null) {
      return await future;
    }
    throw UnsupportedError('PlaceholderFutureBuilder requires a Future or FutureGetter');
  }
}
