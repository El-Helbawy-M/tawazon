import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/app_states.dart';
import '../bloc/settings_cubit.dart';
import 'cancel_keyboard_gesture.dart';

class NetworkListenerPage extends StatelessWidget {
  const NetworkListenerPage({required this.child, this.onReconnecting});

  final Widget child;
  final Function()? onReconnecting;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) {
      },
      child: BlocListener<SettingsCubit,AppStates>(
        listener: (context, state) {
          if(state is ReconnectedState){
            onReconnecting?.call();
          }
        },
        child: CancelKeyboardGesture(child: child),
      ),
    );
  }
}
