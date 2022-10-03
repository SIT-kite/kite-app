import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kite/module/board/init.dart';
import 'package:kite/mock/index.dart';
import 'package:kite/storage/init.dart';

void main() async {
  await init();
  final boardService = BoardInitializer.boardServiceDao;

  test('board get test', () async {
    final list = await boardService.getPictureList(page: 1, count: 20);
    Log.info(list);
  });

  test('board upload test', () async {
    Log.info(Kv.jwt.jwtToken);

    final file = File('C:/Users/zzq/Desktop/Snipaste_2022-08-20_00-21-21.png');
    final bs = await file.readAsBytes();
    await boardService.submitPictures(
      [
        MultipartFile.fromBytes(
          bs,
          contentType: MediaType.parse('image/png'),
        )
      ],
    );
    Log.info('Submit successful');
  });
}
