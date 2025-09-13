import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../config/app_errors.dart';
import '../../../../config/firestore_tables.dart';

/// A use case class for creating user documents in Firebase Firestore.
/// 
/// This class handles the creation of initial user documents
/// when a user registers for the first time. The document contains
/// basic user information including ID, email, and profile completion status.
/// 
/// Example usage:
/// ```dart
/// final createFirestoreUser = CreateFirestoreUser();
/// final result = await createFirestoreUser.call(userId: 'user123', email: 'user@example.com');
/// ```
class CreateFirestoreUser {
  final FirebaseFirestore _firestore;

  /// Creates an instance of [CreateFirestoreUser].
  /// 
  /// [firestore] The Firestore instance to use. Defaults to the default instance.
  CreateFirestoreUser({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Creates a user document in the 'users' collection.
  /// 
  /// [userId] The unique identifier for the user. This will be used as the document ID.
  /// [email] The user's email address.
  /// 
  /// Returns [Either<Failure, bool>] where:
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side contains [true] if the document was created successfully
  /// 
  /// Throws [ValidationFailure] if userId or email is empty or null.
  /// Throws [ServerFailure] if Firestore operation fails.
  /// Throws [UnknownFailure] for unexpected errors.
  Future<Either<Failure, bool>> call({
    required String userId,
    required String email,
  }) async {
    try {
      // Validate input
      if (userId.isEmpty) {
        return Left(ValidationFailure("User ID cannot be empty"));
      }
      
      if (email.isEmpty) {
        return Left(ValidationFailure("Email cannot be empty"));
      }

      // Create the initial user document structure
      final userData = _createInitialUserData(userId, email);

      // Create document in Firestore with userId as document ID
      await _firestore
          .collection(FireStoreTables.users)
          .doc(userId)
          .set(userData);

      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(ServerFailure('Failed to create user document: ${e.message}'));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error occurred while creating user document'));
    }
  }

  /// Creates the initial user document structure.
  /// 
  /// [userId] The user ID to include in the document.
  /// [email] The user's email address.
  /// 
  /// Returns a [Map<String, dynamic>] representing the initial document structure.
  Map<String, dynamic> _createInitialUserData(String userId, String email) {
    return {
      'id': userId,
      'email': email,
      'has_completed_profile': false,
    };
  }
}
