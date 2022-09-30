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
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kite/feature/home/entity/home.dart';
import 'package:kite/feature/library/appointment/init.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/route.dart';
import 'package:kite/util/dsl.dart';
import 'package:kite/util/flash.dart';
import 'package:kite/util/strings.dart';

import 'appointment/entity.dart';
import 'appointment/page/notice.dart';
import 'search/page/constant.dart';
import 'search/page/search_delegate.dart';

class NoticeWidget extends StatelessWidget {
  static const noticePreviewCharLimit = 25;
  final ValueNotifier<Notice?> noticeNotifier = ValueNotifier(null);

  NoticeWidget({Key? key}) : super(key: key);

  Widget buildNone() => Container();

  String genNoticePreview(Notice notice) =>
      notice.html.substring(0, min(notice.html.length, noticePreviewCharLimit));

  Widget buildSome(Notice notice) {
    final isRealHtml = guessIsHtml(notice.html);
    return Container(
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.black45),
        ),
      ),
      child: Builder(builder: (context) {
        return ListTile(
          title: Text(isRealHtml ? i18n.libraryNoticeLabel : genNoticePreview(notice),
              style: const TextStyle(color: Colors.blue, fontSize: 18)),
          subtitle: Text(('${i18n.libraryNoticeSendTime}:  ${context.dateFullNum(notice.ts.toLocal())}')),
          trailing: const Icon(
            Icons.notification_important,
            color: Colors.blueAccent,
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LibraryNoticePage(notice, isHtml: isRealHtml);
            }));
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    LibraryAppointmentInitializer.appointmentService.getNotice().then((value) {
      noticeNotifier.value = value;
    });
    return ValueListenableBuilder<Notice?>(
      valueListenable: noticeNotifier,
      builder: (context, value, child) {
        if (value == null) {
          return buildNone();
        } else {
          return buildSome(value);
        }
      },
    );
  }
}

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  /// 随机获取一个名句
  Saying _getRandomSaying() {
    int size = Saying.sayings.length;
    int index = Random.secure().nextInt(size);
    return Saying.sayings[index];
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: FunctionType.library.localized().txt,
      actions: [
        IconButton(
          onPressed: () {
            showSearch(context: context, delegate: SearchBarDelegate());
          },
          icon: const Icon(
            Icons.search,
          ),
        ),
        IconButton(
          onPressed: () async {
            showBasicFlash(context, i18n.libraryAccountManagementBtnTip.txt);
          },
          icon: const Icon(
            Icons.person,
          ),
        ),
      ],
    );
  }

  Widget _buildSayingWidget({
    double? width,
  }) {
    final saying = _getRandomSaying();

    return Column(
      children: [
        // Hardcoded Chinese comma is used. Don't change this.
        ...saying.text.split('，').map((e) {
          return SizedBox(
            width: width,
            child: Center(
              child: Text(e),
            ),
          );
        }).toList(),
        const SizedBox(height: 20),
        SizedBox(
          width: width,
          child: Container(
            alignment: Alignment.bottomRight,
            child: Text(
              '——— ${saying.sayer}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var imageWidth = screenWidth * 0.6;
    var sayingWidth = screenWidth * 0.5;
    return Stack(
      children: [
        Align(alignment: Alignment.topCenter, child: NoticeWidget()),
        Center(
          child: SizedBox(
            height: 400,
            child: Column(
              children: [
                SizedBox(
                  width: imageWidth,
                  child: const Image(
                    image: AssetImage('assets/library/saying.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSayingWidget(
                  width: sayingWidth,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteTable.libraryAppointment);
        },
        child: const Icon(Icons.date_range),
      ),
    );
  }
}
