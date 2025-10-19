import 'package:tawazon/shared/widgets/cancel_keyboard_gesture.dart';
import 'package:tawazon/shared/widgets/fields/text_input_field.dart';
import 'package:tawazon/config/app_events.dart';
import 'package:tawazon/config/app_states.dart';
import 'package:tawazon/features/authentication/ui/bloc/forget_password_bloc.dart';
import 'package:tawazon/utility/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:tawazon/handlers/translation_handler.dart';
import 'package:tawazon/config/app_translation_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


/// A widget representing the login page of the application.
class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          titleSpacing: 0,
          title: Text(translator.word(TranslationKeys.forgotPassword), style: TextStyle(color: Colors.black)),
        ),
        body: CancelKeyboardGesture(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<ForgetPasswordBloc, AppStates>(
          listener: (oldState, newState) async {
            if (newState is ErrorState) {
              context.showSnackBar(Colors.red, newState.errorMessage);
            }
            if (newState is LoadedState) {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(translator.word(TranslationKeys.emailSentTitle)),
                      content: Text(translator.word(TranslationKeys.emailSentBody)),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(translator.word(TranslationKeys.ok)))],
                    );
                  });
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            var bloc = context.read<ForgetPasswordBloc>();
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                ),
                const CircleAvatar(
                radius: 65,
                backgroundImage: AssetImage('assets/images/logo.png'),
                backgroundColor: Colors.white,
              ),const SizedBox(height: 36),
                TextInputField(
                  labelText: translator.word(TranslationKeys.email),
                  hintText: translator.word(TranslationKeys.emailFieldHint),
                  keyboardType: TextInputType.emailAddress,
                  controller: bloc.emailController,
                  hasError: bloc.emailError.isNotEmpty,
                  errorText: bloc.emailError,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: state is LoadingState
                        ? null
                        : () {
                            bloc.add(ClickEvent());
                          },
                    child: state is LoadingState ? const CircularProgressIndicator(strokeWidth: 1) : Text(translator.word(TranslationKeys.submit)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ));
  }
}
