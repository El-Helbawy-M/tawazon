import 'package:flutter/material.dart';

class CancelKeyboardGesture extends StatelessWidget {
  const CancelKeyboardGesture({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        top: false,
        child: child,
      ),
    );
  }
}
