import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../config/app_errors.dart';
import '../../../../config/firestore_tables.dart';
import '../entities/sessions_overall_progress_entity.dart';

/// A use case class for fetching user sessions overall progress from Firebase Firestore.
/// 
/// This class handles the retrieval of user progress documents from the 'user_progress' collection.
/// The document contains session progress tracking, quiz results, and overall progress metrics.
/// 
/// Example usage:
/// ```dart
/// final getSessionsProgress = GetSessionsOverallProgress();
/// final result = await getSessionsProgress.call(userId: 'user123');
/// ```
class GetSessionsOverallProgress {
  final FirebaseFirestore _firestore;

  /// Creates an instance of [GetSessionsOverallProgress].
  /// 
  /// [firestore] The Firestore instance to use. Defaults to the default instance.
  GetSessionsOverallProgress({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches the user sessions overall progress from the 'user_progress' collection.
  /// 
  /// [userId] The unique identifier for the user. This will be used as the document ID.
  /// 
  /// Returns [Either<Failure, SessionsOverallProgressEntity>] where:
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side contains [SessionsOverallProgressEntity] if the document was fetched successfully
  /// 
  /// Throws [ValidationFailure] if userId is empty or null.
  /// Throws [NotFoundFailure] if the user progress document doesn't exist.
  /// Throws [ServerFailure] if Firestore operation fails.
  /// Throws [UnknownFailure] for unexpected errors.
  Future<Either<Failure, SessionsOverallProgressEntity>> call({
    required String userId,
  }) async {
    try {
      // Validate input
      if (userId.isEmpty) {
        return Left(ValidationFailure("User ID cannot be empty"));
      }

      // Fetch document from Firestore with userId as document ID
      final docSnapshot = await _firestore
          .collection(FireStoreTables.userProgress)
          .doc(userId)
          .get();

      // Check if document exists
      if (!docSnapshot.exists) {
        return Left(NotFoundFailure('User progress not found for user: $userId'));
      }

      // Get document data
      final data = docSnapshot.data();
      if (data == null) {
        return Left(ServerFailure('User progress document is empty'));
      }

      // Mapping to entity
      final progressEntity = SessionsOverallProgressEntity.fromMap(data);

      return Right(progressEntity);
    } on FirebaseException catch (e) {
      return Left(ServerFailure('Failed to fetch user progress: ${e.message}'));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error occurred while fetching user progress'));
    }
  }
}
