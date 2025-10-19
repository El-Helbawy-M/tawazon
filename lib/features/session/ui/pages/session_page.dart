import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/app_states.dart';
import '../bloc/session_bloc.dart';
import '../widgets/session_progress_bar.dart';
import '../widgets/session_step_content.dart';
import '../widgets/session_navigation_controls.dart';

/// Main session page that displays dynamic content with step navigation
class SessionPage extends StatelessWidget {
  final String sessionId;
  final int completedScreenCount;
  const SessionPage({
    Key? key,
    required this.sessionId,
    required this.completedScreenCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SessionBloc()..loadSession(sessionId, completedScreenCount),
      child: const _SessionPageContent(),
    );
  }
}

class _SessionPageContent extends StatelessWidget {
  const _SessionPageContent();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return BlocListener<SessionBloc, AppStates>(
      listener: (context, state) {
        if (state is SessionCompletedState) {
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (ctx) => AlertDialog(
              title: const Text('تهانينا!'),
              content: const Text('لقد أكملت الجلسة بنجاح.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('حسناً'),
                ),
              ],
            ),
          ).then((_) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });
        }
      },
      child: Scaffold(
      appBar: AppBar(
        title: BlocBuilder<SessionBloc, AppStates>(
          builder: (context, state) {
            final session = context.read<SessionBloc>().currentSession;
            if (session != null) {
              return Text(session.title);
            }
            return const Text('جلسة تدريبية');
          },
        ),
        elevation: 0,
        titleSpacing: 0,
      ),
      body: BlocBuilder<SessionBloc, AppStates>(
        builder: (context, state) {
          final sessionBloc = context.read<SessionBloc>();
          final session = sessionBloc.currentSession;
          
          return switch (state) {
            LoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
            ErrorState() => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => sessionBloc.loadSession(
                        (context.widget as SessionPage).sessionId,
                        (context.widget as SessionPage).completedScreenCount,
                      ),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            _ when session != null => Column(
                children: [
                  // Progress bar at the top
                  SessionProgressBar(session: session),
                  
                  // Main content area
                  Expanded(
                    child: SessionStepContent(
                      session: session,
                      currentStep: session.currentStep,
                      formKey: formKey,
                    ),
                  ),
                  
                  // Navigation controls at the bottom
                  SessionNavigationControls(session: session, formKey: formKey),
                ],
              ),
            _ => const Center(
                child: Text('حالة غير متوقعة'),
              ),
          };
        },
      ),
    ),
    );
  }
}
