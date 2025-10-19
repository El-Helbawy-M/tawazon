import 'package:flutter_test/flutter_test.dart';
import 'package:tawazon/features/session/core/entities/session_entity.dart';
import 'package:tawazon/features/session/core/entities/session_step_entity.dart';
import 'package:tawazon/features/session/core/entities/session_status.dart';
import 'package:tawazon/features/session/core/entities/content_item_entity.dart';

void main() {
  group('SessionEntity', () {
    late SessionEntity tSessionEntity;
    late List<SessionStepEntity> tSteps;
    late DateTime tCreatedAt;

    setUp(() {
      tCreatedAt = DateTime(2024, 1, 1);
      tSteps = [
        const SessionStepEntity(
          id: 'step_1',
          title: 'Step 1',
          contentItems: [],
          type: SessionStepType.introduction,
          isCompleted: false,
        ),
        const SessionStepEntity(
          id: 'step_2',
          title: 'Step 2',
          contentItems: [],
          type: SessionStepType.content,
          isCompleted: true,
        ),
        const SessionStepEntity(
          id: 'step_3',
          title: 'Step 3',
          contentItems: [],
          type: SessionStepType.conclusion,
          isCompleted: false,
        ),
      ];

      tSessionEntity = SessionEntity(
        id: 'session_1',
        title: 'Test Session',
        description: 'A test session description',
        steps: tSteps,
        currentStep: 1,
        status: EnumSessionStatus.inProgress,
        createdAt: tCreatedAt,
      );
    });

    group('constructor', () {
      test('should create a valid SessionEntity with required parameters', () {
        expect(tSessionEntity.id, 'session_1');
        expect(tSessionEntity.title, 'Test Session');
        expect(tSessionEntity.description, 'A test session description');
        expect(tSessionEntity.steps, tSteps);
        expect(tSessionEntity.currentStep, 1);
        expect(tSessionEntity.status, EnumSessionStatus.inProgress);
        expect(tSessionEntity.createdAt, tCreatedAt);
        expect(tSessionEntity.completedAt, isNull);
      });

      test('should create SessionEntity with completedAt when provided', () {
        final completedAt = DateTime(2024, 1, 2);
        final sessionWithCompletion = SessionEntity(
          id: 'session_1',
          title: 'Test Session',
          description: 'A test session description',
          steps: tSteps,
          currentStep: 2,
          status: EnumSessionStatus.completed,
          createdAt: tCreatedAt,
          completedAt: completedAt,
        );

        expect(sessionWithCompletion.completedAt, completedAt);
      });
    });

    group('copyWith', () {
      test('should return new instance with updated values', () {
        final updatedSession = tSessionEntity.copyWith(
          title: 'Updated Title',
          currentStep: 2,
        );

        expect(updatedSession.title, 'Updated Title');
        expect(updatedSession.currentStep, 2);
        expect(updatedSession.id, tSessionEntity.id);
        expect(updatedSession.description, tSessionEntity.description);
        expect(updatedSession.steps, tSessionEntity.steps);
        expect(updatedSession.status, tSessionEntity.status);
        expect(updatedSession.createdAt, tSessionEntity.createdAt);
      });

      test('should return same instance when no parameters provided', () {
        final copiedSession = tSessionEntity.copyWith();

        expect(copiedSession.id, tSessionEntity.id);
        expect(copiedSession.title, tSessionEntity.title);
        expect(copiedSession.description, tSessionEntity.description);
        expect(copiedSession.steps, tSessionEntity.steps);
        expect(copiedSession.currentStep, tSessionEntity.currentStep);
        expect(copiedSession.status, tSessionEntity.status);
        expect(copiedSession.createdAt, tSessionEntity.createdAt);
        expect(copiedSession.completedAt, tSessionEntity.completedAt);
      });

      test('should update completedAt when provided', () {
        final completedAt = DateTime(2024, 1, 2);
        final updatedSession = tSessionEntity.copyWith(
          completedAt: completedAt,
          status: EnumSessionStatus.completed,
        );

        expect(updatedSession.completedAt, completedAt);
        expect(updatedSession.status, EnumSessionStatus.completed);
      });
    });

    group('progress getter', () {
      test('should return 0.0 when steps list is empty', () {
        final emptySession = tSessionEntity.copyWith(steps: []);
        expect(emptySession.progress, 0.0);
      });

      test('should calculate correct progress based on current step', () {
        // Current step is 1 (second step), so progress should be 2/3 = 0.6666...
        expect(tSessionEntity.progress, closeTo(0.6667, 0.0001));
      });

      test('should return 1.0 when at last step', () {
        final lastStepSession = tSessionEntity.copyWith(currentStep: 2);
        expect(lastStepSession.progress, 1.0);
      });

      test('should return correct progress for first step', () {
        final firstStepSession = tSessionEntity.copyWith(currentStep: 0);
        expect(firstStepSession.progress, closeTo(0.3333, 0.0001));
      });
    });

    group('isCompleted getter', () {
      test('should return true when status is completed', () {
        final completedSession = tSessionEntity.copyWith(
          status: EnumSessionStatus.completed,
        );
        expect(completedSession.isCompleted, true);
      });

      test('should return false when status is not completed', () {
        expect(tSessionEntity.isCompleted, false);

        final notStartedSession = tSessionEntity.copyWith(
          status: EnumSessionStatus.notStarted,
        );
        expect(notStartedSession.isCompleted, false);
      });
    });

    group('canGoNext getter', () {
      test('should return true when not at last step', () {
        expect(tSessionEntity.canGoNext, true);
      });

      test('should return false when at last step', () {
        final lastStepSession = tSessionEntity.copyWith(currentStep: 2);
        expect(lastStepSession.canGoNext, false);
      });

      test('should return false when steps list is empty', () {
        final emptySession = tSessionEntity.copyWith(steps: []);
        expect(emptySession.canGoNext, false);
      });

      test('should return false when current step exceeds steps length', () {
        final invalidSession = tSessionEntity.copyWith(currentStep: 5);
        expect(invalidSession.canGoNext, false);
      });
    });

    group('canGoPrevious getter', () {
      test('should return true when not at first step', () {
        expect(tSessionEntity.canGoPrevious, true);
      });

      test('should return false when at first step', () {
        final firstStepSession = tSessionEntity.copyWith(currentStep: 0);
        expect(firstStepSession.canGoPrevious, false);
      });

      test('should return false when current step is negative', () {
        final invalidSession = tSessionEntity.copyWith(currentStep: -1);
        expect(invalidSession.canGoPrevious, false);
      });
    });

    group('edge cases', () {
      test('should handle single step session correctly', () {
        final singleStepSession = SessionEntity(
          id: 'single_session',
          title: 'Single Step Session',
          description: 'Session with only one step',
          steps: [tSteps.first],
          currentStep: 0,
          status: EnumSessionStatus.inProgress,
          createdAt: tCreatedAt,
        );

        expect(singleStepSession.progress, 1.0);
        expect(singleStepSession.canGoNext, false);
        expect(singleStepSession.canGoPrevious, false);
      });

      test('should handle session with many steps', () {
        final manySteps = List.generate(
          10,
          (index) => SessionStepEntity(
            id: 'step_$index',
            title: 'Step $index',
            contentItems: const [],
            type: SessionStepType.content,
            isCompleted: false,
          ),
        );

        final manyStepsSession = SessionEntity(
          id: 'many_steps_session',
          title: 'Many Steps Session',
          description: 'Session with many steps',
          steps: manySteps,
          currentStep: 5,
          status: EnumSessionStatus.inProgress,
          createdAt: tCreatedAt,
        );

        expect(manyStepsSession.progress, 0.6);
        expect(manyStepsSession.canGoNext, true);
        expect(manyStepsSession.canGoPrevious, true);
      });
    });
  });
}
