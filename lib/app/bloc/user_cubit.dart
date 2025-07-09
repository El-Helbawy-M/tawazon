import 'dart:developer';

import 'package:base/app/models/user.dart';
import 'package:base/config/app_states.dart';
import 'package:base/handlers/shared_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/app_persistence_data_keys.dart';
import '../../config/firestore_tables.dart';

class UserCubit extends Cubit<AppStates> {
  UserCubit._internal() : super(InitialState());
  static UserCubit instance = UserCubit._internal();

  //====================================================
  //==================================================== Variables
  //====================================================
  User _user = User.guest();

  bool get hasCompletedProfile => _user.hasCompletedProfile;

  //====================================================
  //==================================================== Functions
  //====================================================
  Future<bool> _getUserDataRequest(String userId) async {
    try {
      var result = await FirebaseFirestore.instance.collection(FireStoreTables.users).doc(userId).get();
      _user = User.fromJson(result.data()!);
      _cashUserData();
      return true;
    } catch (e) {
      return false;
    }
  }

  _getCashedUserData() {
    Map<String, dynamic>? result = SharedPrefHandler.instance!.get<Map<String, dynamic>?>(key: AppPersistenceDataKeys.userData);
    if (result == null) {
      return;
    } else if (result.isEmpty) {
      return;
    }
    _user = User.fromJson(result);
  }

  _cashUserData() {
    Map<String, dynamic> mappedData = _user.toJson();
    SharedPrefHandler.instance!.save(AppPersistenceDataKeys.userData, value: mappedData);
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
  getUseData(String userId) async {
    emit(LoadingState());
    bool isSuccess = await _getUserDataRequest(userId);

    if (!isSuccess) {
      await _getCashedUserData();
    }
    log("Email: ${_user.email ?? "Test"}");
    emit(LoadedState(_user));
  }

  logout() {
    _clearCashedUserData();
    emit(InitialState());
  }
}
