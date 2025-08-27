import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Register with email and password
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      print('🔥 [AUTH] Creating user with email: $email');

      // Add a small delay to avoid race conditions
      await Future.delayed(const Duration(milliseconds: 100));

      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add another small delay after creation
      await Future.delayed(const Duration(milliseconds: 100));

      print('🔥 [AUTH] User created successfully: ${result.user?.uid}');
      return result;
    } on FirebaseAuthException catch (e) {
      print('❌ [AUTH] FirebaseAuthException: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ [AUTH] Unexpected error: $e');
      print('❌ [AUTH] Error type: ${e.runtimeType}');

      // Check if this is the PigeonUserDetails error
      if (e.toString().contains('PigeonUserDetails')) {
        print(
          '🔄 [AUTH] Detected PigeonUserDetails error - this is a known Firebase issue',
        );
        print(
          '🔄 [AUTH] The user was actually created successfully, but Firebase returned an error',
        );
        print('🔄 [AUTH] We can continue with the registration process');

        // Get the current user to continue
        final currentUser = _auth.currentUser;
        if (currentUser != null) {
          print('🔄 [AUTH] Found current user: ${currentUser.uid}');
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
