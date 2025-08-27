import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/http_service.dart';
import '../models/user_model.dart';
import 'dart:convert';

class UserApiService extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();

  // Example API endpoints
  static const String _usersEndpoint = '/users';
  static const String _profileEndpoint = '/profile';
  static const String _updateProfileEndpoint = '/profile/update';

  // Get user profile from external API
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final response = await _httpService.get('$_profileEndpoint/$userId');

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        return UserModel.fromMap(userData);
      }

      return null;
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  // Update user profile via external API
  Future<bool> updateUserProfile(
    String userId,
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await _httpService.put(
        '$_updateProfileEndpoint/$userId',
        body: json.encode(profileData),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      return false;
    }
  }

  // Get all users from external API (example for admin functionality)
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _httpService.get(_usersEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> usersData = json.decode(response.body);
        return usersData
            .map((userData) => UserModel.fromMap(userData))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error getting all users: $e');
      return [];
    }
  }

  // Search users by name via external API
  Future<List<UserModel>> searchUsersByName(String searchTerm) async {
    try {
      final response = await _httpService.get(
        _usersEndpoint,
        queryParameters: {'search': searchTerm},
      );

      if (response.statusCode == 200) {
        final List<dynamic> usersData = json.decode(response.body);
        return usersData
            .map((userData) => UserModel.fromMap(userData))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error searching users: $e');
      return [];
    }
  }

  // Sync local user data with external API
  Future<bool> syncUserData(UserModel localUser) async {
    try {
      final response = await _httpService.post(
        '$_usersEndpoint/sync',
        body: json.encode(localUser.toMap()),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error syncing user data: $e');
      return false;
    }
  }
}
