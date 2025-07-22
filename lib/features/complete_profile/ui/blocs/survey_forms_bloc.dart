import 'dart:developer';

import 'package:base/app/bloc/user_cubit.dart';
import 'package:base/config/app_states.dart';
import 'package:base/features/complete_profile/core/models/complete_profile_submission_params.dart';
import 'package:base/features/complete_profile/core/models/surveys_submission_params.dart';
import 'package:base/features/complete_profile/core/repo/complete_profile_repo_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/models/select_option.dart';
import '../../../../core/validations.dart';
import '../../core/models/survey_form.dart';

class SurveyFormsCubit extends Cubit<AppStates> with Validations {
  SurveyFormsCubit({required this.repo}) : super(LoadingState()) {
    getSurveyFormsEvent();
  }

  //========================================================
  //======================================================== Variables
  //========================================================
  List<SurveyForm> forms = [];
  CompleteProfileRepoInterface repo;
  SelectOption? selectedFaculity;
  SelectOption? gender = SelectOption("ذكر", "ذكر");
  SelectOption? academicTeam;
  SelectOption? placeOfResidence = SelectOption("مدينة", "مدينة");
  final TextEditingController ageController = TextEditingController();
  final TextEditingController academicGradeController = TextEditingController();
  bool hasVisitedDoctorOnce = false;
  String ageError = '';
  String academicGradeError = '';
  String faculityError = '';
  String academicTeamError = '';
  String placeOfResidenceError = '';

  //========================================================
  //======================================================== Functions
  //========================================================
  Future<List<SurveyForm>> _requestForms() async {
    var result = await repo.getSurveyForms();
    return result.fold(
      (result) {
        throw result;
      },
      (result) {
        return result;
      },
    );
  }

  bool validateForm({required int formIndex}) {
    bool isValid = true;
    for (var question in forms[formIndex].questions) {
      if (question.answer == null) {
        isValid = false;
        question.hasError = true;
        question.error = 'هذا الحقل مطلوب';
      } else {
        question.hasError = false;
        question.error = '';
      }
    }
    if (!isValid) updateEvent();
    return isValid;
  }

  bool validatePersonalData() {
    bool isValid = true;
    ageError = isValidAge(ageController.text);
    academicGradeError = academicGradeController.text.isEmpty ? 'هذا الحقل مطلوب' : '';
    faculityError = selectedFaculity == null ? 'هذا الحقل مطلوب' : '';
    academicTeamError = academicTeam == null ? 'هذا الحقل مطلوب' : '';
    isValid = ageError.isEmpty && academicGradeError.isEmpty && academicTeamError.isEmpty && faculityError.isEmpty && gender != null && placeOfResidence != null;
    if (!isValid) updateEvent();
    return isValid;
  }

  void updateQuestion(int formIndex, int questionIndex, SelectOption answer) {
    forms[formIndex].questions[questionIndex].answer = answer;
    updateEvent();
  }

  //========================================================
  //======================================================== Events
  //========================================================
  void submitEvent() async {
    emit(LoadingState(type: "submission"));
    try {
      SurveysSubmissionParams surveysSubmissionParams = SurveysSubmissionParams(
        userId: UserCubit.instance.user.id ?? "",
        answers: forms.asMap().map((key, value) => MapEntry(value.id, value.questions)),
      );
      CompleteProfileSubmissionParams completeProfileParams = CompleteProfileSubmissionParams(
        userId: UserCubit.instance.user.id ?? "",
        selectedFaculity: selectedFaculity!.value,
        gender: gender!.value,
        academicTeam: academicTeam!.value,
        placeOfResidence: placeOfResidence!.value,
        age: ageController.text,
        academicGrade: academicGradeController.text,
        hasVisitedDoctorOnce: hasVisitedDoctorOnce,
      );
      var result = await repo.submitAnswers(surveysParams: surveysSubmissionParams, completeProfileParams: completeProfileParams);
      result.fold(
        (result) {
          throw result;
        },
        (result) {
          UserCubit.instance.user.hasCompletedProfile = true;
          UserCubit.instance.updateEvent();

          emit(LoadedState(forms,args: "submission"));
        },
      );
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  void getSurveyFormsEvent() async {
    emit(LoadingState());
    try {
      forms = await _requestForms();
      emit(LoadedState(forms));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  void updateEvent() => emit(LoadedState(forms));
}
