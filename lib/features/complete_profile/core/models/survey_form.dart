import 'package:base/features/complete_profile/core/models/survey_question.dart';

class SurveyForm {
  final String id;
  final String title;
  final String description;
  final String language;
  final int version;
  final List<SurveyQuestion> questions;

  SurveyForm({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.version,
    required this.questions,
  });
}