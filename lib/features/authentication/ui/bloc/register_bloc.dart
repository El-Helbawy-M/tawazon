import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../config/app_events.dart';
import '../../../../config/app_states.dart';
import '../../../../core/validations.dart';
import '../../core/entities/UserData.dart';
import '../../core/repo/authentication_repo_interface.dart';

class RegisterBloc extends Bloc<AppEvents, AppStates> with Validations {
  RegisterBloc({
    required AuthenticationRepoInterface authRepo,
  })  : _authRepo = authRepo,
        super(InitialState()) {
    on<ClickEvent>(_onRegister);
  }
  //===================================================
  //=================================================== Variables
  //===================================================
  final AuthenticationRepoInterface _authRepo;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String emailError = '';
  String passwordError = '';
  String confirmPasswordError = '';

  //===================================================
  //=================================================== Functions
  //===================================================


  bool _validateRegisterForm() {
    emailError = "";  //isValidEmail(emailController.text);
    passwordError = isValidPassword(passwordController.text);
    confirmPasswordError = isValidConfirmPassword(passwordController.text, confirmPasswordController.text);

    return emailError.isEmpty && passwordError.isEmpty && confirmPasswordError.isEmpty;
  }

  void _createNewAccount(String userId, String userEmail) async {
    UserCreateAccountParameters params = UserCreateAccountParameters(
      email: userEmail,
      id: userId,
    );
    _authRepo.createAccount(user: params);
  }

  Future<void> _onRegister(
      ClickEvent event,
    Emitter<AppStates> emit,
  ) async {
    if (!_validateRegisterForm()) {
      emit(ErrorState('Incorrect Inputs'));
      return;
    }

    emit(LoadingState());
    try {
      final result = await _authRepo.register(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      result.fold(
        (failure) => emit(ErrorState(failure.message)),
        (userCredential) {
          _createNewAccount(userCredential.user!.uid, userCredential.user!.email!);
          emit(LoadedState(userCredential));
        },
      );
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
} 