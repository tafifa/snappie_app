import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class GoogleAuthService extends GetxService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  // Observable untuk status login
  final _isSigningIn = false.obs;
  final _currentUser = Rxn<User>();

  // Getters
  bool get isSigningIn => _isSigningIn.value;
  User? get currentUser => _currentUser.value;
  bool get isLoggedIn => _currentUser.value != null;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    _firebaseAuth.authStateChanges().listen((User? user) {
      _currentUser.value = user;
      if (kDebugMode) {
        print('🔐 Auth state changed: ${user?.email ?? "No user"}');
      }
    });
  }

  /// Sign in dengan Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      _isSigningIn.value = true;
      
      if (kDebugMode) {
        print('🔐 Starting Google Sign In process...');
      }

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        if (kDebugMode) {
          print('🔐 Google Sign In canceled by user');
        }
        return null;
      }

      if (kDebugMode) {
        print('🔐 Google user selected: ${googleUser.email}');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (kDebugMode) {
        print('🔐 Google authentication tokens obtained');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (kDebugMode) {
        print('🔐 Firebase sign in successful: ${userCredential.user?.email}');
        print('🔐 User display name: ${userCredential.user?.displayName}');
        print('🔐 User photo URL: ${userCredential.user?.photoURL}');
      }

      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Google Sign In error: $e');
      }
      rethrow;
    } finally {
      _isSigningIn.value = false;
    }
  }

  /// Sign out dari Google dan Firebase
  Future<void> signOut() async {
    try {
      if (kDebugMode) {
        print('🔐 Starting sign out process...');
      }

      // Sign out from Google
      await _googleSignIn.signOut();
      
      // Sign out from Firebase
      await _firebaseAuth.signOut();
      
      if (kDebugMode) {
        print('🔐 Sign out successful');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Sign out error: $e');
      }
      rethrow;
    }
  }

  /// Disconnect Google account (revoke access)
  Future<void> disconnect() async {
    try {
      if (kDebugMode) {
        print('🔐 Disconnecting Google account...');
      }

      await _googleSignIn.disconnect();
      await _firebaseAuth.signOut();
      
      if (kDebugMode) {
        print('🔐 Google account disconnected');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Disconnect error: $e');
      }
      rethrow;
    }
  }

  /// Get current Firebase user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  /// Get Firebase ID Token
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        return await user.getIdToken(forceRefresh);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting ID token: $e');
      }
      return null;
    }
  }

  /// Check if user is signed in with Google
  bool isSignedInWithGoogle() {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return user.providerData.any((info) => info.providerId == 'google.com');
    }
    return false;
  }

  /// Get user profile data
  Map<String, dynamic>? getUserProfile() {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'emailVerified': user.emailVerified,
        'isAnonymous': user.isAnonymous,
        'creationTime': user.metadata.creationTime?.toIso8601String(),
        'lastSignInTime': user.metadata.lastSignInTime?.toIso8601String(),
      };
    }
    return null;
  }

  /// Stream untuk mendengarkan perubahan auth state
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Stream untuk mendengarkan perubahan user
  Stream<User?> get userChanges => _firebaseAuth.userChanges();
}