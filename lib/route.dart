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
import 'package:kite/home/page/index.dart';

import 'package:kite/navigation/static_route.dart';
import 'package:kite/override/entity.dart';
import 'package:kite/settings/page/index.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/alert_dialog.dart';

import 'module/symbol.dart';
import 'module/simple_page/page/browser.dart';
import 'navigation/route.dart';
import 'util/user.dart';

class RouteTable {
  RouteTable._();
  static const root = '/';
  static const home = '/home';
  static const reportTemp = '/report_temp';
  static const login = '/login';
  static const welcome = '/welcome';
  static const about = '/about';
  static const expense = '/expense';
  static const connectivity = '/connectivity';
  static const campusCard = '/campusCard';
  static const electricityBill = '/electricity_bill';
  static const examResult = '/exam_result';
  static const application = '/application';
  static const game = '/game';
  static const game2048 = '$game/2048';
  static const gameWordle = '$game/wordle';
  static const gameComposeSit = '$game/composeSit';
  static const gameTetris = '$game/tetris';
  static const wiki = '/wiki';
  static const library = '/library';
  static const libraryAppointment = '$library/appointment';
  static const market = '/market';
  static const timetable = '/timetable';
  static const timetableImport = '$timetable/import';
  static const settings = '/settings';
  static const feedback = '/feedback';
  static const kiteBulletin = '/kite_bulletin';
  static const yellowPages = '/yellow_pages';
  static const oaAnnouncement = '/oa_announcement';
  static const eduEmail = '/eduEmail';
  static const goodNight = '/good_night';
  static const activity = '/activity';
  static const lostFound = '/lost_found';
  static const classroomBrowser = '/classroom_browser';
  static const examArrangement = '/exam_arrangement';
  static const easterEgg = '/easter_egg';
  static const bbs = '/bbs';
  static const scanner = '/scanner';
  static const browser = '/browser';
  static const freshman = '/freshman';
  static const freshmanLogin = '$freshman/login';
  static const freshmanUpdate = '$freshman/update';
  static const freshmanAnalysis = '$freshman/analysis';
  static const freshmanFriend = '$freshman/friend';
  static const kiteBoard = '/kite_board';
  static const notFound = '/not_found';
  static const simpleHtml = '/simple_html';
}

final defaultRouteTable = StaticRouteTable(
  table: {
    RouteTable.home: (context, args) => const HomePage(),
    RouteTable.reportTemp: (context, args) => const DailyReportPage(),
    RouteTable.login: (context, args) => const LoginPage(),
    RouteTable.welcome: (context, args) => const WelcomePage(),
    RouteTable.about: (context, args) => const AboutPage(),
    RouteTable.expense: (context, args) => const ExpensePage(),
    RouteTable.connectivity: (context, args) => const ConnectivityPage(),
    RouteTable.campusCard: (context, args) => const CampusCardPage(),
    RouteTable.electricityBill: (context, args) => const ElectricityPage(),
    RouteTable.examResult: (context, args) => const ScorePage(),
    RouteTable.application: (context, args) => const OfficePage(),
    RouteTable.game: (context, args) => const GamePage(),
    RouteTable.game2048: (context, args) => Game2048Page(),
    RouteTable.gameWordle: (context, args) => const WordlePage(),
    RouteTable.gameComposeSit: (context, args) => const ComposeSitPage(),
    RouteTable.gameTetris: (context, args) => const TetrisPage(),
    RouteTable.wiki: (context, args) => WikiPage(),
    RouteTable.library: (context, args) => const LibraryPage(),
    RouteTable.libraryAppointment: (context, args) => const AppointmentPage(),
    RouteTable.market: (context, args) => const MarketPage(),
    RouteTable.timetable: (context, args) => const TimetablePage(),
    RouteTable.timetableImport: (context, args) => const TimetableImportPage(),
    RouteTable.settings: (context, args) => SettingsPage(),
    RouteTable.feedback: (context, args) => const FeedbackPage(),
    RouteTable.kiteBulletin: (context, args) => const KiteBulletinPage(),
    RouteTable.yellowPages: (context, args) => const YellowPagesPage(),
    RouteTable.oaAnnouncement: (context, args) => const BulletinPage(),
    RouteTable.eduEmail: (context, args) => const MailPage(),
    RouteTable.goodNight: (context, args) => const NightPage(),
    RouteTable.activity: (context, args) => const EventPage(),
    RouteTable.lostFound: (context, args) => const LostFoundPage(),
    RouteTable.classroomBrowser: (context, args) => const ClassroomPage(),
    RouteTable.examArrangement: (context, args) => const ExamArrangementPage(),
    RouteTable.easterEgg: (context, args) => const EggPage(),
    RouteTable.bbs: (context, args) => const BbsPage(),
    RouteTable.scanner: (context, args) => const ScannerPage(),
    RouteTable.browser: (context, args) {
      return BrowserPage(
        initialUrl: args['initialUrl'],
        fixedTitle: args['fixedTitle'],
        showSharedButton: args['showSharedButton'],
        showRefreshButton: args['showRefreshButton'],
        showLoadInBrowser: args['showLoadInBrowser'],
        userAgent: args['userAgent'],
        showLaunchButtonIfUnsupported: args['showLaunchButtonIfUnsupported'],
        showTopProgressIndicator: args['showTopProgressIndicator'],
        javascript: args['javascript'],
        javascriptUrl: args['javascriptUrl'],
      );
    },
    RouteTable.freshman: (context, args) => FreshmanPage(),
    RouteTable.freshmanAnalysis: (context, args) => const FreshmanAnalysisPage(),
    RouteTable.freshmanLogin: (context, args) => const FreshmanLoginPage(),
    RouteTable.freshmanUpdate: (context, args) => const FreshmanUpdatePage(),
    RouteTable.freshmanFriend: (context, args) => const FreshmanFriendPage(),
    RouteTable.kiteBoard: (context, args) => const BoardPage(),
    RouteTable.notFound: (context, args) => NotFoundPage(args['routeName']),
    RouteTable.simpleHtml: (context, args) {
      return SimpleHtmlPage(
        title: args['title'],
        url: args['url'],
        htmlContent: args['htmlContent'],
      );
    },
  },
  onNotFound: (context, routeName, args) => NotFoundPage(routeName),
  rootRoute: (context, table, args) {
    final routeName = AccountUtils.getUserType() != null ? RouteTable.home : RouteTable.welcome;
    return table.onGenerateRoute(routeName, args)(context);
  },
);

