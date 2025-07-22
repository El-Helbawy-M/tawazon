import 'dart:developer';

import 'package:base/app/bloc/user_cubit.dart';
import 'package:base/config/app_states.dart';
import 'package:base/features/home/ui/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../navigation/app_routes.dart';
import '../widgets/complete_profile_alert.dart';
import '../widgets/session_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = [
      {
        'title': 'Session 1: Introduction',
        'description': 'Overview of core concepts.',
        'totalPages': 5,
        'finishedPages': 5,
        'status': 'Finished',
      },
      {
        'title': 'Session 2: Setup & Tools',
        'description': 'Install and configure the environment.',
        'totalPages': 5,
        'finishedPages': 2,
        'status': 'In Progress',
      },
      {
        'title': 'Session 3: Widgets Basics',
        'description': 'Understanding widgets and layout.',
        'totalPages': 5,
        'finishedPages': 0,
        'status': 'Not Started',
      },
    ];
    return Scaffold(
      drawer: MenuDrawer(),

      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(icon: const Icon(Icons.menu),onPressed: (){
              Scaffold.of(context).openDrawer();
            },);
          }
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return SessionCard(session: session);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                    Navigator.pushNamed(context,AppRoutes.completeProfile);
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


