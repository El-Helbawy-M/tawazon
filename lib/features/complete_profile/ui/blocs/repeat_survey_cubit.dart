import 'package:tawazon/shared/bloc/user_cubit.dart';
import 'package:tawazon/config/app_states.dart';
import 'package:tawazon/features/complete_profile/core/models/surveys_submission_params.dart';
import 'package:tawazon/features/complete_profile/core/repo/complete_profile_repo_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/survey_form.dart';
import '../../../../shared/models/select_option.dart';

class RepeatSurveyCubit extends Cubit<AppStates> {
  RepeatSurveyCubit({required this.repo}) : super(LoadingState()) {
    getSurveyFormsEvent();
  }

  //========================================================
  //======================================================== Variables
  //========================================================
  final CompleteProfileRepoInterface repo;
  List<SurveyForm> forms = [];

  //========================================================
  //======================================================== Functions
  //========================================================
  Future<List<SurveyForm>> _requestForms() async {
    final result = await repo.getSurveyForms();
    return result.fold(
      (failure) => throw failure,
      (data) => data,
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

  void updateQuestion(int formIndex, int questionIndex, SelectOption answer) {
    forms[formIndex].questions[questionIndex].answer = answer;
    updateEvent();
  }

  //========================================================
  //======================================================== Events
  //========================================================
  void getSurveyFormsEvent() async {
    emit(LoadingState());
    try {
      forms = await _requestForms();
      emit(LoadedState(forms));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  void submitEvent() async {
    emit(LoadingState(type: 'submission'));
    try {
      final params = SurveysSubmissionParams(
        userId: UserCubit.instance.user.id ?? '',
        answers: forms.asMap().map((_, form) => MapEntry(form.id, form.questions)),
      );
      final result = await repo.submitSurveysOnly(surveysParams: params);
      result.fold(
        (failure) => throw failure,
        (_) => emit(LoadedState(forms, args: 'submission')),
      );
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  void updateEvent() => emit(LoadedState(forms));
}
