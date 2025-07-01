import 'package:base/config/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<AppStates>{
  SettingsCubit._internal():super(InitialState());
  static SettingsCubit instance = SettingsCubit._internal();
  //========================================
  //======================================== Variables
  //========================================
  bool isDarkMode = false;
  Locale locale = Locale('en');
  //========================================
  //======================================== Functions
  //========================================
  void toggleDarkMode() async{
    isDarkMode = !isDarkMode;
    // TODO: save the value in shared preferences
    emit(LoadedState(isDarkMode));
  }

  void toggleLocale() async{
    if(locale.languageCode == 'en'){
      locale = Locale('ar');
    }else{
      locale = Locale('en');
    }
    // TODO: save the value in shared preferences
    emit(LoadedState(locale));
  }
}