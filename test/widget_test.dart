import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tommy/app/app.dart';
import 'package:tommy/core/di/app_dependencies.dart';
import 'package:tommy/core/utils/prefs_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await PrefsHelper.init();
  });

  testWidgets('shows the Dio and BLoC starter page', (tester) async {
    await tester.pumpWidget(TommyApp(dependencies: AppDependencies.create()));
    await tester.pumpAndSettle();

    expect(find.text('Dio + BLoC foundation is ready'), findsOneWidget);
    expect(find.text('API base URL'), findsOneWidget);
  });
}
