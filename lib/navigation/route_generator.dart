import 'package:base/app/bloc/user_cubit.dart';
import 'package:base/features/authentication/data/repo/authentication_repo_impl.dart';
import 'package:base/features/authentication/ui/bloc/forget_password_bloc.dart';
import 'package:base/features/authentication/ui/bloc/register_bloc.dart';
import 'package:base/features/authentication/ui/pages/forget_password_page.dart';
import 'package:base/features/authentication/ui/pages/login_page.dart';
import 'package:base/features/authentication/ui/pages/register_page.dart';
import 'package:base/features/complete_profile/data/repo/complete_profile_repo_imp.dart';
import 'package:base/features/home/ui/pages/home_page.dart';
import 'package:base/features/home/ui/bloc/sessions_progress_cubit.dart';
import 'package:base/handlers/qr_code_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/authentication/ui/bloc/login_bloc.dart';
import '../features/complete_profile/ui/blocs/survey_forms_bloc.dart';
import '../features/complete_profile/ui/pages/complete_profile_page.dart';
import '../features/session/ui/pages/session_page.dart';
import '../splash.dart';
import 'app_routes.dart';

_createRoute(Widget page) {
  return MaterialPageRoute(builder: (context) => page);
}

Route generateRoute(settings) {
  switch (settings.name) {
    case AppRoutes.splash:
      return _createRoute(SplashScreen());
    case AppRoutes.qrScanner:
      return _createRoute(QrCodeHandler());
  //===============================================
  //=============================================== Authentication Routes
  //===============================================
    case AppRoutes.login:
      return _createRoute(
        BlocProvider(
          create: (context) => LoginBloc(authRepo: AuthenticationRepoImpl()),
          child: LoginPage(),
        ),
      );
    case AppRoutes.register:
      return _createRoute(
        BlocProvider(
          create: (context) => RegisterBloc(authRepo: AuthenticationRepoImpl()),
          child: RegisterPage(),
        ),
      );
    case AppRoutes.forgetPassword:
      return _createRoute(
        BlocProvider(
          create: (context) => ForgetPasswordBloc(authRepo: AuthenticationRepoImpl()),
          child: ForgetPasswordPage(),
        ),
      );
  //===============================================
  //=============================================== Home Routes
  //===============================================
    case AppRoutes.home:
      return _createRoute(
        BlocProvider(
          create: (context) => SessionsProgressCubit()..loadUserProgress(UserCubit.instance.user.id??""),
          child: const HomePage(),
        ),
      );
    case AppRoutes.completeProfile:
      return _createRoute(MultiBlocProvider(
        providers: [
          BlocProvider(create: (_)=>SurveyFormsCubit(repo: CompleteProfileRepoImp()))
        ],
        child: CompleteProfilePage(),
      ));
  //===============================================
  //=============================================== Session Routes
  //===============================================
    case AppRoutes.session:
      final sessionId = (settings.arguments as Map)["sessionId"] ;
      final completedScreenCount = (settings.arguments as Map)["completedScreenCount"] ;
      return _createRoute(SessionPage(sessionId: sessionId, completedScreenCount: completedScreenCount));
    default:
      return _createRoute(const SizedBox());
  }
}
