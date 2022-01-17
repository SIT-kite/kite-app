import 'package:dio/dio.dart';
import 'package:kite/entity/office.dart';

import 'office_session.dart';

const String serviceFunctionList = 'https://xgfy.sit.edu.cn/app/public/queryAppManageJson';
const String serviceFunctionDetail = 'https://xgfy.sit.edu.cn/app/public/queryAppFormJson';

Future<List<SimpleFunction>> selectFunctions(OfficeSession session) async {
  String payload = '{"appObject":"student","appName":null}';

  final Response response = await session.post(serviceFunctionList, data: payload, responseType: ResponseType.json);

  final Map<String, dynamic> data = response.data;
  final List<SimpleFunction> functionList = (data['value'] as List<dynamic>)
      .map((e) => SimpleFunction.fromJson(e))
      .where((element) => element.status == 1) // Filter functions unavailable.
      .toList();

  return functionList;
}

Future<List<SimpleFunction>> selectFunctionsByCountDesc(OfficeSession session) async {
  final functions = await selectFunctions(session);
  functions.sort((a, b) => b.count.compareTo(a.count));
  return functions;
}

class FunctionDetail {
  final String id;
  final List<FunctionDetailSection> sections;

  const FunctionDetail(this.id, this.sections);
}

Future<FunctionDetail> getFunctionDetail(OfficeSession session, String functionId) async {
  final String payload = '{"appID":"$functionId"}';

  final response = await session.post(serviceFunctionDetail, data: payload, responseType: ResponseType.json);
  final Map<String, dynamic> data = response.data;
  final List<FunctionDetailSection> sections =
      (data['value'] as List<dynamic>).map((e) => FunctionDetailSection.fromJson(e)).toList();

  return FunctionDetail(functionId, sections);
}
