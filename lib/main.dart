import 'package:firebase_core/firebase_core.dart';
import 'package:tawazon/shared/bloc/settings_cubit.dart';
import 'package:tawazon/shared/bloc/user_cubit.dart';
import 'package:tawazon/config/app_states.dart';
import 'package:tawazon/handlers/security/AESEncryptor.dart';
import 'package:tawazon/handlers/shared_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'handlers/translation_handler.dart';
import 'navigation/app_routes.dart';
import 'navigation/route_generator.dart';
import 'utility/style/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefHandler.init();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      Firebase.app();
    }
  } on FirebaseException catch (e) {
    // Ignore duplicate app error and use the existing default app
    if (e.code == 'duplicate-app' || e.message?.contains('duplicate-app') == true) {
      Firebase.app();
    } else {
      rethrow;
    }
  }
  FirebaseFirestore.setLoggingEnabled(true);
  AESEncryptor.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SettingsCubit.instance),
        BlocProvider(create: (context) => UserCubit.instance),
      ],
      child: BlocBuilder<SettingsCubit, AppStates>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: SettingsCubit.instance.isDarkMode ? darkTheme : lightTheme,
            locale: SettingsCubit.instance.locale,
            onGenerateRoute: generateRoute,
            initialRoute: AppRoutes.splash,
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],
            localizationsDelegates: [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
