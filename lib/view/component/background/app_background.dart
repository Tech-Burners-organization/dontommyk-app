import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2C1E11), // Dark gold/brown at top
            Color(0xFF000000), // Black at bottom
          ],
          stops: [0.0, 0.6],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
