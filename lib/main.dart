import 'package:base/app/bloc/settings_cubit.dart';
import 'package:base/app/bloc/user_cubit.dart';
import 'package:base/config/app_states.dart';
import 'package:base/handlers/security/AESEncryptor.dart';
import 'package:base/handlers/shared_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'firestore_questions_script.dart';
import 'handlers/translation_handler.dart';
import 'navigation/app_routes.dart';
import 'navigation/route_generator.dart';
import 'utility/style/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefHandler.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
            theme: SettingsCubit.instance.isDarkMode ? ThemeData.dark() : lightTheme,
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
