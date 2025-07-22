import 'package:base/app/bloc/user_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/app_events.dart';
import '../../../../config/app_persistence_data_keys.dart';
import '../../../../config/app_states.dart';
import '../../../../core/validations.dart';
import '../../../../handlers/shared_handler.dart';
import '../../core/repo/authentication_repo_interface.dart';

class LoginBloc extends Bloc<AppEvents, AppStates> with Validations {
  LoginBloc({
    required AuthenticationRepoInterface authRepo,
  })  : _authRepo = authRepo,
        super(InitialState()) {
    on<ClickEvent>(_onLogin);
  }
  //===================================================
  //=================================================== Variables
  //===================================================
  final AuthenticationRepoInterface _authRepo;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String emailError = '';
  String passwordError = '';

  //===================================================
  //=================================================== Functions
  //===================================================
  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }

  bool _validateLoginForm() {
    emailError = "";//isValidEmail(emailController.text);
    passwordError = isValidPassword(passwordController.text);

    return emailError.isEmpty && passwordError.isEmpty;
  }

  Future<UserCredential> _loginRequest() async{
    final result = await _authRepo.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    return result.fold(
          (failure) => throw failure,
          (userCredential) => userCredential,
    );
  }
  Future<void> _cashUser(String userId) async {
    SharedPrefHandler.instance!.save(AppPersistenceDataKeys.token, value: userId);
    SharedPrefHandler.instance!.save(AppPersistenceDataKeys.isLogin, value: true);
  }

  void _onLoginSuccess(UserCredential userCredential) async{
    _cashUser(userCredential.user!.uid);
    UserCubit.instance.getUseData(userCredential.user!.uid);
  }


  //===================================================
  //=================================================== Events
  //===================================================
  Future<void> _onLogin(
    ClickEvent event,
    Emitter<AppStates> emit,
  ) async {
    if (!_validateLoginForm()) {
      emit(ErrorState('$emailError\n$passwordError'));
      return;
    }
    emit(LoadingState());
    try {
      UserCredential userCredential = await _loginRequest();
      _onLoginSuccess(userCredential);
      emit(LoadedState(userCredential));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }


}
