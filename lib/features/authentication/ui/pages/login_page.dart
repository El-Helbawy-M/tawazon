import 'package:base/app/widgets/cancel_keyboard_gesture.dart';
import 'package:base/app/widgets/cashed_network_image.dart';
import 'package:base/app/widgets/fields/text_input_field.dart';
import 'package:base/configurations/app_events.dart';
import 'package:base/configurations/app_states.dart';
import 'package:base/utility/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../navigation/app_routes.dart';
import '../bloc/login_bloc.dart';

/// A widget representing the login page of the application.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CancelKeyboardGesture(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<LoginBloc, AppStates>(
          listener: (oldState, newState) {
            if (newState is ErrorState) {
              context.showSnackBar(Colors.red, newState.errorMessage);
            }
            if (newState is LoadedState) {
              context.showSnackBar(Colors.green, "Login successful");
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
            }
          },
          builder: (context, state) {
            var bloc = context.read<LoginBloc>();
            return Column(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              CashedImage.circleNewWorkImage(radius: 50, image: "https://images.pexels.com/photos/170809/pexels-photo-170809.jpeg"),
              const SizedBox(height: 36),
              TextInputField(
                labelText: "Email",
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
                controller: bloc.emailController,
                hasError: bloc.emailError.isNotEmpty,
                errorText: bloc.emailError,
              ),
              TextInputField(
                labelText: "Password",
                hintText: "Enter your password",
                keyboardType: TextInputType.visiblePassword,
                controller: bloc.passwordController,
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
                  child: Text("Forgot password?", style: TextStyle(color: context.theme.colorScheme.primary)),
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: state is LoadingState ? null : () {
                    bloc.add(ClickEvent());
                  },
                  child: state is LoadingState ? const CircularProgressIndicator(strokeWidth: 1) : const Text("Login"),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                    child: Text("Sign up", style: TextStyle(color: context.theme.colorScheme.primary)),
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
