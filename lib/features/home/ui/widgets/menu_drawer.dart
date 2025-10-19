import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawazon/shared/bloc/user_cubit.dart';
import 'package:tawazon/config/app_states.dart';
import 'package:tawazon/config/app_translation_keys.dart';
import 'package:tawazon/handlers/translation_handler.dart';
import 'package:tawazon/navigation/app_routes.dart';
import 'language_picker_bottom_sheet.dart';
import 'package:tawazon/utility/extensions/context_extensions.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Drawer(
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drawer Header
            DrawerHeader(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withOpacity(0.8),
                    colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: colorScheme.onPrimary,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${translator.word(TranslationKeys.welcome)} 👋",
                    style: context.theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  BlocBuilder<UserCubit, AppStates>(
                    builder: (context, state) {
                      return state is LoadedState
                          ? Text(
                              UserCubit.instance.user.email ?? "",
                              style:
                                  context.theme.textTheme.bodyMedium?.copyWith(
                                color:
                                    colorScheme.onPrimary.withValues(alpha: .7),
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  )
                ],
              ),
            ),
            // Options List
            Expanded(
              child: ListView(
                children: [
                  // 📓 No need for this option now
                  // ===================================
                  // ListTile(
                  //   leading: Icon(Icons.home, color: colorScheme.primary),
                  //   title: Text(translator.word(TranslationKeys.home)),
                  //   onTap: () {
                  //     // Handle tap
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  ListTile(
                    leading: Icon(Icons.language, color: colorScheme.primary),
                    title: Text(translator.word(TranslationKeys.language)),
                    onTap: () => LanguagePickerBottomSheet.show(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.info, color: colorScheme.primary),
                    title: Text(translator.word(TranslationKeys.about)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: colorScheme.onError,
                  backgroundColor: colorScheme.error,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  fixedSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text(translator.word(TranslationKeys.logout)),
                onPressed: () {
                  UserCubit.instance.logout();
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
