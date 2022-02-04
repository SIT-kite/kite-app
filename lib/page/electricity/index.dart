import 'package:flutter/material.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/electricity/balance.dart';
import 'package:kite/page/electricity/chart.dart';

class ElectricityPage extends StatefulWidget {
  const ElectricityPage({Key? key}) : super(key: key);

  @override
  _ElectricityPageState createState() => _ElectricityPageState();
}

class _ElectricityPageState extends State<ElectricityPage> {
  int showType = 0; // 0: 不显示查询结果; 1: 查余额; 2: 查统计

  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();

  @override
  void initState() {
    _buildingController.text = StoragePool.electricity.lastBuilding ?? '';
    _roomController.text = StoragePool.electricity.lastRoom ?? '';
    super.initState();
  }

  String? _roomValidation(String? room) {
    int roomId = int.tryParse(room ?? '0') ?? 0;

    if (!((roomId / 100 > 0 && roomId / 100 < 17) && (roomId % 100 > 0 && roomId % 100 < 31))) {
      return '房间号格式有误';
    }
  }

  String? _buildingValidation(String? building) {
    int buildingId = int.tryParse(building ?? '0') ?? 0;

    if (!(buildingId > 0 && buildingId < 27)) {
      return '楼号格式有误';
    }
  }

  Widget _buildInputRow() {
    Widget _buildInputBox(String label, TextEditingController controller, String? Function(String?)? validator) {
      return ConstrainedBox(
        constraints: const BoxConstraints(
            // maxHeight: 60,
            ),
        child: TextFormField(
          controller: controller,
          validator: validator,
          maxLines: 1,
          keyboardType: const TextInputType.numberWithOptions(),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(),
            hintStyle: const TextStyle(color: Colors.grey),
            hintText: label,
          ),
        ),
      );
    }

    return SizedBox(
      width: 300,
      height: 80,
      child: Form(
        key: _formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildInputBox('楼号', _buildingController, _buildingValidation)),
            Expanded(child: _buildInputBox('房间号', _roomController, _roomValidation)),
          ],
        ),
      ),
    );
  }

  void _onQueryBalance() {
    if (!(_formKey.currentState as FormState).validate()) {
      return;
    }
    StoragePool.electricity.lastBuilding = _buildingController.text;
    StoragePool.electricity.lastRoom = _roomController.text;
    setState(() => showType = 1);
  }

  void _onQueryStatistics() {
    if (!(_formKey.currentState as FormState).validate()) {
      return;
    }
    StoragePool.electricity.lastBuilding = _buildingController.text;
    StoragePool.electricity.lastRoom = _roomController.text;
    setState(() => showType = 1);
  }

  Widget _buildButtonRow() {
    return SizedBox(
      width: 300,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        ElevatedButton(
          child: const Text('查余额'),
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.amber)),
          onPressed: _onQueryBalance,
        ),
        ElevatedButton(
          child: const Text('使用情况'),
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.amber)),
          onPressed: _onQueryStatistics,
        )
      ]),
    );
  }

  Widget _buildBalanceResult() {
    String building = _buildingController.text;
    String room = _roomController.text;

    return BalanceSection('10$building$room');
  }

  Widget _buildStatisticsResult() {
    String building = _buildingController.text;
    String room = _roomController.text;

    return ChartSection('10$building$room');
  }

  Widget _buildResult() {
    if (showType == 1) {
      return _buildBalanceResult();
    } else if (showType == 2) {
      return _buildStatisticsResult();
    }
    return const Center();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('查电费'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildInputRow(),
            _buildButtonRow(),
            _buildResult(),
          ],
        ),
      ),
    );
  }
}
