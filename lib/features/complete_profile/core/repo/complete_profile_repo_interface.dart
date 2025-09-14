import 'package:base/config/app_errors.dart';
import 'package:base/features/complete_profile/core/models/survey_form.dart';
import 'package:either_dart/either.dart';

import '../models/complete_profile_submission_params.dart';
import '../models/surveys_submission_params.dart';

abstract class CompleteProfileRepoInterface {
  Future<Either<Failure, List<SurveyForm>>> getSurveyForms();

  Future<Either<Failure, bool>> submitAnswers({
    required SurveysSubmissionParams surveysParams,
    required CompleteProfileSubmissionParams completeProfileParams,
  });
}
