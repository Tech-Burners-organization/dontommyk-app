import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/core/constant/app_color.dart';
import 'package:tommy/view/component/common_text/common_text.dart';

class CommonDropdown extends StatelessWidget {
  final List<String> items;
  final String selectedValue;
  final ValueChanged<String> onChange;
  final IconData icon;
  final GlobalKey<PopupMenuButtonState<String>>? menuKey;

  const CommonDropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChange,
    this.icon = Icons.keyboard_arrow_down,
    this.menuKey,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      key: menuKey,
      color: Colors.white,
      icon: Icon(icon, size: 24),
      onSelected: (value) {
        onChange(value);
      },
      itemBuilder: (context) => items.toSet().map((String item) {
        return PopupMenuItem<String>(
          value: item,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CommonText(
                text: item,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColor.primary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
