import 'package:dartz/dartz.dart';
import 'package:tawazon/features/session/core/sessions_hard_coded_content/session_1_content.dart';
import 'package:tawazon/features/session/core/sessions_hard_coded_content/session_2_content.dart';
import 'package:tawazon/features/session/core/sessions_hard_coded_content/session_3_content.dart';
import 'package:tawazon/features/session/core/sessions_hard_coded_content/session_4_content.dart';
import 'package:tawazon/features/session/core/sessions_hard_coded_content/session_5_content.dart';
import 'package:tawazon/features/session/core/sessions_hard_coded_content/session_6_content.dart';

import '../../../../config/app_errors.dart';
import '../entities/session_entity.dart';
import '../entities/session_status.dart';
import '../entities/session_step_entity.dart';

/// Use case for retrieving a session by ID with hardcoded data
class GetSession {
  const GetSession();

  /// Executes the use case to get a session
  ///
  /// [sessionId] The ID of the session to retrieve
  ///
  /// Returns [Either<Failure, SessionEntity>] containing the session data
  /// or a failure if the operation fails
  Future<Either<Failure, SessionEntity>> call(
      String sessionId, int completedScreenCount) async {
    if (sessionId.isEmpty) {
      return Left(ValidationFailure("Session ID cannot be empty"));
    }

    try {
      // Return hardcoded session data
      final session = _createHardcodedSession(sessionId);
      final updatedSessionSteps =
          _updateStepsCompletion(session.steps, completedScreenCount);
      SessionEntity finalSession = session.copyWith(
          steps: updatedSessionSteps, currentStep: completedScreenCount- (completedScreenCount== session.steps.length ? 1 : 0));
      return Right(finalSession);
    } catch (e) {
      return Left(UnknownFailure('Failed to retrieve session'));
    }
  }

  /// Updates the completion status of steps based on the number of completed screens
  ///
  /// [steps] The list of session steps to update
  /// [completedScreenCount] The number of screens that have been completed
  ///
  /// Returns a new list of steps with updated completion status
  List<SessionStepEntity> _updateStepsCompletion(
      List<SessionStepEntity> steps, int completedScreenCount) {
    final updatedSteps = <SessionStepEntity>[];

    for (int i = 0; i < steps.length; i++) {
      final step = steps[i];
      final isCompleted = i < completedScreenCount;

      updatedSteps.add(step.copyWith(isCompleted: isCompleted));
    }

    return updatedSteps;
  }

  List<SessionStepEntity> _mapSessionStepsToSessionEntity(String sessionID) {
    switch (sessionID) {
      case 'session_1':
        return session1steps;
      case 'session_2':
        return session2steps;
      case 'session_3':
        return session3steps;
      case 'session_4':
        return session4steps;
      case 'session_5':
        return session5steps;
      case 'session_6':
        return session6steps;
      default:
        return session1steps;
    }
  }

  String _mapSessionTitle(String sessionID) {
    switch (sessionID) {
      case 'session_1':
        return 'الجلسة التدريبية الأولى';
      case 'session_2':
        return 'الجلسة التدريبية الثانية';
      case 'session_3':
        return 'الجلسة التدريبية الثالثة';
      case 'session_4':
        return 'الجلسة التدريبية الرابعة';
      case 'session_5':
        return 'الجلسة التدريبية الخامسة';
      case 'session_6':
        return 'الجلسة التدريبية السادسة';
      default:
        return 'الجلسة التدريبية الأولى';
    }
  }

  String _mapSessionDescription(String sessionID) {
    switch (sessionID) {
      case 'session_1':
        return 'جلسة تدريبية تفاعلية تحتوي على 7 خطوات متنوعة للتعلم والتطبيق';
      case 'session_2':
        return 'جلسة تدريبية تفاعلية تحتوي على 2 خطوات متنوعة للتعلم والتطبيق';
      case 'session_3':
        return 'جلسة تدريبية تفاعلية تحتوي على 3 خطوات متنوعة للتعلم والتطبيق';
      case 'session_4':
        return 'جلسة تدريبية تفاعلية تحتوي على 4 خطوات متنوعة للتعلم والتطبيق';
      case 'session_5':
        return 'جلسة تدريبية تفاعلية تحتوي على 5 خطوات متنوعة للتعلم والتطبيق';
      case 'session_6':
        return 'جلسة تدريبية تفاعلية تحتوي على 6 خطوات متنوعة للتعلم والتطبيق';
      default:
        return 'جلسة تدريبية تفاعلية تحتوي على 7 خطوات متنوعة للتعلم والتطبيق';
    }
  }

  /// Creates a hardcoded session with 7 steps, later will be updated to fetch step by session id,
  /// but still the steps will be hard coded
  SessionEntity _createHardcodedSession(String sessionId) {
    return SessionEntity(
      id: sessionId,
      title: _mapSessionTitle(sessionId),
      description: _mapSessionDescription(sessionId),
      steps: _mapSessionStepsToSessionEntity(sessionId),
      currentStep: 0,
      status: EnumSessionStatus.notStarted,
      createdAt: DateTime.now(),
    );
  }
}
