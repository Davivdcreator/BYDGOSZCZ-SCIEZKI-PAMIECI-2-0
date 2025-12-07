import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _usersCollection => _firestore.collection('users');

  // Sync user data to Firestore on login
  Future<void> syncUser(User user) async {
    try {
      final userDoc = _usersCollection.doc(user.uid);
      final snapshot = await userDoc.get();

      if (!snapshot.exists) {
        // Create new user document
        final newUser = UserModel(
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
        );
        await userDoc.set({
          ...newUser.toMap(),
          'createdAt': DateTime.now().toIso8601String(),
          'points': 0, // Initialize points
        });
      } else {
        // Update basic info (last seen, display name if changed)
        await userDoc.update({
          'lastSeen': DateTime.now().toIso8601String(),
          if (user.displayName != null) 'displayName': user.displayName,
          if (user.email != null) 'email': user.email,
        });
      }
    } catch (e) {
      debugPrint('Error syncing user: $e');
      // Non-blocking error for UI, but important to log
    }
  }

  // Get user profile stream
  Stream<DocumentSnapshot> getUserStream(String uid) {
    return _usersCollection.doc(uid).snapshots();
  }
}
