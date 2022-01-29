import 'package:hive/hive.dart';
import 'package:kite/global/hive_type_id_pool.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypeIdPool.contactItem)
class ContactData extends HiveObject {
  ///部门
  @JsonKey()
  @HiveField(0)
  final String department;

  ///说明
  @JsonKey()
  @HiveField(1)
  final String? description;

  ///姓名
  @JsonKey()
  @HiveField(2)
  final String? name;

  ///电话
  @JsonKey()
  @HiveField(3)
  final String? phone;

  ContactData(this.department, this.description, this.name, this.phone);
  factory ContactData.fromJson(Map<String, dynamic> json) =>
      _$ContactDataFromJson(json);
}