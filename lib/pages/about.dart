import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

const String markdownContent = """
# 关于我们

这是一个由上海应用技术大学易班工作站主导开发、服务上海应用技术大学学生的应用。
我们致力于将其打造为校内最现代、最实用的 App。欢迎同学们提出好的点子、参与开发。

## 联系我们

- 在本项目中提交 issue
- 在 QQ 群中联系管理员反馈。 小程序反馈群 943110696, 2021级易班新生群 147239936（限本校学生加入）
- 地址: 奉贤校区大学生活动中心309室

## 参与贡献

在每年招新期间，你可以关注一下“上海应用技术大学易班”公众号，或有关QQ群了解招新信息加入校易班工作站（欢迎来技术部！）。

你也可以直接联系我们，联系方式见 “上方” 或对有关项目提交 issue、 pull request，留下你的痕迹。

""";

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Markdown(selectable: true, data: markdownContent),
    );
  }
}
