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
  User user = User.guest();

  bool get hasCompletedProfile => user.hasCompletedProfile;

  //====================================================
  //==================================================== Functions
  //====================================================
  Future<bool> _getUserDataRequest(String userId) async {
    try {
      var result = await FirebaseFirestore.instance.collection(FireStoreTables.users).doc(userId).get();

      user = User.fromJson(result.data()!);
      user.id = result.id;
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
    user = User.fromJson(result);
  }

  _cashUserData() {
    Map<String, dynamic> mappedData = user.toJson();
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
  updateEvent() => emit(LoadedState(user));

  getUseData(String userId) async {
    emit(LoadingState());
    bool isSuccess = await _getUserDataRequest(userId);

    if (!isSuccess) {
      await _getCashedUserData();
    }
    log("Email: ${user.email ?? "Test"}");
    emit(LoadedState(user));
  }

  logout() {
    _clearCashedUserData();
    emit(InitialState());
  }
}
