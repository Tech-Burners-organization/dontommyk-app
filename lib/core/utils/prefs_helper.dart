import 'package:shared_preferences/shared_preferences.dart';

abstract final class PrefsHelper {
  static late SharedPreferences _preferences;
  static bool _initialized = false;

  static String _token = '';
  static String get token {
    if (_token.isNotEmpty) return _token;
    if (_initialized) {
      return _preferences.getString('token') ?? '';
    }
    return '';
  }
  static set token(String value) => _token = value;

  static String _resetToken = '';
  static String get resetToken {
    if (_resetToken.isNotEmpty) return _resetToken;
    if (_token.isNotEmpty) return _token;
    if (_initialized) {
      final saved = _preferences.getString('resetToken') ?? '';
      if (saved.isNotEmpty) return saved;
      return _preferences.getString('token') ?? '';
    }
    return '';
  }
  static set resetToken(String value) => _resetToken = value;

  static String role = '';
  static String phone = '';
  static String name = '';
  static String firstName = '';
  static String lastName = '';
  static String email = '';
  static String gender = '';
  static String dateBirth = '';
  static String profileImage = '';
  static bool isRemember = false;
  static String rating = '';
  static String countryCode = '';
  static bool isOnline = false;
  static bool isProfileCompleted = false;
  static bool isInitialAssessmentCompleted = false;

  static Future<void> init() async {
    if (!_initialized) {
      _preferences = await SharedPreferences.getInstance();
      _initialized = true;
    }
    _loadCachedValues();
  }

  static void _loadCachedValues() {
    role = _preferences.getString('role') ?? '';
    _token = _preferences.getString('token') ?? '';
    _resetToken = _preferences.getString('resetToken') ?? '';
    phone = _preferences.getString('phoneNumber') ?? '';
    name = _preferences.getString('name') ?? '';
    firstName = _preferences.getString('firstName') ?? '';
    lastName = _preferences.getString('lastName') ?? '';
    profileImage = _preferences.getString('profileImage') ?? '';
    email = _preferences.getString('email') ?? '';
    dateBirth = _preferences.getString('dateBirth') ?? '';
    gender = _preferences.getString('gender') ?? '';
    rating = _preferences.getString('rating') ?? '';
    countryCode = _preferences.getString('countryCode') ?? '';
    isOnline = _preferences.getBool('isOnline') ?? false;
    isRemember = _preferences.getBool('isRemember') ?? false;
    isProfileCompleted = _preferences.getBool('isProfileCompleted') ?? false;
    isInitialAssessmentCompleted =
        _preferences.getBool('isInitialAssessmentCompleted') ?? false;
  }

  static Future<void> getAllData() => init();

  static Future<void> clearAllData() async {
    await _ensureInitialized();
    await _preferences.clear();
    _loadCachedValues();
  }

  static Future<String> getString(String key) async {
    await _ensureInitialized();
    return _preferences.getString(key) ?? '';
  }

  static Future<bool> getBool(String key) async {
    await _ensureInitialized();
    return _preferences.getBool(key) ?? false;
  }

  static Future<int> getInt(String key) async {
    await _ensureInitialized();
    return _preferences.getInt(key) ?? -1;
  }

  static Future<void> setString(String key, String? value) async {
    if (key == 'token') {
      token = value ?? '';
    } else if (key == 'resetToken') {
      resetToken = value ?? '';
    }
    await _ensureInitialized();
    await _preferences.setString(key, value ?? '');
    _loadCachedValues();
  }

  static Future<void> setBool(String key, bool value) async {
    await _ensureInitialized();
    await _preferences.setBool(key, value);
    _loadCachedValues();
  }

  static Future<void> setProfileCompleted(bool value) async {
    await setBool('isProfileCompleted', value);
    isProfileCompleted = value;
  }

  static Future<void> setInitialAssessmentCompleted(bool value) async {
    await setBool('isInitialAssessmentCompleted', value);
    isInitialAssessmentCompleted = value;
  }

  static Future<void> setInt(String key, int value) async {
    await _ensureInitialized();
    await _preferences.setInt(key, value);
  }

  static Future<void> remove(String key) async {
    await _ensureInitialized();
    await _preferences.remove(key);
    _loadCachedValues();
  }

  static Future<void> _ensureInitialized() async {
    if (!_initialized) await init();
  }

  static const String _firstSignInAtKey = 'firstSignInAt';
  static const String _feedbackPromptShownKey = 'feedbackPromptShown';

  static Future<void> recordFirstSignInIfNeeded() async {
    if (await getInt(_firstSignInAtKey) == -1) {
      await setInt(_firstSignInAtKey, DateTime.now().millisecondsSinceEpoch);
    }
  }

  static Future<bool> shouldShowFeedbackPrompt() async {
    if (await getBool(_feedbackPromptShownKey)) return false;

    final firstSignInAt = await getInt(_firstSignInAtKey);
    if (firstSignInAt == -1) return false;

    final signInDate = DateTime.fromMillisecondsSinceEpoch(firstSignInAt);
    return DateTime.now().difference(signInDate) >= const Duration(days: 3);
  }

  static Future<void> markFeedbackPromptShown() {
    return setBool(_feedbackPromptShownKey, true);
  }
}
