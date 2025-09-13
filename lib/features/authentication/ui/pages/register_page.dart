import 'package:base/app/widgets/cancel_keyboard_gesture.dart';
import 'package:base/app/widgets/cashed_network_image.dart';
import 'package:base/app/widgets/fields/text_input_field.dart';
import 'package:base/config/app_events.dart';
import 'package:base/config/app_persistence_data_keys.dart';
import 'package:base/config/app_states.dart';
import 'package:base/config/app_translation_keys.dart';
import 'package:base/handlers/translation_handler.dart';
import 'package:base/utility/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../navigation/app_routes.dart';
import '../bloc/register_bloc.dart';

/// A widget representing the login page of the application.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0,
          title: Text(translator.word(TranslationKeys.submit),
              style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: CancelKeyboardGesture(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: BlocConsumer<RegisterBloc, AppStates>(
              listener: (oldState, newState) async {
                if (newState is ErrorState) {
                  context.showSnackBar(Colors.red, newState.errorMessage);
                }
                if (newState is LoadedState) {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Registered Successfully"),
                        content: const Text(
                            "An email has been sent to your email address with instructions to Verify your email."),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Ok")),
                        ],
                      );
                    },
                  );
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                var bloc = context.read<RegisterBloc>();
                return Column(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 8,
                  ),
                  const CircleAvatar(
                radius: 65,
                backgroundImage: AssetImage('assets/images/logo.png'),
                backgroundColor: Colors.white,
              ),
                  const SizedBox(height: 36),
                  TextInputField(
                    labelText: translator.word(TranslationKeys.email),
                    hintText: translator.word(TranslationKeys.emailFieldHint),
                    keyboardType: TextInputType.emailAddress,
                    controller: bloc.emailController,
                    hasError: bloc.emailError.isNotEmpty,
                    errorText: bloc.emailError,
                  ),
                  TextInputField(
                    labelText: translator.word(TranslationKeys.password),
                    hintText:
                        translator.word(TranslationKeys.passwordFieldHint),
                    keyboardType: TextInputType.visiblePassword,
                    controller: bloc.passwordController,
                    hasError: bloc.passwordError.isNotEmpty,
                    errorText: bloc.passwordError,
                  ),
                  TextInputField(
                    labelText: translator.word(TranslationKeys.confirmPassword),
                    hintText: translator
                        .word(TranslationKeys.confirmPasswordFieldHint),
                    keyboardType: TextInputType.visiblePassword,
                    controller: bloc.confirmPasswordController,
                    hasError: bloc.passwordError.isNotEmpty,
                    errorText: bloc.passwordError,
                    withBottomPadding: false,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.forgetPassword);
                      },
                      child: Text(
                          translator.word(TranslationKeys.forgotPassword),
                          style: TextStyle(
                              color: context.theme.colorScheme.primary)),
                    ),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: state is LoadingState
                          ? null
                          : () {
                              bloc.add(ClickEvent());
                            },
                      child: state is LoadingState
                          ? const CircularProgressIndicator(strokeWidth: 1)
                          : Text(translator.word(TranslationKeys.register)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(translator.word(TranslationKeys.haveAnAccount)),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(translator.word(TranslationKeys.signIn),
                            style: TextStyle(
                                color: context.theme.colorScheme.primary)),
                      ),
                    ],
                  )
                ]);
              },
            ),
          ),
        ));
  }
}
