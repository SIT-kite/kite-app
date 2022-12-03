import 'package:flutter/material.dart';

class PlainExtendedButton extends StatelessWidget {
  final Widget label;
  final Widget? icon;
  final VoidCallback? tap;

  const PlainExtendedButton({super.key, required this.label, this.icon, this.tap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: null,
      icon: icon,
      backgroundColor: Colors.transparent,
      hoverColor: Colors.transparent,
      elevation: 0,
      highlightElevation: 0,
      label: label,
      onPressed: tap,
    );
  }
}
