# 应用程序存储

小风筝的本地存储有两部分组成，分别是 kv 存储和关系型数据存储，相关代码见 `lib/storage/`。 程序中的 kv 存储依赖 shared_preferences 库，关系型数据存储依赖
sqflite 库。

## 键值对数据

实际的键需要以一个前缀开头，后跟我们逻辑上的腱。值的类型为字符串。

| key | 含义 | 备注 |
| ----- | ------ | --------|
| /auth/username | 用户名 （学号） | |
| /auth/password | 密码 | |
| /home/campus | 校区 | 用于显示天气<br>1 奉贤校区<br>2 徐汇区 |
| /home/background | 首页背景图片 | |
| /home/backgroundMode | 首页背景模式 | `weather` 表示显示天气, <br>`image` 表示显示图片 |
| /theme/color | 主题色 | |
| /library/searchHistory | 搜索记录 | 见 `SearchHistoryStorage` |

## 关系型数据

TODO.
