import 'package:hive/hive.dart';
import 'package:kite/dao/contact.dart';
import 'package:kite/entity/contact.dart';

class ContactDataStorage implements ContactDataStorageDao {
  final Box<ContactData> box;

  const ContactDataStorage(this.box);

  @override
  void add(ContactData data) {
    box.put(data.description.hashCode, data);
  }

  @override
  List<ContactData> getAllBydepartmentDesc() {
    var result = box.values.toList();
    result.sort((a, b) => a.department.compareTo(b.department));
    return result;
  }
}
