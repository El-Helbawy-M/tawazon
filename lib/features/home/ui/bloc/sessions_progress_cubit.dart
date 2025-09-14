import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/entities/sessions_overall_progress_entity.dart';
import '../../core/usecases/get_sessions_overall_progress.dart';
import '../../../../config/app_states.dart';

/// Cubit for managing sessions overall progress state
/// 
/// This cubit handles the state management for user sessions progress data.
/// It uses the GetSessionsOverallProgress use case to fetch data from Firestore.
/// 
/// Example usage:
/// ```dart
/// final cubit = SessionsProgressCubit();
/// cubit.loadUserProgress('user123');
/// ```
class SessionsProgressCubit extends Cubit<AppStates> {
  final GetSessionsOverallProgress _getSessionsOverallProgress;

  /// Creates an instance of [SessionsProgressCubit].
  /// 
  /// [getSessionsOverallProgress] The use case for fetching sessions progress data.
  /// If not provided, a default instance will be created.
  SessionsProgressCubit({
    GetSessionsOverallProgress? getSessionsOverallProgress,
  })  : _getSessionsOverallProgress = getSessionsOverallProgress ?? GetSessionsOverallProgress(),
        super(InitialState());

  /// Loads user progress data for the given user ID
  /// 
  /// [userId] The unique identifier for the user
  /// 
  /// Emits [LoadingState] while fetching data,
  /// then either [LoadedState] on success or [ErrorState] on failure.
  Future<void> loadUserProgress(String userId) async {
    if (userId.isEmpty) {
      emit(ErrorState('User ID cannot be empty'));
      return;
    }

    emit(LoadingState(type: 'sessions_progress'));

    final result = await _getSessionsOverallProgress.call(userId: userId);

    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (progressData) => emit(LoadedState(progressData)),
    );
  }

  /// Refreshes the user progress data
  /// 
  /// [userId] The unique identifier for the user
  /// 
  /// This method can be called to refresh the data without showing loading state
  /// if data is already loaded, or with loading state if no data is currently loaded.
  Future<void> refreshUserProgress(String userId) async {
    if (userId.isEmpty) {
      emit(ErrorState('User ID cannot be empty'));
      return;
    }

    // Show loading only if we don't have data already
    if (state is! LoadedState) {
      emit(LoadingState(type: 'sessions_progress'));
    }

    final result = await _getSessionsOverallProgress.call(userId: userId);

    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (progressData) => emit(LoadedState(progressData)),
    );
  }

  /// Gets the current progress data if available
  /// 
  /// Returns the [SessionsOverallProgressEntity] if the current state is [LoadedState],
  /// otherwise returns null.
  SessionsOverallProgressEntity? get currentProgressData {
    final currentState = state;
    if (currentState is LoadedState) {
      return currentState.data as SessionsOverallProgressEntity?;
    }
    return null;
  }

  /// Checks if the cubit is currently loading data
  bool get isLoading => state is LoadingState;

  /// Checks if the cubit has loaded data successfully
  bool get hasData => state is LoadedState;

  /// Checks if the cubit is in an error state
  bool get hasError => state is ErrorState;

  /// Gets the current error message if in error state
  String? get errorMessage {
    final currentState = state;
    if (currentState is ErrorState) {
      return currentState.errorMessage;
    }
    return null;
  }
}
