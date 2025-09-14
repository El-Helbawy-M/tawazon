import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../config/app_errors.dart';
import '../../../../config/firestore_tables.dart';

/// A use case class for creating user progress documents in Firebase Firestore.
/// 
/// This class handles the creation of initial user progress documents
/// when a user registers for the first time. The document contains
/// session progress tracking, quiz results, and overall progress metrics.
/// 
/// Example usage:
/// ```dart
/// final createUserProgress = CreateUserProgress();
/// final result = await createUserProgress.call(userId: 'user123');
/// ```
class CreateUserProgress {
  final FirebaseFirestore _firestore;

  /// Creates an instance of [CreateUserProgress].
  /// 
  /// [firestore] The Firestore instance to use. Defaults to the default instance.
  CreateUserProgress({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Creates a user progress document in the 'user_progress' collection.
  /// 
  /// [userId] The unique identifier for the user. This will be used as the document ID.
  /// 
  /// Returns [Either<Failure, bool>] where:
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side contains [true] if the document was created successfully
  /// 
  /// Throws [ValidationFailure] if userId is empty or null.
  /// Throws [ServerFailure] if Firestore operation fails.
  /// Throws [UnknownFailure] for unexpected errors.
  Future<Either<Failure, bool>> call({required String userId}) async {
    try {
      // Validate input
      if (userId.isEmpty) {
        return Left(ValidationFailure("User ID cannot be empty"));
      }

      // Create the initial user progress document structure
      final userProgressData = _createInitialUserProgressData(userId);

      // Create document in Firestore with userId as document ID
      await _firestore
          .collection(FireStoreTables.userProgress)
          .doc(userId)
          .set(userProgressData);

      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(ServerFailure('Failed to create user progress: ${e.message}'));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error occurred while creating user progress'));
    }
  }

  /// Creates the initial user progress document structure.
  /// 
  /// [userId] The user ID to include in the document.
  /// 
  /// Returns a [Map<String, dynamic>] representing the initial document structure.
  Map<String, dynamic> _createInitialUserProgressData(String userId) {
    final now = Timestamp.now();
    return {
      'userId': userId,
      'sessions': <String, dynamic>{
        'session_1': {
          'sessionId': 'session_1',
          'sessionName': 'المشاعر',
          'screenProgress': {
            'totalScreens': 7,
            'completedScreens': 0,
            'completedScreenIds': <String>[],
            'lastCompletedAt': null,
            'startedAt': null,
          },
          'quiz': <String, dynamic>{},
          'status': 'not_started',
        },
        'session_2': {
          'sessionId': 'session_2',
          'sessionName': 'Understanding Anxiety',
          'screenProgress': {
            'totalScreens': null,
            'completedScreens': 0,
            'completedScreenIds': <String>[],
            'lastCompletedAt': null,
            'startedAt': null,
          },
          'quiz': <String, dynamic>{},
          'status': 'not_started',
        },
        'session_3': {
          'sessionId': 'session_3',
          'sessionName': 'Coping with Depression',
          'screenProgress': {
            'totalScreens': null,
            'completedScreens': 0,
            'completedScreenIds': <String>[],
            'lastCompletedAt': null,
            'startedAt': null,
          },
          'quiz': <String, dynamic>{},
          'status': 'not_started',
        },
        'session_4': {
          'sessionId': 'session_4',
          'sessionName': 'Stress Management Techniques',
          'screenProgress': {
            'totalScreens': null,
            'completedScreens': 0,
            'completedScreenIds': <String>[],
            'lastCompletedAt': null,
            'startedAt': null,
          },
          'quiz': <String, dynamic>{},
          'status': 'not_started',
        },
        'session_5': {
          'sessionId': 'session_5',
          'sessionName': 'Building Resilience',
          'screenProgress': {
            'totalScreens': null,
            'completedScreens': 0,
            'completedScreenIds': <String>[],
            'lastCompletedAt': null,
            'startedAt': null,
          },
          'quiz': <String, dynamic>{},
          'status': 'not_started',
        },
        'session_6': {
          'sessionId': 'session_6',
          'sessionName': 'Mindfulness and Meditation',
          'screenProgress': {
            'totalScreens': null,
            'completedScreens': 0,
            'completedScreenIds': <String>[],
            'lastCompletedAt': null,
            'startedAt': null,
          },
          'quiz': <String, dynamic>{},
          'status': 'not_started',
        },
        'session_7': {
          'sessionId': 'session_7',
          'sessionName': 'Healthy Relationships',
          'screenProgress': {
            'totalScreens': null,
            'completedScreens': 0,
            'completedScreenIds': <String>[],
            'lastCompletedAt': null,
            'startedAt': null,
          },
          'quiz': <String, dynamic>{},
          'status': 'not_started',
        },
        'session_8': {
          'sessionId': 'session_8',
          'sessionName': 'Maintaining Mental Wellness',
          'screenProgress': {
            'totalScreens': null,
            'completedScreens': 0,
            'completedScreenIds': <String>[],
            'lastCompletedAt': null,
            'startedAt': null,
          },
          'quiz': <String, dynamic>{},
          'status': 'not_started',
        },
      },
      'overallProgress': {
        'totalSessions': 8, // This should be configured based on your app's total sessions
        'completedSessions': 0,
        'inProgressSessions': 0,
        'lastActivity': now,
      },
      'createdAt': now,
      'updatedAt': now,
    };
  }
}
