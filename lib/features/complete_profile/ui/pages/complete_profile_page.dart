// import 'package:base/app/models/select_option.dart';
// import 'package:base/app/widgets/cancel_keyboard_gesture.dart';
// import 'package:base/app/widgets/fields/multic_select_input_field.dart';
// import 'package:base/app/widgets/fields/text_input_field.dart';
// import 'package:flutter/material.dart';
//
// class CompleteProfilePage extends StatelessWidget {
//   const CompleteProfilePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Complete Profile'),
//       ),
//       body: CancelKeyboardGesture(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             children: [
//               TextInputField(
//                 labelText: "Name",
//                 hintText: "Enter your name",
//                 keyboardType: TextInputType.name,
//               ),
//               MultiSelectInputField(
//                 label: "Faculty",
//                 hint: "Select your faculty",
//                 valueSet: [
//                   SelectOption("Computers & Information", "Computers & Information"),
//                   SelectOption("Business & Economics", "Business & Economics"),
//                   SelectOption("Education", "Education"),
//                   SelectOption("Engineering", "Engineering"),
//                   SelectOption("Health Sciences", "Health Sciences"),
//                   SelectOption("Law", "Law"),
//                 ],
//               ),
//               MultiSelectInputField(
//                 label: "University",
//                 hint: "Select your university",
//                 valueSet: [
//                   SelectOption("Mansoura University", "Mansoura University"),
//                   SelectOption("Cairo University", "Cairo University"),
//                   SelectOption("Alexandria University", "Alexandria University"),
//                   SelectOption("Giza University", "Giza University"),
//                   SelectOption("Luxor University", "Luxor University"),
//                 ],
//               ),
//               SizedBox(height: 16),
//               FilledButton(
//                 onPressed: () {},
//                 style: FilledButton.styleFrom(
//                   fixedSize: Size(MediaQuery.of(context).size.width,48),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8)
//                   )
//                 ),
//                 child: Text("Submit"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:base/app/widgets/cancel_keyboard_gesture.dart';
import 'package:base/config/app_states.dart';
import 'package:base/config/app_translation_keys.dart';
import 'package:base/features/complete_profile/core/models/survey_form.dart';
import 'package:base/features/complete_profile/ui/blocs/survey_forms_bloc.dart';
import 'package:base/handlers/translation_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'personal_data_form.dart';
import 'step_form.dart';

class CompleteProfilePage extends StatefulWidget {
  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return CancelKeyboardGesture(
      child: Scaffold(
        appBar: AppBar(
          title: Text(translator.word(TranslationKeys.completeProfile)),
          titleSpacing: 0,
        ),
        body: BlocConsumer<SurveyFormsCubit, AppStates>(
          listener: (context, state) {
            if (state is LoadedState && state.args == "submission") {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                  content: Text(translator.word(TranslationKeys.completeProfileSuccessMessage)),
                ),
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is LoadingState && state.type != "submission") {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ErrorState) {
              return Center(child: Text(state.errorMessage));
            } else if (state is LoadedState || (state is LoadingState && state.type == "submission")) {
              bool isLoading = (state is LoadingState && state.type == "submission");
              var bloc = context.read<SurveyFormsCubit>();
              List<SurveyForm> surveys = bloc.forms;
              return Stepper(
                type: StepperType.horizontal,
                currentStep: _currentStep,
                onStepContinue: () => _onStepContinue(context, surveys.length),
                onStepCancel: _onStepCancel,
                onStepTapped: (step) {
                  setState(() => _currentStep = step);
                },
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: isLoading ? null : details.onStepContinue,
                          child: isLoading ? const CircularProgressIndicator(strokeWidth: 1) : Text(translator.word(_currentStep == 2 ? TranslationKeys.submit : TranslationKeys.next)),
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
                  Step(
                    title: Text(translator.word(TranslationKeys.personalData)),
                    isActive: _currentStep >= 0,
                    state: _stepState(0),
                    content: PersonalDataForm(),
                  ),
                  ...List.generate(surveys.length, (index) {
                    var survey = surveys[index];
                    return Step(
                      title: Text(survey.title),
                      isActive: _currentStep >= 0,
                      state: _stepState(index + 1),
                      content: StepForm(
                        questions: survey.questions,
                      ),
                    );
                  }).toList(),
                ],
              );
            } else {
              return  Center(child: Text(translator.word(TranslationKeys.somethingWrong)));
            }
          },
        ),
      ),
    );
  }

  void _onStepContinue(BuildContext context, int length) {
    var bloc = context.read<SurveyFormsCubit>();
    if (_currentStep < length) {
      if (_currentStep == 0) {
        if (!bloc.validatePersonalData()) {
          return;
        }
      } else {
        if (!bloc.validateForm(formIndex: _currentStep - 1)) {
          return;
        }
      }
      setState(() => _currentStep += 1);
    } else {
      if (!bloc.validateForm(formIndex: _currentStep - 1)) {
        return;
      }
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
