import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      debugPrint('🔥 [AUTH] Signing in with email: $email');

      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint('🔥 [AUTH] Sign in successful: ${result.user?.uid}');
      return result;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ [AUTH] FirebaseAuthException: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('❌ [AUTH] Unexpected error: $e');
      debugPrint('❌ [AUTH] Error type: ${e.runtimeType}');

      // Check if this is the PigeonUserDetails error during login
      if (e.toString().contains('PigeonUserDetails')) {
        debugPrint('🔄 [AUTH] Detected PigeonUserDetails error during login');
        debugPrint(
          '🔄 [AUTH] This is a known Firebase issue, but the user might be authenticated',
        );

        // Check if we actually have a current user despite the error
        final currentUser = _auth.currentUser;
        if (currentUser != null) {
          debugPrint('🔄 [AUTH] Found current user: ${currentUser.uid}');
          // The user is actually signed in, throw a special error to handle it
          throw 'USER_SIGNED_IN_BUT_FIREBASE_ERROR';
        }
      }

      throw 'Error inesperado: $e';
    }
  }

  // Register with email and password
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      debugPrint('🔥 [AUTH] Creating user with email: $email');

      // Add a small delay to avoid race conditions
      await Future.delayed(const Duration(milliseconds: 100));

      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add another small delay after creation
      await Future.delayed(const Duration(milliseconds: 100));

      debugPrint('🔥 [AUTH] User created successfully: ${result.user?.uid}');
      return result;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ [AUTH] FirebaseAuthException: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('❌ [AUTH] Unexpected error: $e');
      debugPrint('❌ [AUTH] Error type: ${e.runtimeType}');

      // Check if this is the PigeonUserDetails error
      if (e.toString().contains('PigeonUserDetails')) {
        debugPrint(
          '🔄 [AUTH] Detected PigeonUserDetails error - this is a known Firebase issue',
        );
        debugPrint(
          '🔄 [AUTH] The user was actually created successfully, but Firebase returned an error',
        );
        debugPrint('🔄 [AUTH] We can continue with the registration process');

        // Get the current user to continue
        final currentUser = _auth.currentUser;
        if (currentUser != null) {
          debugPrint('🔄 [AUTH] Found current user: ${currentUser.uid}');
          // Return a mock UserCredential to continue the process
          throw 'USER_CREATED_BUT_FIREBASE_ERROR';
        }
      }

      throw 'Error inesperado: $e';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Error signing out. Please try again.';
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'operation-not-allowed':
        return 'Email/password sign in is not enabled.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}
