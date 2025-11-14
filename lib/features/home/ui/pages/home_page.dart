import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawazon/shared/bloc/user_cubit.dart';
import 'package:tawazon/config/app_states.dart';
import 'package:tawazon/features/home/ui/widgets/resubmit_survey_alert.dart';
import '../../../../navigation/app_routes.dart';
import '../../core/entities/sessions_overall_progress_entity.dart';
import '../bloc/sessions_progress_cubit.dart';
import '../widgets/complete_profile_alert.dart';
import '../widgets/menu_drawer.dart';
import '../widgets/session_card.dart';
import 'package:tawazon/handlers/translation_handler.dart';
import 'package:tawazon/config/app_translation_keys.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        drawer: const MenuDrawer(),
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
        bottomNavigationBar: BlocBuilder<SessionsProgressCubit, AppStates>(
            builder: (context, state) {
          return AnimatedCrossFade(
            crossFadeState: BlocProvider.of<SessionsProgressCubit>(context)
                    .areAllSessionsCompleted
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
            firstChild:
                SizedBox(width: MediaQuery.of(context).size.width, height: 0),
            secondChild: Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      translator.word(TranslationKeys.surveyReadyMessage),
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.repeatSurvey);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        translator.word(TranslationKeys.start),
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          );
        }),
        body: Stack(
          children: [
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
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
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
                    final progressData =
                        state.data as SessionsOverallProgressEntity;
                    final sessionsList = progressData.sessions.values.toList();

                    if (sessionsList.isEmpty) {
                      return Center(
                        child: Text(translator
                            .word(TranslationKeys.noSessionsAvailable)),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16
                      ),
                      itemCount: sessionsList.length,
                      itemBuilder: (context, index) {
                        final sessionEntity = sessionsList[index];
                        return GestureDetector(
                          onTap: () {
                            // Block navigation if profile is not completed
                            if (!UserCubit.instance.hasCompletedProfile) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'يرجى استكمال الملف الشخصي أولاً',
                                  ),
                                ),
                              );
                              return;
                            }

                            Navigator.pushNamed(
                              context,
                              AppRoutes.session,
                              arguments: {
                                "sessionId": sessionEntity.sessionId,
                                "completedScreenCount":
                                    sessionEntity.completedScreens,
                              },
                            ).then(
                              (value) {
                                BlocProvider.of<SessionsProgressCubit>(context)
                                    .refreshUserProgress(
                                  UserCubit.instance.user.id ?? "",
                                );
                              },
                            );
                          },
                          child: SessionCard(session: sessionEntity),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                    );
                  }

                  return Center(
                    child:
                        Text(translator.word(TranslationKeys.noDataAvailable)),
                  );
                },
              ),
            ),
            BlocBuilder<UserCubit, AppStates>(
              builder: (context, state) {
                if (state is LoadingState) {
                  return const SizedBox();
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
