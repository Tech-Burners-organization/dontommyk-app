import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/core/constant/app_color.dart';
import 'package:tommy/core/constant/extentions.dart';
import '../common_text/common_text.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String titleText;
  final Color titleColor;
  final Color buttonColor;
  final Color? borderColor;
  final double borderWidth;
  final double titleSize;
  final FontWeight titleWeight;
  final double buttonRadius;
  final double buttonHeight;
  final double buttonWidth;
  final Widget? icon;
  final Widget? trailingIcon;
  final double strokeWidth;
  final Gradient? gradient;

  final bool isLoading;

  const CommonButton({
    this.onTap,
    required this.titleText,
    this.titleColor = Colors.white,
    this.buttonColor = AppColor.primary,
    this.titleSize = 18,
    this.buttonRadius = 14,
    this.titleWeight = FontWeight.w700,
    this.buttonHeight = 56,
    this.borderWidth = 1,
    this.isLoading = false,
    this.buttonWidth = double.infinity,
    this.borderColor = AppColor.primary,
    this.strokeWidth = 4,
    this.icon,
    this.trailingIcon,
    this.gradient,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDefaultColor = buttonColor == AppColor.primary;
    final Gradient? effectiveGradient =
        gradient ??
        (isDefaultColor
            ? const LinearGradient(
                colors: [Color(0xFFC26614), Color(0xFFEEE9A6)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null);
    final BorderRadius borderRadius = BorderRadius.circular(buttonRadius.r);
    final BorderSide borderSide = effectiveGradient == null
        ? BorderSide(
            color: borderColor ?? Colors.transparent,
            width: borderWidth.w,
          )
        : BorderSide.none;

    return SizedBox(
      height: buttonHeight.h,
      width: buttonWidth.w,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.12),
              offset: const Offset(0, 3),
              blurRadius: 3,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, 1),
              blurRadius: 1,
              spreadRadius: -0.5,
            ),
          ],
        ),
        child: Semantics(
          button: true,
          enabled: !isLoading && onTap != null,
          child: Material(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
              side: borderSide,
            ),
            clipBehavior: Clip.antiAlias,
            child: Ink(
              decoration: BoxDecoration(
                color: effectiveGradient == null ? buttonColor : null,
                gradient: effectiveGradient,
                borderRadius: borderRadius,
              ),
              child: InkWell(
                onTap: isLoading ? null : onTap,
                customBorder: RoundedRectangleBorder(
                  borderRadius: borderRadius,
                ),
                child: Center(
                  child: isLoading
                      ? SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator(
                            color: titleColor,
                            strokeWidth: strokeWidth,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (icon case final leading?) ...[leading, 8.width],
                            CommonText(
                              text: titleText,
                              fontSize: titleSize,
                              fontWeight: titleWeight,
                              textAlign: TextAlign.center,
                              color: titleColor,
                            ),
                            if (trailingIcon case final trailing?) ...[
                              8.width,
                              trailing,
                            ],
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
