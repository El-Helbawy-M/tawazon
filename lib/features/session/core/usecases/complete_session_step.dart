import 'dart:developer';

import 'package:tawazon/shared/bloc/user_cubit.dart';
import 'package:tawazon/config/firestore_tables.dart';
import 'package:tawazon/features/session/core/entities/session_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../config/app_errors.dart';
import '../../../../handlers/audio_player_handler.dart';
import '../entities/session_entity.dart';

/// Use case for completing a session step and user progress in Firestore
class CompleteSessionStep {
  final FirebaseFirestore _firestore;

  /// Creates an instance of [UpdateSessionStep].
  ///
  /// [firestore] The Firestore instance to use. Defaults to the default instance.
  CompleteSessionStep({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Executes the use case to complete a session step
  ///
  /// [sessionEntity] The current session entity to update
  /// [stepIndex] The index of the step to complete
  ///
  /// Returns [Either<Failure, SessionEntity>] containing the updated session
  /// or a failure if the operation fails
  Either<Failure, SessionEntity> call({
    required SessionEntity sessionEntity,
    required int stepIndex,
  }) {
    try {
      // Mark the step as completed
      final currentStep = sessionEntity.steps[stepIndex];
      final updatedSession = sessionEntity.copyWith(currentStep: stepIndex+1);
      if (!currentStep.isCompleted) {
        sessionEntity.steps[stepIndex] = currentStep.copyWith(isCompleted: true);
        var updatedSessionSteps = updatedSession.copyWith(steps: sessionEntity.steps);
        _updateUserProgress(updatedSessionSteps);
        return Right(updatedSessionSteps);
      }
      return Right(updatedSession);
    } catch (e) {
      return Left(UnknownFailure('Failed to complete session step'));
    }
  }

  /// Updates the user progress document in Firestore
  ///
  /// [sessionEntity] The session entity containing updated progress data
  Future<void> _updateUserProgress(SessionEntity sessionEntity) async {
    // For now, we'll use a hardcoded userId. In a real shared, this would come from authentication
    String userId = UserCubit.instance.user.id ?? "";

    final now = Timestamp.now();
    final completedScreens = sessionEntity.currentStep;

    // Determine session status based on progress
    EnumSessionStatus status;
    if (completedScreens == 0) {
      status = EnumSessionStatus.notStarted;
    } else {
      status = EnumSessionStatus.inProgress;
    }

    // Update the specific session's progress in the user_progress document
    final updateData = <String, dynamic>{
      'sessions.${sessionEntity.id}.screenProgress.completedScreens': completedScreens,
      'sessions.${sessionEntity.id}.status': status.value,
      'updatedAt': now,
    };

    await _firestore
        .collection(FireStoreTables.userProgress)
        .doc(userId)
        .update(updateData);
  }
}
