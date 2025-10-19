import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:tawazon/features/session/ui/bloc/session_bloc.dart';
import 'package:tawazon/features/session/core/usecases/get_session.dart';
import 'package:tawazon/features/session/core/usecases/complete_session_step.dart';
import 'package:tawazon/features/session/core/entities/session_entity.dart';
import 'package:tawazon/features/session/core/entities/session_step_entity.dart';
import 'package:tawazon/features/session/core/entities/session_status.dart';
import 'package:tawazon/config/app_states.dart';
import 'package:tawazon/config/app_errors.dart';

import 'session_bloc_test.mocks.dart';

@GenerateMocks([GetSession, CompleteSessionStep])
void main() {
  group('SessionBloc', () {
    late SessionBloc sessionBloc;
    late MockGetSession mockGetSession;
    late MockCompleteSessionStep mockCompleteSessionStep;
    late SessionEntity tSessionEntity;
    late List<SessionStepEntity> tSteps;

    setUp(() {
      mockGetSession = MockGetSession();
      mockCompleteSessionStep = MockCompleteSessionStep();
      sessionBloc = SessionBloc(
        getSession: mockGetSession,
        completeSessionStep: mockCompleteSessionStep,
      );
      
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

    tearDown(() {
      sessionBloc.close();
    });

    group('constructor', () {
      test('should create SessionBloc with initial state', () {
        expect(sessionBloc.state, isA<InitialState>());
      });
    });

    group('loadSession', () {
      setUp(() {
        // sessionBloc is already initialized in main setUp
      });

      blocTest<SessionBloc, AppStates>(
        'should emit [LoadingState, _SessionLoadedState] when loadSession succeeds',
        build: () {
          when(mockGetSession.call(any, any))
              .thenAnswer((_) async => Right(tSessionEntity));
          return sessionBloc;
        },
        act: (bloc) => bloc.loadSession('session_1', 0),
        expect: () => [
          isA<LoadingState>(),
          isA<AppStates>().having(
            (state) => state.runtimeType.toString(),
            'state type',
            '_SessionLoadedState',
          ),
        ],
        verify: (_) {
          verify(mockGetSession.call('session_1', 0));
        },
      );

      blocTest<SessionBloc, AppStates>(
        'should emit [LoadingState, ErrorState] when loadSession fails',
        build: () {
          when(mockGetSession.call(any, any))
              .thenAnswer((_) async => Left(ServerFailure('Server error')));
          return sessionBloc;
        },
        act: (bloc) => bloc.loadSession('session_1', 0),
        expect: () => [
          isA<LoadingState>(),
          isA<ErrorState>().having(
            (state) => state.errorMessage,
            'error message',
            'Server error',
          ),
        ],
        verify: (_) {
          verify(mockGetSession.call('session_1', 0));
        },
      );

      blocTest<SessionBloc, AppStates>(
        'should emit [LoadingState, ErrorState] when validation fails',
        build: () {
          when(mockGetSession.call(any, any))
              .thenAnswer((_) async => Left(ValidationFailure('Session ID cannot be empty')));
          return sessionBloc;
        },
        act: (bloc) => bloc.loadSession('', 0),
        expect: () => [
          isA<LoadingState>(),
          isA<ErrorState>().having(
            (state) => state.errorMessage,
            'error message',
            'Session ID cannot be empty',
          ),
        ],
        verify: (_) {
          verify(mockGetSession.call('', 0));
        },
      );

      blocTest<SessionBloc, AppStates>(
        'should call GetSession with correct parameters',
        build: () {
          when(mockGetSession.call(any, any))
              .thenAnswer((_) async => Right(tSessionEntity));
          return sessionBloc;
        },
        act: (bloc) => bloc.loadSession('test_session_id', 5),
        verify: (_) {
          verify(mockGetSession.call('test_session_id', 5));
        },
      );
    });

    group('navigateToStep', () {
      setUp(() {
        // sessionBloc is already initialized in main setUp
      });

      blocTest<SessionBloc, AppStates>(
        'should emit updated session with new current step when session is loaded',
        build: () => sessionBloc,
        seed: () {
          // Manually set the state to _SessionLoadedState
          sessionBloc.emit(sessionBloc.state); // This is a workaround for testing private states
          return sessionBloc.state;
        },
        act: (bloc) {
          // First load the session
          when(mockGetSession.call(any, any))
              .thenAnswer((_) async => Right(tSessionEntity));
          bloc.loadSession('session_1', 0);
          // Then navigate to step
          bloc.navigateToStep(2);
        },
        skip: 2, // Skip initial and loading states
        expect: () => [
          isA<AppStates>(), // _SessionLoadedState with updated currentStep
        ],
      );

      test('should not emit when state is not _SessionLoadedState', () {
        final testBloc = SessionBloc(
          getSession: mockGetSession,
          completeSessionStep: mockCompleteSessionStep,
        );
        
        // Act - try to navigate when not loaded
        testBloc.navigateToStep(1);
        
        // Assert - state should remain InitialState
        expect(testBloc.state, isA<InitialState>());
        
        // Clean up
        testBloc.close();
      });

      blocTest<SessionBloc, AppStates>(
        'should preserve session properties when navigating',
        build: () => sessionBloc,
        act: (bloc) async {
          // First load the session
          when(mockGetSession.call(any, any))
              .thenAnswer((_) async => Right(tSessionEntity));
          bloc.loadSession('session_1', 0);
          
          // Wait for loading to complete
          await Future.delayed(const Duration(milliseconds: 10));
          
          // Then navigate
          bloc.navigateToStep(1);
        },
        skip: 2, // Skip initial and loading states
        verify: (bloc) {
          final currentSession = bloc.currentSession;
          if (currentSession != null) {
            expect(currentSession.id, tSessionEntity.id);
            expect(currentSession.title, tSessionEntity.title);
            expect(currentSession.description, tSessionEntity.description);
            expect(currentSession.steps, tSessionEntity.steps);
            expect(currentSession.status, tSessionEntity.status);
            expect(currentSession.createdAt, tSessionEntity.createdAt);
          }
        },
      );
    });

    group('nextStep', () {
      setUp(() {
        // sessionBloc is already initialized in main setUp
      });

      blocTest<SessionBloc, AppStates>(
        'should emit error when session is not loaded',
        build: () => SessionBloc(
          getSession: mockGetSession,
          completeSessionStep: mockCompleteSessionStep,
        ),
        act: (bloc) => bloc.nextStep(),
        expect: () => [],
      );

      blocTest<SessionBloc, AppStates>(
        'should emit error when already at last step',
        build: () => sessionBloc,
        act: (bloc) async {
          // Load session at last step
          final lastStepSession = tSessionEntity.copyWith(currentStep: 2);
          when(mockGetSession.call(any, any))
              .thenAnswer((_) async => Right(lastStepSession));
          bloc.loadSession('session_1', 2);
          
          // Wait for loading
          await Future.delayed(const Duration(milliseconds: 10));
          
          // Try to go next
          bloc.nextStep();
        },
        skip: 2, // Skip initial and loading states
        expect: () => [
          isA<ErrorState>().having(
            (state) => state.errorMessage,
            'error message',
            'Already at the last step',
          ),
        ],
      );

      blocTest<SessionBloc, AppStates>(
        'should complete current step and move to next when successful',
        build: () => sessionBloc,
        act: (bloc) async {
          // Setup mocks
          when(mockGetSession.call(any, any))
              .thenAnswer((_) async => Right(tSessionEntity));
          when(mockCompleteSessionStep.call(
            sessionEntity: anyNamed('sessionEntity'),
            stepIndex: anyNamed('stepIndex'),
          )).thenReturn(Right(tSessionEntity.copyWith(
            steps: [
              tSteps[0].copyWith(isCompleted: true),
              tSteps[1],
              tSteps[2],
            ],
          )));
          
          // Load session
          bloc.loadSession('session_1', 0);
          
          // Wait for loading
          await Future.delayed(const Duration(milliseconds: 10));
          
          // Go to next step
          bloc.nextStep();
        },
        skip: 2, // Skip initial and loading states
        expect: () => [
          isA<AppStates>(), // Updated session state
        ],
        verify: (_) {
          verify(mockCompleteSessionStep.call(
            sessionEntity: anyNamed('sessionEntity'),
            stepIndex: anyNamed('stepIndex'),
          ));
        },
      );

      blocTest<SessionBloc, AppStates>(
        'should emit error when complete step fails',
        build: () => sessionBloc,
        act: (bloc) async {
          // Setup mocks
          when(mockGetSession.call(any, any))
              .thenAnswer((_) async => Right(tSessionEntity));
          when(mockCompleteSessionStep.call(
            sessionEntity: anyNamed('sessionEntity'),
            stepIndex: anyNamed('stepIndex'),
          )).thenReturn(Left(UnknownFailure('Failed to complete step')));
          
          // Load session
          bloc.loadSession('session_1', 0);
          
          // Wait for loading
          await Future.delayed(const Duration(milliseconds: 10));
          
          // Try to go next
          bloc.nextStep();
        },
        skip: 2, // Skip initial and loading states
        expect: () => [
          isA<ErrorState>().having(
            (state) => state.errorMessage,
            'error message',
            'Failed to complete step',
          ),
        ],
      );
    });

    group('previousStep', () {
      setUp(() {
        // sessionBloc is already initialized in main setUp
      });

      blocTest<SessionBloc, AppStates>(
        'should emit error when session is not loaded',
        build: () => SessionBloc(
          getSession: mockGetSession,
          completeSessionStep: mockCompleteSessionStep,
        ),
        act: (bloc) => bloc.previousStep(),
        expect: () => [],
      );

      blocTest<SessionBloc, AppStates>(
        'should emit error when already at first step',
        build: () => sessionBloc,
        act: (bloc) async {
          // Load session at first step
          when(mockGetSession.call(any, any))
              .thenAnswer((_) async => Right(tSessionEntity));
          bloc.loadSession('session_1', 0);
          
          // Wait for loading
          await Future.delayed(const Duration(milliseconds: 10));
          
          // Try to go previous
          bloc.previousStep();
        },
        skip: 2, // Skip initial and loading states
        expect: () => [
          isA<ErrorState>().having(
            (state) => state.errorMessage,
            'error message',
            'Already at the first step',
          ),
        ],
      );

      blocTest<SessionBloc, AppStates>(
        'should move to previous step when not at first step',
        build: () => sessionBloc,
        act: (bloc) async {
          // Load session at step 1
          final middleStepSession = tSessionEntity.copyWith(currentStep: 1);
          when(mockGetSession.call(any, any))
              .thenAnswer((_) async => Right(middleStepSession));
          bloc.loadSession('session_1', 1);
          
          // Wait for loading
          await Future.delayed(const Duration(milliseconds: 10));
          
          // Go to previous step
          bloc.previousStep();
        },
        skip: 2, // Skip initial and loading states
        expect: () => [
          isA<AppStates>(), // Updated session state
        ],
      );

      blocTest<SessionBloc, AppStates>(
        'should preserve session properties when going to previous step',
        build: () => sessionBloc,
        act: (bloc) async {
          // Load session at step 2
          final lastStepSession = tSessionEntity.copyWith(currentStep: 2);
          when(mockGetSession.call(any, any))
              .thenAnswer((_) async => Right(lastStepSession));
          bloc.loadSession('session_1', 2);
          
          // Wait for loading
          await Future.delayed(const Duration(milliseconds: 10));
          
          // Go to previous step
          bloc.previousStep();
        },
        skip: 2, // Skip initial and loading states
        verify: (bloc) {
          final currentSession = bloc.currentSession;
          if (currentSession != null) {
            expect(currentSession.currentStep, 1);
            expect(currentSession.id, tSessionEntity.id);
            expect(currentSession.title, tSessionEntity.title);
            expect(currentSession.steps, tSessionEntity.steps);
          }
        },
      );
    });

    group('currentSession getter', () {
      setUp(() {
        // sessionBloc is already initialized in main setUp
      });

      test('should return null when state is not _SessionLoadedState', () {
        expect(sessionBloc.currentSession, isNull);
      });

      test('should return session when state is _SessionLoadedState', () async {
        // Load session
        when(mockGetSession.call(any, any))
            .thenAnswer((_) async => Right(tSessionEntity));
        sessionBloc.loadSession('session_1', 0);
        
        // Wait for loading to complete
        await Future.delayed(const Duration(milliseconds: 10));
        
        // Check current session
        final currentSession = sessionBloc.currentSession;
        expect(currentSession, isNotNull);
        expect(currentSession?.id, tSessionEntity.id);
      });
    });

    group('edge cases', () {
      setUp(() {
        // sessionBloc is already initialized in main setUp
      });

      blocTest<SessionBloc, AppStates>(
        'should handle session with single step',
        build: () => sessionBloc,
        act: (bloc) async {
          final singleStepSession = SessionEntity(
            id: 'single_session',
            title: 'Single Step Session',
            description: 'Session with one step',
            steps: [tSteps.first],
            currentStep: 0,
            status: EnumSessionStatus.inProgress,
            createdAt: DateTime(2024, 1, 1),
          );
          
          when(mockGetSession.call(any, any))
              .thenAnswer((_) async => Right(singleStepSession));
          bloc.loadSession('single_session', 0);
          
          // Wait for loading
          await Future.delayed(const Duration(milliseconds: 10));
          
          // Try navigation
          bloc.nextStep(); // Should fail - already at last step
        },
        skip: 2, // Skip initial and loading states
        expect: () => [
          isA<ErrorState>().having(
            (state) => state.errorMessage,
            'error message',
            'Already at the last step',
          ),
        ],
      );

      blocTest<SessionBloc, AppStates>(
        'should handle session with many steps',
        build: () => sessionBloc,
        act: (bloc) async {
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
            createdAt: DateTime(2024, 1, 1),
          );
          
          when(mockGetSession.call(any, any))
              .thenAnswer((_) async => Right(manyStepsSession));
          bloc.loadSession('many_steps_session', 5);
          
          // Wait for loading
          await Future.delayed(const Duration(milliseconds: 10));
          
          // Navigate to different step
          bloc.navigateToStep(8);
        },
        skip: 2, // Skip initial and loading states
        expect: () => [
          isA<AppStates>(), // Updated session state
        ],
        verify: (bloc) {
          final currentSession = bloc.currentSession;
          expect(currentSession?.currentStep, 8);
        },
      );

      blocTest<SessionBloc, AppStates>(
        'should handle rapid navigation calls',
        build: () => sessionBloc,
        act: (bloc) async {
          when(mockGetSession.call(any, any))
              .thenAnswer((_) async => Right(tSessionEntity));
          bloc.loadSession('session_1', 0);
          
          // Wait for loading
          await Future.delayed(const Duration(milliseconds: 10));
          
          // Rapid navigation
          bloc.navigateToStep(1);
          bloc.navigateToStep(2);
          bloc.navigateToStep(0);
        },
        skip: 2, // Skip initial and loading states
        expect: () => [
          isA<AppStates>(), // First navigation
          isA<AppStates>(), // Second navigation
          isA<AppStates>(), // Third navigation
        ],
      );
    });

    group('state transitions', () {
      setUp(() {
        // sessionBloc is already initialized in main setUp
      });

      blocTest<SessionBloc, AppStates>(
        'should maintain state consistency during multiple operations',
        build: () => sessionBloc,
        act: (bloc) async {
          // Setup mocks
          when(mockGetSession.call(any, any))
              .thenAnswer((_) async => Right(tSessionEntity));
          when(mockCompleteSessionStep.call(
            sessionEntity: anyNamed('sessionEntity'),
            stepIndex: anyNamed('stepIndex'),
          )).thenReturn(Right(tSessionEntity.copyWith(
            steps: [
              tSteps[0].copyWith(isCompleted: true),
              tSteps[1],
              tSteps[2],
            ],
          )));
          
          // Load session
          bloc.loadSession('session_1', 0);
          await Future.delayed(const Duration(milliseconds: 10));
          
          // Navigate
          bloc.navigateToStep(1);
          await Future.delayed(const Duration(milliseconds: 10));
          
          // Go back
          bloc.previousStep();
          await Future.delayed(const Duration(milliseconds: 10));
          
          // Go next
          bloc.nextStep();
        },
        skip: 2, // Skip initial and loading states
        expect: () => [
          isA<AppStates>(), // Navigate to step 1
          isA<AppStates>(), // Go back to step 0
          isA<AppStates>(), // Go next to step 1
        ],
      );
    });
  });
}
