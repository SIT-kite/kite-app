import 'package:kite/entity/contact.dart';

///远程的常用电话数据访问层的接口
abstract class ConstantRemoteDao {}

///本地的常用电话数据访问接口
abstract class ContactDataStorageDao {
  ///添加常用电话记录
  void add(ContactData data);

  ///获取所有常用电话记录
  List<ContactData> getAllBydepartmentDesc();
}
