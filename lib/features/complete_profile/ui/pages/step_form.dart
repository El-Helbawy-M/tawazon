import 'package:base/features/complete_profile/core/models/survey_question.dart';
import 'package:flutter/material.dart';

import '../../../../app/models/select_option.dart';
import '../../../../app/widgets/fields/choices_input_field.dart';

class StepForm extends StatelessWidget {
  const StepForm({super.key, required this.questions});

  final List<SurveyQuestion> questions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: questions.map((question) {
        return ChoicesInputField(
          label: question.text,
          isVerticalLayout: true,
          withError: question.hasError,
          errorText: question.error,
          selectedOption: question.answer,
          options: question.options.map(
            (option) {
              return SelectOption(option, option);
            },
          ).toList(),
          onChange: (option) {
            question.answer = option;
          },
        );
      }).toList(),
    );
  }
}
