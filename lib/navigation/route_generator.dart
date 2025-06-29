import 'package:base/features/authentication/data/repo/authentication_repo_impl.dart';
import 'package:base/features/authentication/ui/bloc/forget_password_bloc.dart';
import 'package:base/features/authentication/ui/bloc/register_bloc.dart';
import 'package:base/features/authentication/ui/pages/forget_password_page.dart';
import 'package:base/features/authentication/ui/pages/login_page.dart';
import 'package:base/features/authentication/ui/pages/register_page.dart';
import 'package:base/features/home/ui/pages/home_page.dart';
import 'package:base/handlers/qr_code_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/authentication/ui/bloc/login_bloc.dart';
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
      return _createRoute(const HomePage());
    default:
      return _createRoute(const SizedBox());
  }
}
