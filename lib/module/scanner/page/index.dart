/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kite/module/game/using.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../using.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with SingleTickerProviderStateMixin {
  String? barcode;

  MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode],
    facing: CameraFacing.back,
  );

  bool isStarted = true;

  Widget buildImagePicker() {
    return IconButton(
      color: Colors.white,
      icon: const Icon(Icons.image),
      iconSize: 32.0,
      onPressed: () async {
        final ImagePicker picker = ImagePicker();
        // Pick an image
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          if (await controller.analyzeImage(image.path)) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: i18n.scannerBarcodeRecognized.txt,
              backgroundColor: Colors.green,
            ));
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: i18n.scannerBarcodeNotRecognized.txt,
              backgroundColor: Colors.redAccent,
            ));
          }
        }
      },
    );
  }

  Widget buildSwitchButton() {
    return IconButton(
      color: Colors.white,
      icon: ValueListenableBuilder(
        valueListenable: controller.cameraFacingState,
        builder: (context, state, child) {
          switch (state) {
            case CameraFacing.front:
              return const Icon(Icons.camera_front);
            case CameraFacing.back:
              return const Icon(Icons.camera_rear);
          }
        },
      ),
      iconSize: 32.0,
      onPressed: () => controller.switchCamera(),
    );
  }

  Widget buildTorchButton() {
    return IconButton(
      color: Colors.white,
      icon: ValueListenableBuilder(
        valueListenable: controller.torchState,
        builder: (context, state, child) {
          switch (state) {
            case TorchState.off:
              return const Icon(Icons.flash_off, color: Colors.grey);
            case TorchState.on:
              return const Icon(Icons.flash_on, color: Colors.yellow);
          }
        },
      ),
      iconSize: 32.0,
      onPressed: () => controller.toggleTorch(),
    );
  }

  Widget buildStopButton() {
    return IconButton(
      color: Colors.white,
      icon: isStarted ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
      iconSize: 32.0,
      onPressed: () => setState(() {
        isStarted ? controller.stop() : controller.start();
        isStarted = !isStarted;
      }),
    );
  }

  Widget buildScanner() {
    return MobileScanner(
      controller: controller,
      fit: BoxFit.contain,
      onDetect: (barcode, args) {
        controller.dispose();

        Future.delayed(Duration.zero, () async {
          await const Vibration(milliseconds: 100).emit();
        });

        Navigator.pop(context, barcode.rawValue);
      },
    );
  }

  Widget buildControllerView() {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 100,
      color: Colors.black.withOpacity(0.4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTorchButton(),
          // buildStopButton(),
          buildSwitchButton(),
          buildImagePicker(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(builder: (context) {
        return Stack(
          children: [
            buildScanner(),
            Align(
              alignment: Alignment.bottomCenter,
              child: buildControllerView(),
            ),
          ],
        );
      }),
    );
  }
}
