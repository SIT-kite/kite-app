# 应用程序存储

小风筝的本地存储依赖 Hive 库，相关代码见 `lib/storage/`。

## Hive 的基本使用

hive 是一种 NoSQL 类型的轻量级数据库，其中的数据以 Box 的形式组织， box 在一般 SQL
数据中可与表的概念相对应，但是它在结构组织上没有表那么严格，表只能按照表定义的结构进行存储，而 box 可以容纳任意支持的数据结构。

在一个 box 中，每个数据项目都有其唯一的序号 `index`， 与键 key。使用序号与键都可以相当迅速地查找到目标结果，故项目中需要正确的应用序号与键，尽可能减少全表扫描的场景，以提高程序性能。

使用 add 去添加元素时，序号开始按照0,1,2,... 增长，此时键等于序号。

使用 put 去添加元素时，序号按照依然接着上次序号自增，但此时键就需要自定。

```dart
import 'package:hive/hive.dart';

void main() async {
  var friends = await Hive.openBox('friends');
  friends.clear();

  friends.add('Lisa');            // index 0, key 0
  friends.add('Dave');            // index 1, key 1
  friends.put(123, 'Marco');      // index 2, key 123
  friends.add('Paul');            // index 3, key 124

  print(friends.getAt(0));
  print(friends.get(0));

  print(friends.getAt(1));
  print(friends.get(1));

  print(friends.getAt(2));
  print(friends.get(123));

  print(friends.getAt(3));
  print(friends.get(124));
}
```

## 自定义数据类型支持

使用 hive_generator 包去为任何用户自定义数据类型生成相应的适配器以兼容 hive。

1. 编写一个目标实体类

2. 使用 `HiveType(typeId: xxx)` 标注实体类，xxx 代表一个唯一编号，hive 将该编号与不同数据类型进行区分，后续不应当再修改该编号，否则将出现数据错误。

3. 使用 `@HiveField` 为该实体的所有字段添加标注，注意该注解需要传入一个数值，使得 hive 对该实体的不同字段进行区分，该序号也不可修改，一般按序排列即可。

4. 添加 `part '当前文件名.g.dart';` 声明。

5. 运行 `flutter pub run build_runner build` 以生成 `TypeAdaptor` 类。

6. 注册对应的适配器。

```dart
import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 1)
class Person {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  List<Person> friends;
}

```

### ### 注意

在该项目中，所有的适配器应当在 `global/storage_pool.dart` 文件中的 `_registerAdapters` 方法中完成注册，所有的自定义类型 `typeId`
应当在 `global/hive_type_id_pool.dart` 中完成对应常量定义。

## 键值对数据

实际的键需要以一个前缀开头，后跟我们逻辑上的腱。值的类型为字符串。

| key                    | 含义       | 备注                                   |
| ---------------------- | -------- | ------------------------------------ |
| /auth/username         | 用户名 （学号） |                                      |
| /auth/password         | 密码       |                                      |
| /home/campus           | 校区       | 用于显示天气<br>1 奉贤校区<br>2 徐汇区            |
| /home/background       | 首页背景图片   |                                      |
| /home/backgroundMode   | 首页背景模式   | `weather` 表示显示天气, <br>`image` 表示显示图片 |
| /theme/color           | 主题色      |                                      |
| /library/searchHistory | 搜索记录     | 见 `SearchHistoryStorage`             |
| /network/proxy         | 代理IP地址   | 格式如 `192.168.1.1:8000`               |
| /network/useProxy      | 使用代理服务器  | bool                                 |
