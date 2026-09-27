import 'package:flutter/material.dart';
import 'package:tommy/core/constant/app_color.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({this.size = 28, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: size,
        child: const CircularProgressIndicator(
          color: AppColor.primary,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
