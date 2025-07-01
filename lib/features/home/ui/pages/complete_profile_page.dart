import 'package:base/app/models/select_option.dart';
import 'package:base/app/widgets/cancel_keyboard_gesture.dart';
import 'package:base/app/widgets/fields/multic_select_input_field.dart';
import 'package:base/app/widgets/fields/text_input_field.dart';
import 'package:flutter/material.dart';

class CompleteProfilePage extends StatelessWidget {
  const CompleteProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Profile'),
      ),
      body: CancelKeyboardGesture(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextInputField(
                labelText: "Name",
                hintText: "Enter your name",
                keyboardType: TextInputType.name,
              ),
              MultiSelectInputField(
                label: "Faculty",
                hint: "Select your faculty",
                valueSet: [
                  SelectOption("Computers & Information", "Computers & Information"),
                  SelectOption("Business & Economics", "Business & Economics"),
                  SelectOption("Education", "Education"),
                  SelectOption("Engineering", "Engineering"),
                  SelectOption("Health Sciences", "Health Sciences"),
                  SelectOption("Law", "Law"),
                ],
              ),
              MultiSelectInputField(
                label: "University",
                hint: "Select your university",
                valueSet: [
                  SelectOption("Mansoura University", "Mansoura University"),
                  SelectOption("Cairo University", "Cairo University"),
                  SelectOption("Alexandria University", "Alexandria University"),
                  SelectOption("Giza University", "Giza University"),
                  SelectOption("Luxor University", "Luxor University"),
                ],
              ),
              SizedBox(height: 16),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width,48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
