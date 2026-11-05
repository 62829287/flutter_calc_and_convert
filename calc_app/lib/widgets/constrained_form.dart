import 'package:flutter/material.dart';

class ConstrainedForm extends StatelessWidget {
  final Widget child;
  const ConstrainedForm({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: child,
        ),
      ),
    );
  }
}