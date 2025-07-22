import 'package:base/features/complete_profile/core/models/survey_question.dart';


class SurveysSubmissionParams {
  final String userId;
  final Map<String, List<SurveyQuestion>> answers;

  SurveysSubmissionParams({
    required this.userId,
    required this.answers,
  });
}
