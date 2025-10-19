import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:tawazon/features/session/core/usecases/get_session.dart';
import 'package:tawazon/features/session/core/entities/session_entity.dart';
import 'package:tawazon/features/session/core/entities/session_step_entity.dart';
import 'package:tawazon/features/session/core/entities/session_status.dart';
import 'package:tawazon/features/session/core/entities/content_item_entity.dart';
import 'package:tawazon/config/app_errors.dart';

void main() {
  group('GetSession', () {
    late GetSession getSession;

    setUp(() {
      getSession = const GetSession();
    });

    group('call method', () {
      test('should return ValidationFailure when sessionId is empty', () async {
        // act
        final result = await getSession('', 0);

        // assert
        expect(result, isA<Left<Failure, SessionEntity>>());
        result.fold(
          (failure) {
            expect(failure, isA<ValidationFailure>());
            expect(failure.message, 'Session ID cannot be empty');
          },
          (session) => fail('Expected ValidationFailure but got SessionEntity'),
        );
      });

      test('should return SessionEntity when sessionId is valid', () async {
        // arrange
        const sessionId = 'session_1';
        const completedScreenCount = 0;

        // act
        final result = await getSession(sessionId, completedScreenCount);

        // assert
        expect(result, isA<Right<Failure, SessionEntity>>());
        result.fold(
          (failure) => fail('Expected SessionEntity but got Failure'),
          (session) {
            expect(session.id, sessionId);
            expect(session.title, 'الجلسة التدريبية الأولى');
            expect(session.description, 'جلسة تدريبية تفاعلية تحتوي على 7 خطوات متنوعة للتعلم والتطبيق');
            expect(session.steps.length, 7);
            expect(session.currentStep, completedScreenCount);
            expect(session.status, EnumSessionStatus.notStarted);
          },
        );
      });

      test('should update currentStep based on completedScreenCount', () async {
        // arrange
        const sessionId = 'session_1';
        const completedScreenCount = 3;

        // act
        final result = await getSession(sessionId, completedScreenCount);

        // assert
        result.fold(
          (failure) => fail('Expected SessionEntity but got Failure'),
          (session) {
            expect(session.currentStep, completedScreenCount);
          },
        );
      });

      test('should mark steps as completed based on completedScreenCount', () async {
        // arrange
        const sessionId = 'session_1';
        const completedScreenCount = 3;

        // act
        final result = await getSession(sessionId, completedScreenCount);

        // assert
        result.fold(
          (failure) => fail('Expected SessionEntity but got Failure'),
          (session) {
            // First 3 steps should be completed (indices 0, 1, 2)
            expect(session.steps[0].isCompleted, true);
            expect(session.steps[1].isCompleted, true);
            expect(session.steps[2].isCompleted, true);
            
            // Remaining steps should not be completed
            expect(session.steps[3].isCompleted, false);
            expect(session.steps[4].isCompleted, false);
            expect(session.steps[5].isCompleted, false);
            expect(session.steps[6].isCompleted, false);
          },
        );
      });

      test('should handle completedScreenCount of 0 correctly', () async {
        // arrange
        const sessionId = 'session_1';
        const completedScreenCount = 0;

        // act
        final result = await getSession(sessionId, completedScreenCount);

        // assert
        result.fold(
          (failure) => fail('Expected SessionEntity but got Failure'),
          (session) {
            // All steps should not be completed
            for (final step in session.steps) {
              expect(step.isCompleted, false);
            }
            expect(session.currentStep, 0);
          },
        );
      });

      test('should handle completedScreenCount equal to total steps', () async {
        // arrange
        const sessionId = 'session_1';
        const completedScreenCount = 7;

        // act
        final result = await getSession(sessionId, completedScreenCount);

        // assert
        result.fold(
          (failure) => fail('Expected SessionEntity but got Failure'),
          (session) {
            // All steps should be completed
            for (final step in session.steps) {
              expect(step.isCompleted, true);
            }
            expect(session.currentStep, 7);
          },
        );
      });

      test('should handle completedScreenCount greater than total steps', () async {
        // arrange
        const sessionId = 'session_1';
        const completedScreenCount = 10;

        // act
        final result = await getSession(sessionId, completedScreenCount);

        // assert
        result.fold(
          (failure) => fail('Expected SessionEntity but got Failure'),
          (session) {
            // All steps should be completed
            for (final step in session.steps) {
              expect(step.isCompleted, true);
            }
            expect(session.currentStep, 10);
          },
        );
      });

      test('should handle negative completedScreenCount', () async {
        // arrange
        const sessionId = 'session_1';
        const completedScreenCount = -1;

        // act
        final result = await getSession(sessionId, completedScreenCount);

        // assert
        result.fold(
          (failure) => fail('Expected SessionEntity but got Failure'),
          (session) {
            // All steps should not be completed
            for (final step in session.steps) {
              expect(step.isCompleted, false);
            }
            expect(session.currentStep, -1);
          },
        );
      });
    });

    group('hardcoded session structure', () {
      test('should return session with correct step structure', () async {
        // arrange
        const sessionId = 'test_session';
        const completedScreenCount = 0;

        // act
        final result = await getSession(sessionId, completedScreenCount);

        // assert
        result.fold(
          (failure) => fail('Expected SessionEntity but got Failure'),
          (session) {
            expect(session.steps.length, 7);
            
            // Verify step 1 (introduction)
            final step1 = session.steps[0];
            expect(step1.id, 'step_1');
            expect(step1.title, 'ما هي المشاعر؟ ');
            expect(step1.type, SessionStepType.introduction);
            expect(step1.contentItems.length, 1);
            expect(step1.contentItems.first.type, ContentType.text);
            
            // Verify step 2 (content with image)
            final step2 = session.steps[1];
            expect(step2.id, 'step_2');
            expect(step2.title, 'المشاعر');
            expect(step2.type, SessionStepType.content);
            expect(step2.contentItems.length, 1);
            expect(step2.contentItems.first.type, ContentType.image);
            expect(step2.contentItems.first.content, 'assets/images/session_1_image_1_screen_2.jpg');
            
            // Verify step 7 (conclusion)
            final step7 = session.steps[6];
            expect(step7.id, 'step_7');
            expect(step7.title, 'كيف تشعر اليوم؟');
            expect(step7.type, SessionStepType.conclusion);
            expect(step7.contentItems.length, 2);
          },
        );
      });

      test('should return session with correct content items', () async {
        // arrange
        const sessionId = 'test_session';
        const completedScreenCount = 0;

        // act
        final result = await getSession(sessionId, completedScreenCount);

        // assert
        result.fold(
          (failure) => fail('Expected SessionEntity but got Failure'),
          (session) {
            // Check step 4 which has both text and image content
            final step4 = session.steps[3];
            expect(step4.contentItems.length, 2);
            
            final textContent = step4.contentItems[0];
            expect(textContent.type, ContentType.text);
            expect(textContent.id, 'conclusion_text_1');
            
            final imageContent = step4.contentItems[1];
            expect(imageContent.type, ContentType.image);
            expect(imageContent.id, 'emotion_management_visual_image');
            expect(imageContent.content, 'assets/images/session_1_image_2_screen_4.png');
          },
        );
      });

      test('should return session with correct metadata', () async {
        // arrange
        const sessionId = 'test_session';
        const completedScreenCount = 0;

        // act
        final result = await getSession(sessionId, completedScreenCount);

        // assert
        result.fold(
          (failure) => fail('Expected SessionEntity but got Failure'),
          (session) {
            expect(session.createdAt, isA<DateTime>());
            expect(session.completedAt, isNull);
            expect(session.status, EnumSessionStatus.notStarted);
          },
        );
      });
    });

    group('edge cases', () {
      test('should handle whitespace in sessionId', () async {
        // arrange
        const sessionId = '  session_1  ';
        const completedScreenCount = 0;

        // act
        final result = await getSession(sessionId, completedScreenCount);

        // assert
        expect(result, isA<Right<Failure, SessionEntity>>());
        result.fold(
          (failure) => fail('Expected SessionEntity but got Failure'),
          (session) {
            expect(session.id, sessionId); // Should preserve the whitespace
          },
        );
      });

      test('should handle special characters in sessionId', () async {
        // arrange
        const sessionId = 'session-1_test@domain.com';
        const completedScreenCount = 0;

        // act
        final result = await getSession(sessionId, completedScreenCount);

        // assert
        expect(result, isA<Right<Failure, SessionEntity>>());
        result.fold(
          (failure) => fail('Expected SessionEntity but got Failure'),
          (session) {
            expect(session.id, sessionId);
          },
        );
      });

      test('should handle very large completedScreenCount', () async {
        // arrange
        const sessionId = 'session_1';
        const completedScreenCount = 1000000;

        // act
        final result = await getSession(sessionId, completedScreenCount);

        // assert
        expect(result, isA<Right<Failure, SessionEntity>>());
        result.fold(
          (failure) => fail('Expected SessionEntity but got Failure'),
          (session) {
            expect(session.currentStep, completedScreenCount);
            // All steps should be completed
            for (final step in session.steps) {
              expect(step.isCompleted, true);
            }
          },
        );
      });

      test('should handle very large negative completedScreenCount', () async {
        // arrange
        const sessionId = 'session_1';
        const completedScreenCount = -1000000;

        // act
        final result = await getSession(sessionId, completedScreenCount);

        // assert
        expect(result, isA<Right<Failure, SessionEntity>>());
        result.fold(
          (failure) => fail('Expected SessionEntity but got Failure'),
          (session) {
            expect(session.currentStep, completedScreenCount);
            // All steps should not be completed
            for (final step in session.steps) {
              expect(step.isCompleted, false);
            }
          },
        );
      });
    });

    group('consistency tests', () {
      test('should return consistent results for same input', () async {
        // arrange
        const sessionId = 'session_1';
        const completedScreenCount = 3;

        // act
        final result1 = await getSession(sessionId, completedScreenCount);
        final result2 = await getSession(sessionId, completedScreenCount);

        // assert
        expect(result1, isA<Right<Failure, SessionEntity>>());
        expect(result2, isA<Right<Failure, SessionEntity>>());
        
        result1.fold(
          (failure) => fail('Expected SessionEntity but got Failure'),
          (session1) {
            result2.fold(
              (failure) => fail('Expected SessionEntity but got Failure'),
              (session2) {
                expect(session1.id, session2.id);
                expect(session1.title, session2.title);
                expect(session1.description, session2.description);
                expect(session1.steps.length, session2.steps.length);
                expect(session1.currentStep, session2.currentStep);
                expect(session1.status, session2.status);
              },
            );
          },
        );
      });

      test('should return different currentStep for different completedScreenCount', () async {
        // arrange
        const sessionId = 'session_1';

        // act
        final result1 = await getSession(sessionId, 2);
        final result2 = await getSession(sessionId, 5);

        // assert
        result1.fold(
          (failure) => fail('Expected SessionEntity but got Failure'),
          (session1) {
            result2.fold(
              (failure) => fail('Expected SessionEntity but got Failure'),
              (session2) {
                expect(session1.currentStep, 2);
                expect(session2.currentStep, 5);
                
                // Check completion status
                expect(session1.steps[1].isCompleted, true);
                expect(session1.steps[2].isCompleted, false);
                
                expect(session2.steps[4].isCompleted, true);
                expect(session2.steps[5].isCompleted, false);
              },
            );
          },
        );
      });
    });
  });
}
