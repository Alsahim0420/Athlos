import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../../../../core/adapters/timestamp_adapter.dart';

class SessionService {
  static const String _boxName = 'session';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userIdKey = 'userId';
  static const String _userEmailKey = 'userEmail';
  static const String _userDataKey = 'userData';

  // Initialize Hive
  static Future<void> init() async {
    debugPrint('🔧 [SESSION] Starting Hive initialization...');

    await Hive.initFlutter();
    debugPrint('✅ [SESSION] Hive.initFlutter() completed');

    // Register adapters
    debugPrint('🔧 [SESSION] Checking if TimestampAdapter is registered...');
    if (!Hive.isAdapterRegistered(100)) {
      debugPrint(
        '🔧 [SESSION] TimestampAdapter not registered, registering now...',
      );
      Hive.registerAdapter(TimestampAdapter());
      debugPrint(
        '✅ [SESSION] TimestampAdapter registered successfully with typeId: 100',
      );
    } else {
      debugPrint('✅ [SESSION] TimestampAdapter already registered');
    }

    debugPrint('🔧 [SESSION] Opening session box...');
    await Hive.openBox(_boxName);
    debugPrint('✅ [SESSION] Session box opened successfully');

    debugPrint('✅ [SESSION] Hive initialization completed successfully!');
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

  // Get complete user data
  UserModel? get userData {
    final box = Hive.box(_boxName);
    final userMap = box.get(_userDataKey);
    if (userMap != null) {
      // Cast the dynamic map to Map<String, dynamic> safely
      try {
        if (userMap is Map) {
          final Map<String, dynamic> typedMap = Map<String, dynamic>.from(
            userMap,
          );
          return UserModel.fromMap(typedMap);
        } else {
          debugPrint(
            '❌ [SESSION] userMap is not a Map: ${userMap.runtimeType}',
          );
          return null;
        }
      } catch (e) {
        debugPrint('❌ [SESSION] Error casting userMap: $e');
        return null;
      }
    }
    return null;
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

  // Save complete user session with data
  Future<void> saveUserSession({required UserModel user}) async {
    try {
      debugPrint('💾 [SESSION] Saving complete user session to Hive');
      debugPrint('💾 [SESSION] User: ${user.fullName} (${user.uid})');

      // Double-check that TimestampAdapter is registered
      debugPrint('🔧 [SESSION] Verifying TimestampAdapter registration...');
      if (!Hive.isAdapterRegistered(100)) {
        debugPrint(
          '⚠️ [SESSION] TimestampAdapter not registered, registering now...',
        );
        Hive.registerAdapter(TimestampAdapter());
        debugPrint(
          '✅ [SESSION] TimestampAdapter registered during save operation',
        );
      } else {
        debugPrint('✅ [SESSION] TimestampAdapter is properly registered');
      }

      final box = Hive.box(_boxName);
      await box.put(_isLoggedInKey, true);
      await box.put(_userIdKey, user.uid);
      await box.put(_userEmailKey, user.email);
      await box.put(_userDataKey, user.toMap());

      debugPrint(
        '✅ [SESSION] Complete user session saved successfully to Hive',
      );
    } catch (e) {
      debugPrint('❌ [SESSION] Error saving user session: $e');
      debugPrint('❌ [SESSION] Error type: ${e.runtimeType}');
      rethrow;
    }
  }

  // Clear login session
  Future<void> clearLoginSession() async {
    final box = Hive.box(_boxName);
    await box.put(_isLoggedInKey, false);
    await box.delete(_userIdKey);
    await box.delete(_userEmailKey);
    await box.delete(_userDataKey);
  }

  // Close Hive
  Future<void> close() async {
    await Hive.close();
  }
}
