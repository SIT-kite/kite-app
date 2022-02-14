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
import 'package:enough_mail/enough_mail.dart';

class MailService {
  final String email;
  final String password;
  final ImapClient _client = ImapClient(isLogEnabled: true, onBadCertificate: (_) => true);

  MailService(this.email, this.password);

  Future<void> login() async {
    await _client.connectToServer('imap.mail.sit.edu.cn', 993, isSecure: true);
    await _client.login(email, password);
    await _client.listMailboxes();
  }

  Future<FetchImapResult> getInboxMessage([int count = 30]) async {
    if (!_client.isLoggedIn) {
      await login();
    }

    // final boxes = await _client.listMailboxes();
    await _client.selectInbox();
    return await _client.fetchRecentMessages(messageCount: count);
  }
}
