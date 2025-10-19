import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:tawazon/shared/bloc/user_cubit.dart';
import 'package:tawazon/config/app_errors.dart';
import 'package:tawazon/config/firestore_tables.dart';
import '../entities/session_entity.dart';
import '../entities/session_status.dart';

/// Use case for completing the entire session
class CompleteSession {
  final FirebaseFirestore _firestore;

  CompleteSession({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Marks the whole session as completed in persistence and returns updated entity
  Future<Either<Failure, SessionEntity>> call({
    required SessionEntity session,
    Map<String, dynamic>? inputs,
  }) async {
    try {
      final userId = UserCubit.instance.user.id ?? "";
      final now = Timestamp.now();
      final completedScreens = session.steps.length;

      await _firestore.collection(FireStoreTables.userProgress).doc(userId).update({
        'sessions.${session.id}.screenProgress.completedScreens': completedScreens,
        'sessions.${session.id}.status': EnumSessionStatus.completed.value,
        'sessions.${session.id}.completedAt': now,
        if (inputs != null) 'sessions.${session.id}.quiz': inputs,
        'updatedAt': now,
      });

      final updated = session.copyWith(
        currentStep: session.steps.length - 1,
        status: EnumSessionStatus.completed,
        completedAt: now.toDate(),
      );

      return Right(updated);
    } catch (_) {
      return Left(UnknownFailure('Failed to complete session'));
    }
  }
}
