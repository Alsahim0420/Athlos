import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _usersCollection = 'users';

  // Create new user document
  Future<void> createUser(UserModel user) async {
    try {
      debugPrint('🔥 [FIRESTORE] Creating user document for UID: ${user.uid}');
      debugPrint('🔥 [FIRESTORE] User data: ${user.toMap()}');

      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .set(user.toMap());

      debugPrint('🔥 [FIRESTORE] User document created successfully!');
    } catch (e) {
      debugPrint('❌ [FIRESTORE] Error creating user profile: $e');
      debugPrint('❌ [FIRESTORE] Error type: ${e.runtimeType}');
      throw 'Error creating user profile: $e';
    }
  }

  // Get user by UID
  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Error fetching user: $e';
    }
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .update(user.toMap());
    } catch (e) {
      throw 'Error updating user: $e';
    }
  }

  // Delete user
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).delete();
    } catch (e) {
      throw 'Error deleting user: $e';
    }
  }

  // Check if user exists
  Future<bool> userExists(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Get all users (for admin purposes)
  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw 'Error fetching users: $e';
    }
  }

  // Search users by name
  Future<List<UserModel>> searchUsersByName(String searchTerm) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('firstName', isGreaterThanOrEqualTo: searchTerm)
          .where('firstName', isLessThan: '$searchTerm\uf8ff')
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw 'Error searching users: $e';
    }
  }
}
