# 上应小风筝 App

这是一个由上海应用技术大学易班工作站主导开发、服务上海应用技术大学学生的应用。
我们致力于将其打造为校内最现代、最实用的 App。

_点[GitHub项目主页](https://github.com/SIT-kite/kite-app)上方 "issues" 或者直接点[这里](https://github.com/SIT-kite/kite-app/issues)反馈问题，欢迎同学们提交 bug、提出好的点子、参与开发~_

## 主要功能

- [x] 课程表
- [x] 健康上报
- [x] 消费记录
- [x] 考试查询
- [x] 成绩查询
- [ ] 给分查询
- [x] 评教
- [x] 第二课堂
- [x] 一网通办业务
- [x] 公告
- [x] 校园通知
- [x] 空教室查询
- [x] 上应 Wiki
- [x] 常用电话
- [x] 风筝时刻(风景墙)
- [ ] 二手书中介

## 更多信息

此项目源自我们的[上应小风筝][kite-microapp]小程序，由于[一些原因][migrate]，我们被迫改为 App 方式提供服务。

在本应用的开发中，我们参考了一些优秀的开源项目，例如由复旦大学学生开发的[旦夕][DanXi] App，在此表示感谢。

[kite-microapp]: https://github.com/SIT-kite/kite-microapp

[migrate]: ./WHY_DO_WE_MIGRATE.md
[DanXi]: https://github.com/DanXi-Dev/DanXi

## 开发相关

### 平台支持

Flutter 框架支持编译到多种目标平台，当前我们工作的重点为 Android 和 iOS 平台。
Web 平台存在兼容问题，如浏览器限制跨域 POST 请求、暂不支持 Webview 模块等。

### 依赖

除非遇到关键依赖库不兼容的情况，开发团队一般会使用最新版本。
当前开发版本的主要依赖库版本为：
- Flutter 3.0.5
- Dart 2.17.6

### 构建

``` shell
git clone https://github.com/SIT-kite/kite-app
cd ./kite-app

# 安装依赖
flutter pub get

# 生成 json 序列化与反序列化代码和 splash screen
flutter pub run build_runner build
flutter pub run flutter_native_splash:create

# 打包生成 apk
flutter build apk

# 运行 Flutter Web 版本
flutter run
```

也可以运行build_script.sh脚本，其中包含了各种常用脚本

还可以运行Makefile，也包含了各种常用命令

## 联系我们

- 在本项目中提交 issue；
- 在 QQ 群中联系管理员反馈：
  - 小程序反馈群：`943110696`
  - 2021级易班新生群：`147239936`（限本校学生加入）
- 地址：上海应用技术大学 奉贤校区 大学生活动中心 309室

## 参与贡献

在每年招新期间，你可以关注一下“上海应用技术大学易班”公众号，
或通过有关QQ群，了解招新信息，加入校易班工作站（欢迎来技术部！）。

你也可以直接联系我们，联系方式见上“联系我们”，或对有关项目提交 issue、pull request，留下你的痕迹。

## 有关项目

| 项目                       | 说明 |
| -------------------------- | ---- |
| [kite-server][kite-server] | 后端 API 服务 |
| [kite-agent][kite-agent]   | 后端数据获取工具（在 App 场景下被废弃） |
| [kite-string][kite-string] | 校园网网络工具 |

部分项目已在 Gitee 上设立镜像，访问速度会快一些。

[kite-server]: https://github.com/SIT-kite/kite-server
[kite-agent]:  https://github.com/SIT-kite/kite-agent
[kite-string]: https://github.com/SIT-kite/kite-string

## 开源协议

项目中的代码（程序源代码、配置文件等）采用 [GPL v3](LICENSE) 协议发布。

注意，如果您修改并分发本项目，您应当同意，软件的“分发”或“发布”包括“为用户提供服务”。 您修改并分发项目后，应当对用户和我们（即，上海应用技术大学校易班工作站）公开全部源代码。

除此之外，您（非贡献者）也不能将本项目用于比赛、论文等活动。

### 标志版权

本项目的名称、标语、标志性图片等素材，仅限上海应用技术大学校易班工作站及原作者使用，或经其书面同意后使用，不对外授权。

## 致谢

本项目中使用的其他开源项目：

- [Game2048](https://github.com/linuxsong/game2048)
- [Wordle](https://github.com/nimone/wordle)
- [DanXi][DanXi]
- [flutter-tetrix](https://github.com/boyan01/flutter-tetris)

这些项目的开源协议详见其各自的 LICENSE, 版权归原作者所有.

在此表示感谢！
