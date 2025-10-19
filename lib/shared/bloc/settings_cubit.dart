import 'package:tawazon/config/app_persistence_data_keys.dart';
import 'package:tawazon/config/app_states.dart';
import 'package:tawazon/handlers/shared_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<AppStates> {
  static SettingsCubit instance = SettingsCubit._internal();
  SettingsCubit._internal() : super(InitialState()) {
    _loadLocaleFromSharedPref();
  }
  //========================================
  //======================================== Variables
  //========================================
  bool isDarkMode = false;
  Locale locale = Locale('ar');
  //========================================
  //======================================== Functions
  //========================================
  void _saveLocaleInSharedPref(String localeCode) => SharedPrefHandler.instance!
      .save(AppPersistenceDataKeys.locale, value: localeCode);

  void _loadLocaleFromSharedPref() async {
    var localeCode = SharedPrefHandler.instance!
        .get<String>(key: AppPersistenceDataKeys.locale);
    locale = Locale(localeCode ?? 'ar');
    emit(LoadedState(locale));
  }

  void _saveDarkModeInSharedPref(bool isDarkMode) async {
    // TODO: save the value in shared preferences
  }

  void toggleDarkMode() async {
    isDarkMode = !isDarkMode;
    // TODO: save the value in shared preferences
    emit(LoadedState(isDarkMode));
  }

  void toggleLocale() async {
    if (locale.languageCode == 'en') {
      locale = Locale('ar');
    } else {
      locale = Locale('en');
    }
    _saveLocaleInSharedPref(locale.languageCode);
    emit(LoadedState(locale));
  }

  void setLocale(String languageCode) {
    if (languageCode != locale.languageCode) {
      locale = Locale(languageCode);
      _saveLocaleInSharedPref(languageCode);
      emit(LoadedState(locale));
    }
  }
}
