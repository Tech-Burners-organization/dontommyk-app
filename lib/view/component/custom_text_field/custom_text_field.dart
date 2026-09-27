import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tommy/core/constant/app_color.dart';
import 'package:tommy/core/constant/extentions.dart';
import '../common_text/common_text.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    this.title,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.cursorColor = Colors.black,
    this.textAlignVertical = TextAlignVertical.center,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.maxLines = 1,
    this.validator,
    this.labelText,
    this.hintText,
    this.titleText = "",
    this.optionalText = "",
    this.textStyle,
    this.hintStyle,
    this.fillColor = const Color(0xFFF5F5F5),
    this.suffixIcon,
    this.suffixIconColor,
    this.fieldBorderRadius,
    this.fieldBorderColor = const Color(0xFFE5E5E5),
    this.isPassword = false,
    this.isPrefixIcon = true,
    this.readOnly = false,
    this.maxLength,
    super.key,
    this.prefixIcon,
    this.storyWordCount = "",
    this.onTap,
    this.errorMaxLines,
  });

  final String? title;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final bool autocorrect;
  final bool enableSuggestions;
  final Color cursorColor;
  final TextAlignVertical? textAlignVertical;
  final TextAlign textAlign;
  final int? maxLines;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final String? labelText;
  final String? hintText;
  final String titleText;
  final String optionalText;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final Color? suffixIconColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double? fieldBorderRadius;
  final VoidCallback? onTap;

  final Color fieldBorderColor;
  final bool isPassword;
  final bool isPrefixIcon;
  final bool readOnly;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String storyWordCount;
  final int? errorMaxLines;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;
  bool _touched = false;
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _touched = true;
    } else if (_touched) {
      _fieldKey.currentState?.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.titleText.isNotEmpty)
          CommonText(
            text: widget.titleText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColor.primary,
          ),
        if (widget.titleText.isNotEmpty) 10.height,
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: TextFormField(
            key: _fieldKey,
            onTap: widget.onTap,
            inputFormatters: widget.inputFormatters,
            onFieldSubmitted: widget.onFieldSubmitted,
            readOnly: widget.readOnly,
            enableInteractiveSelection: true,
            controller: widget.controller,
            focusNode: _focusNode,
            maxLength: widget.maxLength,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            textAlign: widget.textAlign,
            textAlignVertical: widget.textAlignVertical,
            textCapitalization: widget.textCapitalization,
            autofillHints: widget.autofillHints,
            autocorrect: widget.autocorrect,
            enableSuggestions: widget.enableSuggestions,
            cursorColor: widget.cursorColor,
            style:
                widget.textStyle ??
                GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColor.primary,
                ),
            onChanged: (value) {
              if (_touched) {
                _fieldKey.currentState?.validate();
              }
              widget.onChanged?.call(value);
            },
            maxLines: widget.maxLines,
            obscureText: widget.isPassword ? obscureText : false,
            validator: widget.validator,
            showCursor: widget.keyboardType == TextInputType.none
                ? false
                : true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 14.w,
              ),
              labelText: widget.labelText,
              hint: widget.hintText != null
                  ? Text(
                      widget.hintText!,
                      style:
                          widget.hintStyle ??
                          GoogleFonts.figtree(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF505050),
                          ),
                    )
                  : null,
              labelStyle: widget.textStyle,
              errorMaxLines: widget.errorMaxLines,
              fillColor: widget.fillColor,
              filled: true,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: toggle,
                      tooltip: obscureText ? 'Show password' : 'Hide password',
                      icon: Icon(
                        obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    )
                  : widget.suffixIcon,
              suffixIconColor: widget.suffixIconColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.fieldBorderRadius ?? 16.r,
                ),
                borderSide: BorderSide(
                  color: widget.fieldBorderColor,
                  width: 1.5,
                ),
                gapPadding: 0,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.fieldBorderRadius ?? 16.r,
                ),
                borderSide: BorderSide(
                  color: widget.fieldBorderColor,
                  width: 1.5,
                ),
                gapPadding: 0,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.fieldBorderRadius ?? 16.r,
                ),
                borderSide: BorderSide(
                  color: widget.fieldBorderColor,
                  width: 1.5,
                ),
                gapPadding: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
