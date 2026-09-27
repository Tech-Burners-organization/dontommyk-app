import 'package:flutter/material.dart';
import 'package:tommy/core/constant/app_color.dart';
import 'package:tommy/view/component/common_text/common_text.dart';

class CustomRadioButton extends StatelessWidget {
  final List<String> options;
  final String selectedValue;
  final Function(String) onChanged;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final Color borderColor;
  final double borderWidth;

  const CustomRadioButton({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.size = 24.0,
    this.activeColor = AppColor.primary,
    this.inactiveColor = const Color(0xFFFFFFFF),
    this.borderColor = const Color(0xFFC8D1E5),
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        final bool isSelected = option == selectedValue;

        return GestureDetector(
          onTap: () => onChanged(option),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  spacing: 8,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? activeColor : borderColor,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: activeColor,
                                ),
                              ),
                            )
                          : null,
                    ),
                    Expanded(
                      child: CommonText(
                        text: option,
                        fontSize: 16,
                        maxLines: 2,

                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w700,
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),
              ),
              option != options.last
                  ? Divider(color: Color(0xFFEAECF0), thickness: 1)
                  : SizedBox(),
            ],
          ),
        );
      }).toList(),
    );
  }
}
