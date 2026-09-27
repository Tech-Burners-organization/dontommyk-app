import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/core/constant/app_color.dart';
import 'package:tommy/core/constant/extentions.dart';
import '../common_text/common_text.dart';

SizedBox customIconButton({
  VoidCallback? onTap,
  required String titleText,

  Color titleColor = Colors.white,
  Color buttonColor = AppColor.primary,
  Color? borderColor = AppColor.primary,

  double borderWidth = 1,
  double titleSize = 18,
  FontWeight titleWeight = FontWeight.w700,

  double buttonRadius = 14,
  double buttonHeight = 56,
  double buttonWidth = double.infinity,

  Widget? prefixIcon,
  Widget? suffixIcon,

  bool isLoading = false,
  double strokeWidth = 4,
}) {
  return SizedBox(
    height: buttonHeight.h,
    width: buttonWidth.w,
    child: Ink(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.white.withOpacity(0.12),
            offset: const Offset(0, 3),
            blurRadius: 3,
          ),
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 1),
            blurRadius: 1,
            spreadRadius: -0.5,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(buttonRadius.r),
            border: Border.all(
              color: borderColor ?? AppColor.primary,
              width: borderWidth.w,
            ),
          ),
          child: isLoading
              ? Center(
                  child: SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(
                      color: titleColor,
                      strokeWidth: strokeWidth,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefixIcon != null) ...[prefixIcon, 8.width],
                    CommonText(
                      text: titleText,
                      fontSize: titleSize,
                      fontWeight: titleWeight,
                      color: titleColor,
                    ),
                    if (suffixIcon != null) ...[8.width, suffixIcon],
                  ],
                ),
        ),
      ),
    ),
  );
}
