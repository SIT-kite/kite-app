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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kite/credential/symbol.dart';
import 'package:kite/design/user_widgets/dialog.dart';
import 'package:kite/home/page/index.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/module/pure_function/launch_in_browser.dart';
import 'package:kite/navigation/static_route.dart';
import 'package:kite/override/entity.dart';
import 'package:kite/settings/page/index.dart';
import 'package:kite/storage/init.dart';

import 'module/pure_function/launcher.dart';
import 'module/simple_page/page/browser.dart';
import 'module/symbol.dart';
import 'navigation/route.dart';

class RouteTable {
  RouteTable._();

  static const root = '/';
  static const home = '/home';
  static const about = '/about';
  static const activity = '/activity';
  static const application = '/application';
  static const campusCard = '/campus_card';
  static const classroomBrowser = '/classroom_browser';
  static const networkTool = '/network_tool';
  static const easterEgg = '/easter_egg';
  static const eduEmail = '/edu_email';
  static const electricityBill = '/electricity_bill';
  static const reportTemp = '/report_temp';
  static const login = '/login';
  static const welcome = '/welcome';
  static const expense = '/expense';
  static const examResult = '/exam_result';
  static const game = '/game';
  static const game2048 = '$game/2048';
  static const gameWordle = '$game/wordle';
  static const gameComposeSit = '$game/composeSit';
  static const gameTetris = '$game/tetris';
  static const wiki = '/wiki';
  static const library = '/library';
  static const market = '/market';
  static const timetable = '/timetable';
  static const timetableImport = '$timetable/import';
  static const timetableMine = '$timetable/mine';
  static const settings = '/settings';
  static const feedback = '/feedback';
  static const kiteBulletin = '/kite_bulletin';
  static const yellowPages = '/yellow_pages';
  static const oaAnnouncement = '/oa_announcement';
  static const goodNight = '/good_night';
  static const lostFound = '/lost_found';
  static const examArrangement = '/exam_arrangement';
  static const bbs = '/bbs';
  static const scanner = '/scanner';
  static const browser = '/browser';
  static const freshman = '/freshman';
  static const freshmanLogin = '$freshman/login';
  static const freshmanUpdate = '$freshman/update';
  static const freshmanStatistics = '$freshman/statistics';
  static const freshmanFriend = '$freshman/friend';
  static const kiteBoard = '/kite_board';
  static const notFound = '/not_found';
  static const simpleHtml = '/simple_html';
  static const serviceStatus = '/service_status';
  static const pureFunctionLauncher = '/pure_function/launch';
  static const pureFunctionLaunchInBrowser = '/pure_function/launchInBrowser';
  static const relogin = '/relogin';
}

final defaultRouteTable = StaticRouteTable(
  table: {
    RouteTable.home: (context, args) => const HomePage(),
    RouteTable.reportTemp: (context, args) => const DailyReportIndexPage(),
    RouteTable.login: (context, args) => args["disableOffline"] == true
        ? const LoginPage(
            disableOffline: true,
          )
        : const LoginPage(
            disableOffline: false,
          ),
    RouteTable.welcome: (context, args) => const WelcomePage(),
    RouteTable.about: (context, args) => const AboutPage(),
    RouteTable.expense: (context, args) => const ExpenseTrackerPage(),
    RouteTable.networkTool: (context, args) => const NetworkToolPage(),
    RouteTable.campusCard: (context, args) => const CampusCardPage(),
    RouteTable.electricityBill: (context, args) => const ElectricityBillPage(),
    RouteTable.examResult: (context, args) => const ScorePage(),
    RouteTable.application: (context, args) => const ApplicationPage(),
    RouteTable.game: (context, args) => const GamePage(),
    RouteTable.game2048: (context, args) => const Game2048Page(),
    RouteTable.gameWordle: (context, args) => const GameWordlePage(),
    RouteTable.gameComposeSit: (context, args) => const GameComposeSitPage(),
    RouteTable.gameTetris: (context, args) => const GameTetrisPage(),
    RouteTable.wiki: (context, args) => WikiPage(),
    RouteTable.library: (context, args) => const LibraryPage(),
    RouteTable.market: (context, args) => const MarketPage(),
    RouteTable.timetable: (context, args) => const TimetableIndexPage(),
    RouteTable.timetableImport: (context, args) => const ImportTimetableIndexPage(),
    RouteTable.timetableMine: (context, args) => const MyTimetablePage(),
    RouteTable.settings: (context, args) => const SettingsPage(),
    RouteTable.feedback: (context, args) => const FeedbackPage(),
    RouteTable.kiteBulletin: (context, args) => const KiteBulletinPage(),
    RouteTable.yellowPages: (context, args) => const YellowPagesPage(),
    RouteTable.oaAnnouncement: (context, args) => const OaAnnouncePage(),
    RouteTable.eduEmail: (context, args) => const MailPage(),
    RouteTable.goodNight: (context, args) => const NightPage(),
    RouteTable.activity: (context, args) => const ActivityPage(),
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
    RouteTable.freshman: (context, args) => const FreshmanPage(),
    RouteTable.freshmanStatistics: (context, args) => const FreshmanStatisticsPage(),
    RouteTable.freshmanLogin: (context, args) => const FreshmanLoginPage(),
    RouteTable.freshmanUpdate: (context, args) => const PersonalInfoPage(),
    RouteTable.freshmanFriend: (context, args) => const FreshmanRelationshipPage(),
    RouteTable.kiteBoard: (context, args) => const BoardPage(),
    RouteTable.notFound: (context, args) => NotFoundPage(args['routeName']),
    RouteTable.simpleHtml: (context, args) {
      return SimpleHtmlPage(
        title: args['title'],
        url: args['url'],
        htmlContent: args['htmlContent'],
      );
    },
    RouteTable.serviceStatus: (context, args) => const ServiceStatusPage(),
    RouteTable.pureFunctionLauncher: (context, args) => LauncherFunction(args['schemeText']),
    RouteTable.pureFunctionLaunchInBrowser: (context, args) => LaunchInBrowserFunction(args['url']),
    RouteTable.relogin: (context, args) => const UnauthorizedTipPage(),
  },
  onNotFound: (context, routeName, args) => NotFoundPage(routeName),
  rootRoute: (context, table, args) {
    // The freshmen and OA users who ever logged in can directly land on the homepage.
    // While, the offline users have to click the `Offline Mode` button every time.
    final routeName =
        Auth.lastOaAuthTime != null || Auth.lastFreshmanAuthTime != null ? RouteTable.home : RouteTable.welcome;
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
        final confirm = await context.showTip(title: notice.title, desc: notice.msg, ok: i18n.iSee);
        if (confirm) {
          confirmedRouteNotice.add(notice.id);
          overrideDb.confirmedRouteNotice = confirmedRouteNotice;
        }
      });
    }
    return routeGenerator.onGenerateRoute(routeName, arguments);
  }
}
