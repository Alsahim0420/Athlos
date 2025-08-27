import 'package:hive_flutter/hive_flutter.dart';

class SessionService {
  static const String _boxName = 'session';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userIdKey = 'userId';
  static const String _userEmailKey = 'userEmail';

  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  // Check if user is logged in
  bool get isLoggedIn {
    final box = Hive.box(_boxName);
    return box.get(_isLoggedInKey, defaultValue: false) ?? false;
  }

  // Get user ID
  String? get userId {
    final box = Hive.box(_boxName);
    return box.get(_userIdKey);
  }

  // Get user email
  String? get userEmail {
    final box = Hive.box(_boxName);
    return box.get(_userEmailKey);
  }

  // Save login session
  Future<void> saveLoginSession({
    required String userId,
    required String email,
  }) async {
    final box = Hive.box(_boxName);
    await box.put(_isLoggedInKey, true);
    await box.put(_userIdKey, userId);
    await box.put(_userEmailKey, email);
  }

  // Clear login session
  Future<void> clearLoginSession() async {
    final box = Hive.box(_boxName);
    await box.put(_isLoggedInKey, false);
    await box.delete(_userIdKey);
    await box.delete(_userEmailKey);
  }

  // Close Hive
  Future<void> close() async {
    await Hive.close();
  }
}