class DefaultRouteWithOverride implements IRouteGenerator {
  final IRouteGenerator defaultRoute;

  final Map<String, RouteOverrideItem> indexedOverrideItems;

  DefaultRouteWithOverride({
    required this.defaultRoute,
    required List<RouteOverrideItem> overrideItems,
  }) : indexedOverrideItems = {for (final e in overrideItems) e.inputRoute: e};

  @override
  bool accept(String routeName) {
    if (defaultRoute.accept(routeName)) return true;
    return indexedOverrideItems.containsKey(routeName);
  }

  @override
  WidgetBuilder onGenerateRoute(String routeName, Map<String, dynamic> arguments) {
    if (!indexedOverrideItems.containsKey(routeName)) {
      // No override
      return defaultRoute.onGenerateRoute(routeName, arguments);
    }
    // override
    final newRouteItem = indexedOverrideItems[routeName]!;
    if (defaultRoute.accept(newRouteItem.outputRoute)) {
      return defaultRoute.onGenerateRoute(newRouteItem.outputRoute, newRouteItem.args);
    }
    return (context) => NotFoundPage(newRouteItem.outputRoute);
  }
}

class RouteWithNoticeDialog implements IRouteGenerator {
  final IRouteGenerator routeGenerator;
  final Map<String, RouteNotice> routeNotice;
  final BuildContext context;

  RouteWithNoticeDialog(
    this.context, {
    required this.routeGenerator,
    this.routeNotice = const {},
  });

  @override
  bool accept(String routeName) => routeGenerator.accept(routeName);

  @override
  WidgetBuilder onGenerateRoute(String routeName, Map<String, dynamic> arguments) {
    if (routeNotice.containsKey(routeName)) {
      final notice = routeNotice[routeName]!;
      Future.delayed(Duration.zero, () async {
        final overrideDb = Kv.override;
        final confirmedRouteNotice = overrideDb.confirmedRouteNotice ?? [];
        if (confirmedRouteNotice.contains(notice.id)) return;
        final select = await showAlertDialog(
          context,
          title: notice.title,
          content: Text(notice.msg),
          actionTextList: ['我已收到'],
        );
        if (select == 0) {
          confirmedRouteNotice.add(notice.id);
          overrideDb.confirmedRouteNotice = confirmedRouteNotice;
        }
      });
    }
    return routeGenerator.onGenerateRoute(routeName, arguments);
  }
}
