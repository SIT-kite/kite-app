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
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:kite/session/abstract_session.dart';
import 'package:kite/session/exception.dart';
import 'package:kite/util/dio_utils.dart';
import 'package:kite/util/logger.dart';
import 'package:pointycastle/asymmetric/api.dart';

class LibrarySession extends DefaultSession {
  static const _opacUrl = 'http://210.35.66.106/opac';
  static const _pemUrl = _opacUrl + '/certificate/pem';
  static const _doLoginUrl = _opacUrl + '/reader/doLogin';
  LibrarySession(Dio dio) : super(dio) {
    Log.info('初始化LibrarySession');
  }

  Future<Response> login(String username, String password) async {
    final response = await _login(username, password);
    if (response.data.toString().contains('用户名或密码错误')) {
      throw const CredentialsInvalidException(msg: '用户名或密码错误');
    }
    // TODO: 还有其他错误处理
    return response;
  }

  Future<Response> _login(String username, String password) async {
    String hashedPwd = md5.convert(const Utf8Encoder().convert(password)).toString();
    final pk = await getRSAPublicKey();
    final encrypter = Encrypter(RSA(publicKey: pk));
    final String encryptedPwd = encrypter.encrypt(hashedPwd).base64;
    final response = await post(
      _doLoginUrl,
      data: {
        'vToken': '',
        'rdLoginId': username,
        'p': '',
        'rdPasswd': encryptedPwd,
        'returnUrl': '',
        'password': '',
      },
      options: DioUtils.NON_REDIRECT_OPTION_WITH_FORM_TYPE.copyWith(
        contentType: 'application/x-www-form-urlencoded',
      ),
    );
    return DioUtils.processRedirect(dio, response);
  }

  Future<RSAPublicKey> getRSAPublicKey() async {
    final pemResponse = await get(_pemUrl);
    String publicKeyStr = pemResponse.data;
    final pemFileContent = '-----BEGIN PUBLIC KEY-----\n' + publicKeyStr + '\n-----END PUBLIC KEY-----';

    final parser = RSAKeyParser();
    return parser.parse(pemFileContent) as RSAPublicKey;
  }
}
