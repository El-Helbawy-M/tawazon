import 'package:tawazon/config/app_errors.dart';
import 'package:tawazon/features/complete_profile/core/models/survey_form.dart';
import 'package:either_dart/either.dart';

import '../models/complete_profile_submission_params.dart';
import '../models/surveys_submission_params.dart';

abstract class CompleteProfileRepoInterface {
  Future<Either<Failure, List<SurveyForm>>> getSurveyForms();

  Future<Either<Failure, bool>> submitAnswers({
    required SurveysSubmissionParams surveysParams,
    required CompleteProfileSubmissionParams completeProfileParams,
  });

  Future<Either<Failure, bool>> submitSurveysOnly({
    required SurveysSubmissionParams surveysParams,
  });
}
