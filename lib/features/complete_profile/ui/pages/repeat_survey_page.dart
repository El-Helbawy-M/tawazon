import 'package:tawazon/shared/widgets/cancel_keyboard_gesture.dart';
import 'package:tawazon/config/app_states.dart';
import 'package:tawazon/config/app_translation_keys.dart';
import 'package:tawazon/features/complete_profile/ui/blocs/repeat_survey_cubit.dart';
import 'package:tawazon/features/complete_profile/core/models/survey_form.dart';
import 'package:tawazon/handlers/translation_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'step_form.dart';

class RepeatSurveyPage extends StatefulWidget {
  const RepeatSurveyPage({super.key});

  @override
  State<RepeatSurveyPage> createState() => _RepeatSurveyPageState();
}

class _RepeatSurveyPageState extends State<RepeatSurveyPage> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return CancelKeyboardGesture(
      child: Scaffold(
        appBar: AppBar(
          title: Text(translator.word(TranslationKeys.completeProfile)),
          titleSpacing: 0,
        ),
        body: BlocConsumer<RepeatSurveyCubit, AppStates>(
          listener: (context, state) {
            if (state is LoadedState && state.args == 'submission') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(translator.word(TranslationKeys.completeProfileSuccessMessage)),
                ),
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is LoadingState && state.type != 'submission') {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ErrorState) {
              return Center(child: Text(state.errorMessage));
            } else if (state is LoadedState || (state is LoadingState && state.type == 'submission')) {
              final isLoading = state is LoadingState && state.type == 'submission';
              final bloc = context.read<RepeatSurveyCubit>();
              final List<SurveyForm> surveys = bloc.forms;
              return Stepper(
                type: StepperType.horizontal,
                currentStep: _currentStep,
                onStepContinue: () => _onStepContinue(context, surveys.length),
                onStepCancel: _onStepCancel,
                onStepTapped: (step) => setState(() => _currentStep = step),
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: isLoading ? null : details.onStepContinue,
                          child: isLoading
                              ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                              : Text(translator.word(_currentStep == surveys.length - 1 ? TranslationKeys.submit : TranslationKeys.next)),
                        ),
                        const SizedBox(width: 12),
                        if (_currentStep > 0)
                          OutlinedButton(
                            onPressed: details.onStepCancel,
                            child: Text(translator.word(TranslationKeys.back)),
                          ),
                      ],
                    ),
                  );
                },
                steps: [
                  ...List.generate(surveys.length, (index) {
                    final survey = surveys[index];
                    return Step(
                      title: Text(survey.title),
                      isActive: _currentStep >= 0,
                      state: _stepState(index),
                      content: StepForm(
                        questions: survey.questions,
                      ),
                    );
                  }),
                ],
              );
            } else {
              return Center(child: Text(translator.word(TranslationKeys.somethingWrong)));
            }
          },
        ),
      ),
    );
  }

  void _onStepContinue(BuildContext context, int length) {
    final bloc = context.read<RepeatSurveyCubit>();
    if (_currentStep < length - 1) {
      if (!bloc.validateForm(formIndex: _currentStep)) return;
      setState(() => _currentStep += 1);
    } else {
      if (!bloc.validateForm(formIndex: _currentStep)) return;
      bloc.submitEvent();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  StepState _stepState(int step) {
    if (_currentStep > step) return StepState.complete;
    if (_currentStep == step) return StepState.editing;
    return StepState.indexed;
  }
}
