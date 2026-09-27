import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonText extends StatelessWidget {
  const CommonText({
    super.key,
    this.lineHeight = 1.2,
    this.maxLines = 1,
    this.textAlign = TextAlign.center,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w500,
    this.color = const Color(0xFF0A1A2F),
    required this.text,
    this.style = true,
    this.overflow = TextOverflow.ellipsis,
    this.textDecoration = TextDecoration.none,
    this.softWrap = false,
    this.fontFamily = 'Figtree',
  });

  final double left;
  final double lineHeight;
  final double right;
  final double top;
  final double bottom;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final TextAlign textAlign;
  final int maxLines;
  final TextOverflow overflow;
  final bool style;
  final bool softWrap;
  final TextDecoration textDecoration;
  final String fontFamily;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: left.w,
        right: right.w,
        top: top.h,
        bottom: bottom.h,
      ),
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        style: GoogleFonts.cormorantGaramond(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          decoration: textDecoration,
          decorationColor: color,
          height: lineHeight,
        ),
      ),
    );
  }
}
