import 'package:base/handlers/shared_handler.dart';
import 'package:flutter/material.dart';

import 'app/bloc/user_cubit.dart';
import 'config/app_persistence_data_keys.dart';
import 'navigation/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    bool? isLoggedIn =
        SharedPrefHandler.instance!.get(key: AppPersistenceDataKeys.isLogin);
    if (isLoggedIn == true) {
      String userId =
          SharedPrefHandler.instance!.get(key: AppPersistenceDataKeys.token);
      await UserCubit.instance.getUseData(userId);
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: const CircleAvatar(
            radius: 75,
            backgroundImage: AssetImage('assets/images/logo.png'),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
