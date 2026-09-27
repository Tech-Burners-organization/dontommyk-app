import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tommy/view/component/common_button/common_button.dart';

void main() {
  Widget buildButton(CommonButton button) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, _) => MaterialApp(
        home: Scaffold(
          body: Center(child: SizedBox(width: 320, child: button)),
        ),
      ),
    );
  }

  testWidgets('paints a supplied gradient on the button Material', (
    tester,
  ) async {
    const gradient = LinearGradient(
      colors: [Color(0xFFC77926), Color(0xFFFBE1A6)],
    );

    await tester.pumpWidget(
      buildButton(
        CommonButton(titleText: 'Continue', gradient: gradient, onTap: () {}),
      ),
    );

    final Ink ink = tester.widget(find.byType(Ink));
    final BoxDecoration decoration = ink.decoration! as BoxDecoration;
    final Material buttonMaterial = tester.widget(
      find
          .ancestor(of: find.byType(Ink), matching: find.byType(Material))
          .first,
    );

    expect(decoration.gradient, same(gradient));
    expect(buttonMaterial.color, Colors.transparent);
    expect(buttonMaterial.clipBehavior, Clip.antiAlias);
  });

  testWidgets('keeps a custom non-primary button flat and bordered', (
    tester,
  ) async {
    const buttonColor = Color(0xFF261911);
    const borderColor = Colors.white12;

    await tester.pumpWidget(
      buildButton(
        CommonButton(
          titleText: 'Previous',
          buttonColor: buttonColor,
          borderColor: borderColor,
          onTap: () {},
        ),
      ),
    );

    final Ink ink = tester.widget(find.byType(Ink));
    final BoxDecoration decoration = ink.decoration! as BoxDecoration;
    final Material buttonMaterial = tester.widget(
      find
          .ancestor(of: find.byType(Ink), matching: find.byType(Material))
          .first,
    );
    final RoundedRectangleBorder shape =
        buttonMaterial.shape! as RoundedRectangleBorder;

    expect(decoration.gradient, isNull);
    expect(decoration.color, buttonColor);
    expect(shape.side.color, borderColor);
    expect(shape.side.width, 1.w);
  });

  testWidgets('disables taps and shows progress while loading', (tester) async {
    var tapCount = 0;

    await tester.pumpWidget(
      buildButton(
        CommonButton(
          titleText: 'Continue',
          isLoading: true,
          onTap: () => tapCount++,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Continue'), findsNothing);

    await tester.tap(find.byType(InkWell));
    expect(tapCount, 0);
  });
}
