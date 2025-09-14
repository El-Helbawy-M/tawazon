import 'package:base/app/widgets/fields/text_input_field.dart';
import 'package:base/config/app_translation_keys.dart';
import 'package:base/handlers/translation_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/models/select_option.dart';
import '../../../../app/widgets/fields/radio_input_field.dart';
import '../../../../app/widgets/fields/single_select_input_field.dart';
import '../blocs/survey_forms_bloc.dart';

class PersonalDataForm extends StatelessWidget {
  const PersonalDataForm({super.key});
  @override
  Widget build(BuildContext context) {
    var bloc = context.read<SurveyFormsCubit>();
    return Column(
      children: [
        SingleSelectInputField(
          label: translator.word(TranslationKeys.faculity),
          hint: "${translator.word(TranslationKeys.choose)}  ${translator.word(TranslationKeys.faculity)}",
          selectedValue: bloc.selectedFaculity,
          errorText: bloc.faculityError,
          hasError: bloc.faculityError.isNotEmpty,
          valueSet: [
            SelectOption("Computers & Information", "Computers & Information"),
            SelectOption("Business & Economics", "Business & Economics"),
            SelectOption("Education", "Education"),
            SelectOption("Engineering", "Engineering"),
            SelectOption("Health Sciences", "Health Sciences"),
            SelectOption("Law", "Law"),
          ],
          onChange: (selectedOption ) {
            bloc.selectedFaculity = selectedOption;
          },
        ),
        TextInputField(
          labelText: "العمر",
          hintText: "ادخل عمرك",
          keyboardType: TextInputType.number,
          controller: bloc.ageController,
          hasError: bloc.ageError.isNotEmpty,
          errorText: "هذا الحقل مطلوب",
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
        ),
        RadioInputField(
          labelText: "الجنس",
          selectedValue: bloc.gender?.value,
          options: ["ذكر", "أنثى"],
          onChange: (val) {},
        ),
        SingleSelectInputField(
          label: "الفرقة الدراسية",
          hint: "اختر الفرقة الدراسية",
          selectedValue: bloc.academicTeam,
          errorText: bloc.academicTeamError,
          hasError: bloc.academicTeamError.isNotEmpty,
          valueSet: [
            SelectOption("أولى", "أولى"),
            SelectOption("ثانية", "ثانية"),
            SelectOption("ثالثة", "ثالثة"),
            SelectOption("رابعة", "رابعة"),
            SelectOption("خامسة", "خامسة"),
            SelectOption("أخرى", "أخرى"),
          ],
          onChange: (val) {
            bloc.academicTeam = val;
          },
        ),
        TextInputField(
          labelText: "التقدير",
          hintText: "ادخل المعدل التراكمي الاخير",
          keyboardType: TextInputType.number,
          controller: bloc.academicGradeController,
          hasError: bloc.academicGradeError.isNotEmpty,
          errorText: "هذا الحقل مطلوب",
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
        ),
        RadioInputField(
          labelText: "محل الأقامة",
          selectedValue: bloc.placeOfResidence!.value,
          options: ["مدينة", "ريف"],
          onChange: (val) {},
        ),
        RadioInputField(
          labelText: "هل سبق لك زيارة طبيب او معالج نفسى ؟",
          selectedValue: bloc.hasVisitedDoctorOnce ? "نعم":"لا",
          options: ["لا", "نعم"],
          onChange: (val) {},
        ),
        // Add Gender, DOB, etc.
      ],
    );
  }
}
