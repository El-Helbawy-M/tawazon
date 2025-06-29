import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../configurations/app_events.dart';
import '../../../../configurations/app_states.dart';
import '../../../../core/validations.dart';
import '../../core/repo/authentication_repo_interface.dart';

class ForgetPasswordBloc extends Bloc<AppEvents, AppStates> with Validations {
  ForgetPasswordBloc({
    required AuthenticationRepoInterface authRepo,
  })  : _authRepo = authRepo,
        super(InitialState()) {
    on<ClickEvent>(_onResetPassword);
  }
  //===================================================
  //=================================================== Variables
  //===================================================
  final AuthenticationRepoInterface _authRepo;
  final TextEditingController emailController = TextEditingController();

  String emailError = '';

  //===================================================
  //=================================================== Functions
  //===================================================


  bool _validateForm() {
    emailError = isValidEmail(emailController.text);
    return emailError.isEmpty;
  }

  Future<void> _onResetPassword(
    ClickEvent event,
    Emitter<AppStates> emit,
  ) async {
    if (!_validateForm()) {
      emit(ErrorState(emailError));
      return;
    }

    emit(LoadingState());
    try {
      final result = await _authRepo.resetPassword(
        email: emailController.text.trim(),
      );

      result.fold(
        (failure) => emit(ErrorState(failure.message)),
        (success) => emit(LoadedState(success)),
      );
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }
} 