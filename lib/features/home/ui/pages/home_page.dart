import 'dart:developer';

import 'package:base/app/bloc/user_cubit.dart';
import 'package:base/config/app_states.dart';
import 'package:base/features/home/ui/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../navigation/app_routes.dart';
import '../widgets/complete_profile_alert.dart';
import '../widgets/session_card.dart';
import '../bloc/sessions_progress_cubit.dart';
import '../../core/entities/sessions_overall_progress_entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            //        Navigator.pushNamed(context, AppRoutes.session, arguments: session['id']);
        
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: BlocBuilder<SessionsProgressCubit, AppStates>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  if (state is ErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading sessions',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.errorMessage,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  
                  if (state is LoadedState) {
                    final progressData = state.data as SessionsOverallProgressEntity;
                    final sessionsList = progressData.sessions.values.toList();
                    
                    if (sessionsList.isEmpty) {
                      return const Center(
                        child: Text('No sessions available'),
                      );
                    }
                    
                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: sessionsList.length,
                      itemBuilder: (context, index) {
                        final sessionEntity = sessionsList[index];
                        
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              AppRoutes.session, 
                              arguments: {
                                "sessionId": sessionEntity.sessionId,
                                "completedScreenCount": sessionEntity.completedScreens,
                              },
                            );
                          },
                          child: SessionCard(session: sessionEntity),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                    );
                  }
                  
                  return const Center(
                    child: Text('No data available'),
                  );
                },
              ),
            ),
            BlocBuilder<UserCubit, AppStates>(
              builder: (context, state) {
                if (state is LoadingState) {
                  return SizedBox();
                }
                return Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: AnimatedProfileReminderBanner(
                    isVisible: !UserCubit.instance.hasCompletedProfile,
                    onCompleteProfile: () {
                      Navigator.pushNamed(context, AppRoutes.completeProfile);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
}
