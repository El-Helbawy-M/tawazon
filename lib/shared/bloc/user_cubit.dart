import 'dart:developer';

import 'package:tawazon/config/app_persistence_data_keys.dart';
import 'package:tawazon/config/firestore_tables.dart';
import 'package:tawazon/shared/models/user.dart';
import 'package:tawazon/config/app_states.dart';
import 'package:tawazon/handlers/shared_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<AppStates> {
  UserCubit._internal() : super(InitialState());
  static UserCubit instance = UserCubit._internal();

  //====================================================
  //==================================================== Variables
  //====================================================
  User user = User.guest();

  bool get hasCompletedProfile => user.hasCompletedProfile;

  //====================================================
  //==================================================== Functions
  //====================================================
  Future<bool> _getUserDataRequest(String userId) async {
    try {
      var result = await FirebaseFirestore.instance
          .collection(FireStoreTables.users)
          .doc(userId)
          .get();

      final data = result.data();
      if (data == null) {
        return false;
      }

      user = User.fromJson(data);
      user.id = result.id;
      _cashUserData();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool _getCashedUserData() {
    Map<String, dynamic>? result = SharedPrefHandler.instance!
        .get<Map<String, dynamic>?>(key: AppPersistenceDataKeys.userData);
    if (result == null || result.isEmpty) {
      return false;
    }
    user = User.fromJson(result);
    return true;
  }

  _cashUserData() {
    Map<String, dynamic> mappedData = user.toJson();
    SharedPrefHandler.instance!
        .save(AppPersistenceDataKeys.userData, value: mappedData);
  }

  _clearCashedUserData() {
    SharedPrefHandler.instance!
      ..remove(AppPersistenceDataKeys.userData)
      ..remove(AppPersistenceDataKeys.isLogin)
      ..remove(AppPersistenceDataKeys.token);
  }

  //====================================================
  //==================================================== Events
  //====================================================
  updateEvent() => emit(LoadedState(user));

  Future<void> getUseData(String userId) async {
    emit(LoadingState());
    bool isSuccess = await _getUserDataRequest(userId);

    if (!isSuccess) {
      final hasCache = _getCashedUserData();
      if (!hasCache) {
        // No remote user and no cached data => logout automatically
        logout();
        return;
      }
    }
    emit(LoadedState(user));
  }

  logout() {
    _clearCashedUserData();
    emit(InitialState());
  }
}
