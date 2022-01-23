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
    _buildingController.text = StoragePool.electricity.lastBuilding ?? '楼号';
    _roomController.text = StoragePool.electricity.lastRoom ?? '寝室号';
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
    Widget _buildInputBox(controller, String? Function(String?)? validator) {
      return TextFormField(
        controller: controller,
        validator: validator,
        maxLines: 1,
        textAlignVertical: const TextAlignVertical(y: 1),
        keyboardType: const TextInputType.numberWithOptions(),
        decoration: const InputDecoration(
          alignLabelWithHint: true,
          border: OutlineInputBorder(),
          hintStyle: TextStyle(color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      width: 300,
      height: 60,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Row(children: [
          _buildInputBox(_buildingController, _buildingValidation),
          _buildInputBox(_roomController, _roomValidation),
        ]),
      ),
    );
  }

  void _onQueryBalance() {
    StoragePool.electricity.lastBuilding = _buildingController.text;
    StoragePool.electricity.lastRoom = _roomController.text;
    setState(() {
      showType = 1;
    });
  }

  void _onQueryStatistics() {
    StoragePool.electricity.lastBuilding = _buildingController.text;
    StoragePool.electricity.lastRoom = _roomController.text;
    setState(() {
      showType = 1;
    });
  }

  Widget _buildButtonRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      ElevatedButton(
        child: const Text('查余额'),
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xFF2e62cd))),
        onPressed: _onQueryBalance,
      ),
      ElevatedButton(
        child: const Text('使用情况'),
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xFF2e62cd))),
        onPressed: _onQueryStatistics,
      )
    ]);
  }

  Widget _buildBalanceResult() {
    String building = _buildingController.text;
    String room = _roomController.text;

    return BalanceSection('$building$room');
  }

  Widget _buildStatisticsResult() {
    String building = _buildingController.text;
    String room = _roomController.text;

    return ChartSection('$building$room');
  }

  Widget _buildResult() {
    if (showType == 1) {
      return _buildBalanceResult();
    } else if (showType == 2) {
      return _buildStatisticsResult();
    }
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('电费余额查询'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(child: _buildInputRow()),
            Container(child: _buildButtonRow()),
            _buildResult(),
          ],
        ),
      ),
    );
  }
}
