import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/app_events.dart';
import '../../../../config/app_states.dart';
import '../../../../handlers/audio_player_handler.dart';
import '../../core/entities/session_entity.dart';
import '../../core/usecases/get_session.dart';
import '../../core/usecases/complete_session_step.dart';
import '../../core/usecases/complete_session.dart';

/// BLoC for managing session state and navigation
class SessionBloc extends Bloc<AppEvents, AppStates> {
  final GetSession _getSession;
  final CompleteSessionStep _completeSessionStep;
  final CompleteSession _completeSession;

  // Cache user inputs per step: { stepId: { contentItemId: value } }
  final Map<String, Map<String, dynamic>> _stepInputs = {};
  // Accumulated inputs for entire session (all steps): { contentItemId: value }
  final Map<String, dynamic> _sessionInputs = {};

  SessionBloc({
    GetSession? getSession,
    CompleteSessionStep? completeSessionStep,
    CompleteSession? completeSession,
  })  : _getSession = getSession ?? GetSession(),
        _completeSessionStep = completeSessionStep ?? CompleteSessionStep(),
        _completeSession = completeSession ?? CompleteSession(),
        super(InitialState()) {
    on<_SessionLoadEvent>(_onLoadSession);
    on<_SessionNextStepEvent>(_onNextStep);
    on<_SessionPreviousStepEvent>(_onPreviousStep);
    on<_SessionCompleteEvent>(_onCompleteSession);
  }

  // Public methods to interact with the BLoC
  //===================================================================
  void loadSession(String sessionId, int completedScreenCount) {
    add(_SessionLoadEvent(sessionId, completedScreenCount));
  }

  void nextStep() {
    add(_SessionNextStepEvent());
  }

  void previousStep() {
    add(_SessionPreviousStepEvent());
  }

  void completeSession() {
    add(_SessionCompleteEvent());
  }
  //===================================================================

  void _onLoadSession(_SessionLoadEvent event, Emitter<AppStates> emit) async {
    emit(LoadingState());

    final result =
        await _getSession(event.sessionId, event.completedScreenCount);
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (session) {
        _stepInputs.clear();
        _sessionInputs.clear();
        emit(_SessionLoadedState(session));
      },
    );
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
    final currentStep = session.steps[session.currentStep];
    final inputs = Map<String, dynamic>.from(
      _stepInputs[currentStep.id] ?? const {},
    );
    // Merge into session-level inputs so 'quiz' contains all steps
    _sessionInputs.addAll(inputs);
    if(!session.steps[session.currentStep].isCompleted){
      AudioPlayerHandler().playSound("audio/click_sound.wav");
    }
    final completeResult = _completeSessionStep.call(
      sessionEntity: session,
      stepIndex: session.currentStep,
    );

    // Then move to next step
    completeResult.fold(
      (failure) => emit(ErrorState(failure.message)),
      (updatedSession) {
        // Optionally clear inputs for the completed step
        _stepInputs.remove(currentStep.id);
        emit(_SessionLoadedState(updatedSession));
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

  Future<void> _onCompleteSession(
      _SessionCompleteEvent event, Emitter<AppStates> emit) async {
    if (state is! _SessionLoadedState) return;

    final currentState = state as _SessionLoadedState;
    final session = currentState.session;

    // Before completing the session, make sure the last step inputs are included in 'quiz'
    final currentStep = session.steps[session.currentStep];
    final lastStepInputs = Map<String, dynamic>.from(
      _stepInputs[currentStep.id] ?? const {},
    );
    _sessionInputs.addAll(lastStepInputs);

    emit(LoadingState());
    final result = await _completeSession.call(
      session: session,
      inputs: Map<String, dynamic>.from(_sessionInputs),
    );
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (updated) {
        AudioPlayerHandler().playSound("audio/click_sound.wav");
        emit(SessionCompletedState(updated));
      },
    );
  }

  // Getter to access session data from the current state
  SessionEntity? get currentSession {
    if (state is _SessionLoadedState) {
      return (state as _SessionLoadedState).session;
    }
    return null;
  }

  //================ Input caching ===================

  void setInput(String stepId, String contentItemId, dynamic value) {
    final stepMap = _stepInputs.putIfAbsent(stepId, () => <String, dynamic>{});
    stepMap[contentItemId] = value;
    // Also write-through to session-level aggregate so we maintain the full 'quiz'
    _sessionInputs[contentItemId] = value;
  }

  Map<String, dynamic> inputsForStep(String stepId) {
    return Map<String, dynamic>.from(_stepInputs[stepId] ?? const {});
  }
}

/// Session-specific events (private to this file)
class _SessionLoadEvent extends AppEvents {
  final String sessionId;
  final int completedScreenCount;
  _SessionLoadEvent(this.sessionId, this.completedScreenCount);
}

class _SessionNextStepEvent extends AppEvents {
  _SessionNextStepEvent();
}

class _SessionPreviousStepEvent extends AppEvents {
  _SessionPreviousStepEvent();
}

class _SessionCompleteEvent extends AppEvents {
  _SessionCompleteEvent();
}

/// Session-specific states (private to this file)
class _SessionLoadedState extends AppStates {
  final SessionEntity session;
  _SessionLoadedState(this.session);
}

class SessionCompletedState extends AppStates {
  final SessionEntity session;
  SessionCompletedState(this.session);
}
