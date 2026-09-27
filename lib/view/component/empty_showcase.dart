import 'package:flutter/material.dart';
import 'package:tommy/core/constant/app_color.dart';
import 'package:tommy/view/component/common_text/common_text.dart';

class EmptyShowcase extends StatelessWidget {
  const EmptyShowcase({
    this.message = 'No data found',
    this.icon = Icons.inbox_outlined,
    super.key,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColor.textSecondary),
            const SizedBox(height: 12),
            CommonText(
              text: message,
              fontSize: 18,
              maxLines: 3,
              softWrap: true,
              fontWeight: FontWeight.w600,
              color: AppColor.primary,
            ),
          ],
        ),
      ),
    );
  }
}
