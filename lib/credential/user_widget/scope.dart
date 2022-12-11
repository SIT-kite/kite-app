/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/widgets.dart';
import 'package:kite/credential/entity/credential.dart';
import 'package:kite/events/bus.dart';
import 'package:kite/events/events.dart';

import '../entity/user_type.dart';
import '../init.dart';

class AuthScope extends InheritedWidget {
  final OACredential? oaCredential;
  final DateTime? lastOaAuthTime;
  final FreshmanCredential? freshmanCredential;
  final DateTime? lastFreshmanAuthTime;
  final UserType? lastUserType;

  const AuthScope({
    super.key,
    this.oaCredential,
    this.lastOaAuthTime,
    this.freshmanCredential,
    this.lastFreshmanAuthTime,
    this.lastUserType,
    required super.child,
  });

  static AuthScope of(BuildContext context) {
    final AuthScope? result = context.dependOnInheritedWidgetOfExactType<AuthScope>();
    assert(result != null, 'No AuthScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AuthScope oldWidget) {
    return oaCredential != oldWidget.oaCredential ||
        lastOaAuthTime != oldWidget.lastOaAuthTime ||
        freshmanCredential != oldWidget.freshmanCredential ||
        lastFreshmanAuthTime != oldWidget.lastFreshmanAuthTime ||
        lastUserType != oldWidget.lastUserType;
  }
}

extension AuthScopeEx on BuildContext {
  AuthScope get auth => AuthScope.of(this);
}

class AuthScopeMaker extends StatefulWidget {
  final Widget child;

  const AuthScopeMaker({super.key, required this.child});

  @override
  State<AuthScopeMaker> createState() => _AuthScopeMakerState();
}

class _AuthScopeMakerState extends State<AuthScopeMaker> {
  @override
  void initState() {
    super.initState();
    On.global<CredentialChangeEvent>((event) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final storage = CredentialInit.credential;
    return AuthScope(
      oaCredential: storage.oaCredential,
      lastOaAuthTime: storage.lastOaAuthTime,
      freshmanCredential: storage.freshmanCredential,
      lastFreshmanAuthTime: storage.lastFreshmanAuthTime,
      lastUserType: storage.lastUserType,
      child: widget.child,
    );
  }
}
