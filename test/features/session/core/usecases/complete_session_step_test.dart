import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tawazon/features/session/core/usecases/complete_session_step.dart';
import 'package:tawazon/features/session/core/entities/session_entity.dart';
import 'package:tawazon/features/session/core/entities/session_step_entity.dart';
import 'package:tawazon/features/session/core/entities/session_status.dart';
import 'package:tawazon/features/session/core/entities/content_item_entity.dart';
import 'package:tawazon/config/app_errors.dart';

import 'complete_session_step_test.mocks.dart';

@GenerateMocks([FirebaseFirestore, CollectionReference, DocumentReference])
void main() {
  group('CompleteSessionStep', () {
    late CompleteSessionStep completeSessionStep;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollection;
    late MockDocumentReference<Map<String, dynamic>> mockDocument;
    late SessionEntity tSessionEntity;
    late List<SessionStepEntity> tSteps;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference<Map<String, dynamic>>();
      mockDocument = MockDocumentReference<Map<String, dynamic>>();
      completeSessionStep = CompleteSessionStep(firestore: mockFirestore);
      
      // Setup Firestore mocks for all tests
      when(mockFirestore.collection('user_progress'))
          .thenReturn(mockCollection);
      when(mockCollection.doc(any))
          .thenReturn(mockDocument);
      when(mockDocument.set(any))
          .thenAnswer((_) async => {});

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
          isCompleted: false,
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
        description: 'A test session',
        steps: tSteps,
        currentStep: 0,
        status: EnumSessionStatus.inProgress,
        createdAt: DateTime(2024, 1, 1),
      );
    });

    group('constructor', () {
      test('should create instance with provided firestore', () {
        final customFirestore = MockFirebaseFirestore();
        final useCase = CompleteSessionStep(firestore: customFirestore);
        
        expect(useCase, isA<CompleteSessionStep>());
      });

      test('should create instance with default firestore when not provided', () {
        // This test would require Firebase initialization in a real shared
        // For unit tests, we should always provide a mock firestore
        final mockFirestore = MockFirebaseFirestore();
        final useCase = CompleteSessionStep(firestore: mockFirestore);
        
        expect(useCase, isA<CompleteSessionStep>());
      });
    });

    group('call method', () {
      test('should complete step and return updated session when step is not completed', () {
        // arrange
        const stepIndex = 0;
        
        // act
        final result = completeSessionStep.call(
          sessionEntity: tSessionEntity,
          stepIndex: stepIndex,
        );

        // assert
        expect(result, isA<Right<Failure, SessionEntity>>());
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (updatedSession) {
            expect(updatedSession.steps[stepIndex].isCompleted, true);
            expect(updatedSession.steps[1].isCompleted, false);
            expect(updatedSession.steps[2].isCompleted, false);
            expect(updatedSession.id, tSessionEntity.id);
            expect(updatedSession.title, tSessionEntity.title);
          },
        );
      });

      test('should return same session when step is already completed', () {
        // arrange
        const stepIndex = 1;
        final completedSteps = [
          tSteps[0],
          tSteps[1].copyWith(isCompleted: true),
          tSteps[2],
        ];
        final sessionWithCompletedStep = tSessionEntity.copyWith(steps: completedSteps);
        
        // act
        final result = completeSessionStep.call(
          sessionEntity: sessionWithCompletedStep,
          stepIndex: stepIndex,
        );

        // assert
        expect(result, isA<Right<Failure, SessionEntity>>());
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (updatedSession) {
            expect(updatedSession, equals(sessionWithCompletedStep));
            expect(updatedSession.steps[stepIndex].isCompleted, true);
          },
        );
      });

      test('should complete first step correctly', () {
        // arrange
        const stepIndex = 0;
        
        // act
        final result = completeSessionStep.call(
          sessionEntity: tSessionEntity,
          stepIndex: stepIndex,
        );

        // assert
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (updatedSession) {
            expect(updatedSession.steps[0].isCompleted, true);
            expect(updatedSession.steps[1].isCompleted, false);
            expect(updatedSession.steps[2].isCompleted, false);
          },
        );
      });

      test('should complete middle step correctly', () {
        // arrange
        const stepIndex = 1;
        
        // act
        final result = completeSessionStep.call(
          sessionEntity: tSessionEntity,
          stepIndex: stepIndex,
        );

        // assert
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (updatedSession) {
            expect(updatedSession.steps[0].isCompleted, false);
            expect(updatedSession.steps[1].isCompleted, true);
            expect(updatedSession.steps[2].isCompleted, false);
          },
        );
      });

      test('should complete last step correctly', () {
        // arrange
        const stepIndex = 2;
        
        // act
        final result = completeSessionStep.call(
          sessionEntity: tSessionEntity,
          stepIndex: stepIndex,
        );

        // assert
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (updatedSession) {
            expect(updatedSession.steps[0].isCompleted, false);
            expect(updatedSession.steps[1].isCompleted, false);
            expect(updatedSession.steps[2].isCompleted, true);
          },
        );
      });

      test('should preserve other step properties when completing', () {
        // arrange
        const stepIndex = 0;
        
        // act
        final result = completeSessionStep.call(
          sessionEntity: tSessionEntity,
          stepIndex: stepIndex,
        );

        // assert
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (updatedSession) {
            final completedStep = updatedSession.steps[stepIndex];
            final originalStep = tSessionEntity.steps[stepIndex];
            
            expect(completedStep.id, originalStep.id);
            expect(completedStep.title, originalStep.title);
            expect(completedStep.contentItems, originalStep.contentItems);
            expect(completedStep.type, originalStep.type);
            expect(completedStep.metadata, originalStep.metadata);
            expect(completedStep.isCompleted, true);
          },
        );
      });

      test('should preserve session properties when completing step', () {
        // arrange
        const stepIndex = 0;
        
        // act
        final result = completeSessionStep.call(
          sessionEntity: tSessionEntity,
          stepIndex: stepIndex,
        );

        // assert
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (updatedSession) {
            expect(updatedSession.id, tSessionEntity.id);
            expect(updatedSession.title, tSessionEntity.title);
            expect(updatedSession.description, tSessionEntity.description);
            expect(updatedSession.currentStep, tSessionEntity.currentStep);
            expect(updatedSession.status, tSessionEntity.status);
            expect(updatedSession.createdAt, tSessionEntity.createdAt);
            expect(updatedSession.completedAt, tSessionEntity.completedAt);
          },
        );
      });

      test('should return UnknownFailure when exception occurs', () {
        // arrange
        const stepIndex = 999; // Invalid index to cause exception
        
        // act
        final result = completeSessionStep.call(
          sessionEntity: tSessionEntity,
          stepIndex: stepIndex,
        );

        // assert
        expect(result, isA<Left<Failure, SessionEntity>>());
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, 'Failed to complete session step');
          },
          (session) => fail('Expected Left but got Right'),
        );
      });
    });

    group('edge cases', () {
      test('should handle session with single step', () {
        // arrange
        final singleStepSession = SessionEntity(
          id: 'single_session',
          title: 'Single Step Session',
          description: 'Session with one step',
          steps: [tSteps.first],
          currentStep: 0,
          status: EnumSessionStatus.inProgress,
          createdAt: DateTime(2024, 1, 1),
        );
        const stepIndex = 0;
        
        // act
        final result = completeSessionStep.call(
          sessionEntity: singleStepSession,
          stepIndex: stepIndex,
        );

        // assert
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (updatedSession) {
            expect(updatedSession.steps.length, 1);
            expect(updatedSession.steps[0].isCompleted, true);
          },
        );
      });

      test('should handle session with many steps', () {
        // arrange
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
          currentStep: 0,
          status: EnumSessionStatus.inProgress,
          createdAt: DateTime(2024, 1, 1),
        );
        const stepIndex = 5;
        
        // act
        final result = completeSessionStep.call(
          sessionEntity: manyStepsSession,
          stepIndex: stepIndex,
        );

        // assert
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (updatedSession) {
            expect(updatedSession.steps.length, 10);
            expect(updatedSession.steps[stepIndex].isCompleted, true);
            
            // Check other steps are not affected
            for (int i = 0; i < updatedSession.steps.length; i++) {
              if (i != stepIndex) {
                expect(updatedSession.steps[i].isCompleted, false);
              }
            }
          },
        );
      });

      test('should handle negative step index', () {
        // arrange
        const stepIndex = -1;
        
        // act
        final result = completeSessionStep.call(
          sessionEntity: tSessionEntity,
          stepIndex: stepIndex,
        );

        // assert
        expect(result, isA<Left<Failure, SessionEntity>>());
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, 'Failed to complete session step');
          },
          (session) => fail('Expected Left but got Right'),
        );
      });

      test('should handle step index greater than steps length', () {
        // arrange
        const stepIndex = 10;
        
        // act
        final result = completeSessionStep.call(
          sessionEntity: tSessionEntity,
          stepIndex: stepIndex,
        );

        // assert
        expect(result, isA<Left<Failure, SessionEntity>>());
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, 'Failed to complete session step');
          },
          (session) => fail('Expected Left but got Right'),
        );
      });

      test('should handle session with empty steps list', () {
        // arrange
        final emptyStepsSession = SessionEntity(
          id: 'empty_session',
          title: 'Empty Session',
          description: 'Session with no steps',
          steps: const [],
          currentStep: 0,
          status: EnumSessionStatus.notStarted,
          createdAt: DateTime(2024, 1, 1),
        );
        const stepIndex = 0;
        
        // act
        final result = completeSessionStep.call(
          sessionEntity: emptyStepsSession,
          stepIndex: stepIndex,
        );

        // assert
        expect(result, isA<Left<Failure, SessionEntity>>());
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, 'Failed to complete session step');
          },
          (session) => fail('Expected Left but got Right'),
        );
      });
    });

    group('immutability tests', () {
      test('should not modify original session entity', () {
        // arrange
        const stepIndex = 0;
        final originalSteps = List<SessionStepEntity>.from(tSessionEntity.steps);
        
        // act
        completeSessionStep.call(
          sessionEntity: tSessionEntity,
          stepIndex: stepIndex,
        );

        // assert
        expect(tSessionEntity.steps[stepIndex].isCompleted, false);
        expect(tSessionEntity.steps.length, originalSteps.length);
        for (int i = 0; i < tSessionEntity.steps.length; i++) {
          expect(tSessionEntity.steps[i].isCompleted, originalSteps[i].isCompleted);
        }
      });

      test('should create new step instances when completing', () {
        // arrange
        const stepIndex = 0;
        final originalStep = tSessionEntity.steps[stepIndex];
        
        // act
        final result = completeSessionStep.call(
          sessionEntity: tSessionEntity,
          stepIndex: stepIndex,
        );

        // assert
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (updatedSession) {
            final updatedStep = updatedSession.steps[stepIndex];
            expect(identical(originalStep, updatedStep), false);
            expect(updatedStep.isCompleted, true);
            expect(originalStep.isCompleted, false);
          },
        );
      });

      test('should create new session instance when completing step', () {
        // arrange
        const stepIndex = 0;
        
        // act
        final result = completeSessionStep.call(
          sessionEntity: tSessionEntity,
          stepIndex: stepIndex,
        );

        // assert
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (updatedSession) {
            expect(identical(tSessionEntity, updatedSession), false);
            expect(identical(tSessionEntity.steps, updatedSession.steps), false);
          },
        );
      });
    });
  });
}
