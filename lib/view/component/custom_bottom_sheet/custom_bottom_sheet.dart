import 'package:flutter/material.dart';
import 'package:tommy/view/component/custom_bottom_sheet/expandable_bottom_sheet.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({required this.child, super.key});

  final Widget child;

  static Future<T?> show<T>(BuildContext context, {required Widget child}) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomBottomSheet(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableBottomSheet(
      onClose: () => Navigator.of(context).maybePop(),
      child: child,
    );
  }
}
