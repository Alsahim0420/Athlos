import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // Default values for Remote Config
  static const Map<String, dynamic> _defaults = {
    'rapidapi_key': '9594eef185msh67656f22f101aa4p1da1b2jsn5d39865a75f5',
    'api_timeout': 30000,
    'max_exercises_limit': 50,
    'enable_debug_logs': true,
  };

  // Remote Config keys
  static const String _rapidApiKeyKey = 'rapidapi_key';
  static const String _apiTimeoutKey = 'api_timeout';
  static const String _maxExercisesLimitKey = 'max_exercises_limit';
  static const String _enableDebugLogsKey = 'enable_debug_logs';

  Future<void> initialize() async {
    try {
      debugPrint('🔧 [REMOTE_CONFIG] Initializing Remote Config...');
      
      // Set default values
      await _remoteConfig.setDefaults(_defaults);
      
      // Set minimum fetch interval (0 for development, higher for production)
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: kDebugMode 
          ? const Duration(seconds: 0)  // Development: fetch immediately
          : const Duration(hours: 1),   // Production: fetch every hour
      ));

      // Fetch and activate config
      await _remoteConfig.fetchAndActivate();
      
      debugPrint('✅ [REMOTE_CONFIG] Remote Config initialized successfully!');
      debugPrint('🔧 [REMOTE_CONFIG] RapidAPI Key: ${_getRapidApiKey()}');
      debugPrint('🔧 [REMOTE_CONFIG] API Timeout: ${_getApiTimeout()}ms');
      debugPrint('🔧 [REMOTE_CONFIG] Max Exercises: ${_getMaxExercisesLimit()}');
      debugPrint('🔧 [REMOTE_CONFIG] Debug Logs: ${_getEnableDebugLogs()}');
      
    } catch (e) {
      debugPrint('❌ [REMOTE_CONFIG] Error initializing Remote Config: $e');
      debugPrint('⚠️ [REMOTE_CONFIG] Using default values...');
    }
  }

  // Get RapidAPI Key from Remote Config
  String _getRapidApiKey() {
    try {
      return _remoteConfig.getString(_rapidApiKeyKey);
    } catch (e) {
      debugPrint('❌ [REMOTE_CONFIG] Error getting RapidAPI key: $e');
      return _defaults[_rapidApiKeyKey] as String;
    }
  }

  // Get API Timeout from Remote Config
  int _getApiTimeout() {
    try {
      return _remoteConfig.getInt(_apiTimeoutKey);
    } catch (e) {
      debugPrint('❌ [REMOTE_CONFIG] Error getting API timeout: $e');
      return _defaults[_apiTimeoutKey] as int;
    }
  }

  // Get Max Exercises Limit from Remote Config
  int _getMaxExercisesLimit() {
    try {
      return _remoteConfig.getInt(_maxExercisesLimitKey);
    } catch (e) {
      debugPrint('❌ [REMOTE_CONFIG] Error getting max exercises limit: $e');
      return _defaults[_maxExercisesLimitKey] as int;
    }
  }

  // Get Enable Debug Logs from Remote Config
  bool _getEnableDebugLogs() {
    try {
      return _remoteConfig.getBool(_enableDebugLogsKey);
    } catch (e) {
      debugPrint('❌ [REMOTE_CONFIG] Error getting enable debug logs: $e');
      return _defaults[_enableDebugLogsKey] as bool;
    }
  }

  // Public getters
  String get rapidApiKey => _getRapidApiKey();
  int get apiTimeout => _getApiTimeout();
  int get maxExercisesLimit => _getMaxExercisesLimit();
  bool get enableDebugLogs => _getEnableDebugLogs();

  // Force refresh config (useful for testing)
  Future<void> refreshConfig() async {
    try {
      debugPrint('🔄 [REMOTE_CONFIG] Refreshing Remote Config...');
      await _remoteConfig.fetchAndActivate();
      debugPrint('✅ [REMOTE_CONFIG] Remote Config refreshed successfully!');
    } catch (e) {
      debugPrint('❌ [REMOTE_CONFIG] Error refreshing Remote Config: $e');
    }
  }

  // Get all config values as a map (useful for debugging)
  Map<String, dynamic> getAllConfig() {
    return {
      'rapidapi_key': rapidApiKey,
      'api_timeout': apiTimeout,
      'max_exercises_limit': maxExercisesLimit,
      'enable_debug_logs': enableDebugLogs,
    };
  }
}
