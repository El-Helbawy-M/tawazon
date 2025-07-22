import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../app/models/select_option.dart';

class SurveyQuestion {
  final String id;
  final String text;
  final List<String> options;
  final int order;
  SelectOption? answer;
  bool hasError = false;
  String? error;

  SurveyQuestion({
    required this.id,
    required this.text,
    required this.options,
    required this.order,
  });

  factory SurveyQuestion.fromFirebaseDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SurveyQuestion(
      id: data['id'] ?? doc.id,
      text: data['text'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      order: data['order'] ?? 0,
    );
  }
}
