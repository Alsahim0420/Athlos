class ApiConfig {
  // Base URLs for different environments
  static const String devBaseUrl = 'https://dev-api.athlos.app';
  static const String stagingBaseUrl = 'https://staging-api.athlos.app';
  static const String productionBaseUrl = 'https://api.athlos.app';

  // Current environment (change this based on your build configuration)
  static const String currentBaseUrl = devBaseUrl;

  // API Version
  static const String apiVersion = 'v1';

  // Timeout configurations
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

    // ExerciseDB API Configuration
  static const String exerciseDbBaseUrl = 'https://exercisedb.p.rapidapi.com';
  static const String exerciseDbHost = 'exercisedb.p.rapidapi.com';
  
  // ExerciseDB Headers - Now using Remote Config
  static Map<String, String> get exerciseDbHeaders {
    // Import RemoteConfigService here to avoid circular dependency
    // This will be called after RemoteConfigService is initialized
    try {
      // Dynamic import to avoid circular dependency
      final remoteConfig = _getRemoteConfigService();
      return {
        'X-RapidAPI-Host': exerciseDbHost,
        'X-RapidAPI-Key': remoteConfig?.rapidApiKey ?? '9594eef185msh67656f22f101aa4p1da1b2jsn5d39865a75f5',
      };
    } catch (e) {
      // Fallback to hardcoded key if Remote Config is not available
      return {
        'X-RapidAPI-Host': exerciseDbHost,
        'X-RapidAPI-Key': '9594eef185msh67656f22f101aa4p1da1b2jsn5d39865a75f5',
      };
    }
  }
  
  // Helper method to get RemoteConfigService instance
  static dynamic _getRemoteConfigService() {
    try {
      // This is a workaround to avoid circular dependency
      // In a real app, you might want to use dependency injection
      return null; // Will be set after initialization
    } catch (e) {
      return null;
    }
  }

  // Authentication endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String logoutEndpoint = '/auth/logout';

  // User endpoints
  static const String userProfileEndpoint = '/users/profile';
  static const String updateProfileEndpoint = '/users/profile/update';
  static const String usersEndpoint = '/users';
  static const String searchUsersEndpoint = '/users/search';

  // Workout endpoints (example for future features)
  static const String workoutsEndpoint = '/workouts';
  static const String createWorkoutEndpoint = '/workouts/create';
  static const String workoutHistoryEndpoint = '/workouts/history';

  // Nutrition endpoints (example for future features)
  static const String nutritionEndpoint = '/nutrition';
  static const String mealPlanEndpoint = '/nutrition/meal-plan';
  static const String foodDatabaseEndpoint = '/nutrition/foods';

  // Progress tracking endpoints (example for future features)
  static const String progressEndpoint = '/progress';
  static const String measurementsEndpoint = '/progress/measurements';
  static const String goalsEndpoint = '/progress/goals';

  // Helper method to get full API URL
  static String getApiUrl(String endpoint) {
    return '$currentBaseUrl/api/$apiVersion$endpoint';
  }

  // Helper method to get base URL without API version
  static String getBaseUrl(String endpoint) {
    return '$currentBaseUrl$endpoint';
  }
}
