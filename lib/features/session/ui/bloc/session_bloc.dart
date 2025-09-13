import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/app_events.dart';
import '../../../../config/app_states.dart';
import '../../core/entities/session_entity.dart';
import '../../core/usecases/get_session.dart';
import '../../core/usecases/complete_session_step.dart';

/// BLoC for managing session state and navigation
class SessionBloc extends Bloc<AppEvents, AppStates> {
  final GetSession _getSession;
  final CompleteSessionStep _completeSessionStep;

  SessionBloc()
      : _getSession = GetSession(),
        _completeSessionStep = CompleteSessionStep(),
        super(InitialState()) {
    on<_SessionLoadEvent>(_onLoadSession);
    on<_SessionNavigateEvent>(_onNavigateToStep);
    on<_SessionNextStepEvent>(_onNextStep);
    on<_SessionPreviousStepEvent>(_onPreviousStep);
  }

  // Public methods to interact with the BLoC
  //===================================================================
  void loadSession(String sessionId, int completedScreenCount) {
    add(_SessionLoadEvent(sessionId, completedScreenCount));
  }

  void navigateToStep(int stepIndex) {
    add(_SessionNavigateEvent(stepIndex));
  }

  void nextStep() {
    add(_SessionNextStepEvent());
  }

  void previousStep() {
    add(_SessionPreviousStepEvent());
  }
  //===================================================================

  void _onLoadSession(_SessionLoadEvent event, Emitter<AppStates> emit) async {
    emit(LoadingState());

    final result =
        await _getSession(event.sessionId, event.completedScreenCount);
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (session) => emit(_SessionLoadedState(session)),
    );
  }

  void _onNavigateToStep(
      _SessionNavigateEvent event, Emitter<AppStates> emit) async {
    if (state is! _SessionLoadedState) return;

    final currentState = state as _SessionLoadedState;
    final session = currentState.session;

    // Simply update the current step without using repository
    final updatedSession = SessionEntity(
      id: session.id,
      title: session.title,
      description: session.description,
      steps: session.steps,
      currentStep: event.stepIndex,
      status: session.status,
      createdAt: session.createdAt,
    );

    emit(_SessionLoadedState(updatedSession));
  }

  void _onNextStep(_SessionNextStepEvent event, Emitter<AppStates> emit) async {
    if (state is! _SessionLoadedState) return;

    final currentState = state as _SessionLoadedState;
    final session = currentState.session;

    if (!session.canGoNext) {
      emit(ErrorState("Already at the last step"));
      return;
    }

    // First complete the current step using local session state
    final completeResult = _completeSessionStep.call(
      sessionEntity: session,
      stepIndex: session.currentStep,
    );
    

    // Then move to next step
    completeResult.fold(
      (failure) => emit(ErrorState(failure.message)),
      (updatedSession) {
        final nextStep = updatedSession.currentStep + 1;
        final finalSession = SessionEntity(
          id: updatedSession.id,
          title: updatedSession.title,
          description: updatedSession.description,
          steps: updatedSession.steps,
          currentStep: nextStep,
          status: updatedSession.status,
          createdAt: updatedSession.createdAt,
        );
        emit(_SessionLoadedState(finalSession));
      },
    );
  }

  void _onPreviousStep(
      _SessionPreviousStepEvent event, Emitter<AppStates> emit) async {
    if (state is! _SessionLoadedState) return;

    final currentState = state as _SessionLoadedState;
    final session = currentState.session;

    if (!session.canGoPrevious) {
      emit(ErrorState("Already at the first step"));
      return;
    }

    final previousStep = session.currentStep - 1;
    final updatedSession = SessionEntity(
      id: session.id,
      title: session.title,
      description: session.description,
      steps: session.steps,
      currentStep: previousStep,
      status: session.status,
      createdAt: session.createdAt,
    );
    emit(_SessionLoadedState(updatedSession));
  }

  // Getter to access session data from the current state
  SessionEntity? get currentSession {
    if (state is _SessionLoadedState) {
      return (state as _SessionLoadedState).session;
    }
    return null;
  }
}

/// Session-specific events (private to this file)
class _SessionLoadEvent extends AppEvents {
  final String sessionId;
  final int completedScreenCount;
  _SessionLoadEvent(this.sessionId, this.completedScreenCount);
}

class _SessionNavigateEvent extends AppEvents {
  final int stepIndex;
  _SessionNavigateEvent(this.stepIndex);
}

class _SessionNextStepEvent extends AppEvents {
  _SessionNextStepEvent();
}

class _SessionPreviousStepEvent extends AppEvents {
  _SessionPreviousStepEvent();
}

/// Session-specific states (private to this file)
class _SessionLoadedState extends AppStates {
  final SessionEntity session;
  _SessionLoadedState(this.session);
}
