import 'dart:developer';

import 'package:base/app/bloc/user_cubit.dart';
import 'package:base/config/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/complete_profile_alert.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        leadingWidth: 0,
        title: const Text('Home',style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children:  <Widget>[
                Divider(
                  color: Colors.grey[200],
                  thickness: 1,
                ),
                Text('Coming Soon!', style: TextStyle(fontSize: 24)),
              ],
            ),
          ),
          BlocBuilder<UserCubit, AppStates>(
            builder: (context, state) {
              if(state is LoadingState) {
                return SizedBox();
              }
              return Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: AnimatedProfileReminderBanner(
                  isVisible: !UserCubit.instance.hasCompletedProfile,
                  onCompleteProfile: () {
                    // Navigate to profile screen or open modal
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
