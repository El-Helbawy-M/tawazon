import 'package:flutter/material.dart';
import 'package:tawazon/shared/bloc/settings_cubit.dart';
import 'package:tawazon/handlers/translation_handler.dart';
import 'package:tawazon/config/app_translation_keys.dart';

class LanguagePickerBottomSheet extends StatelessWidget {
  const LanguagePickerBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => const LanguagePickerBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = SettingsCubit.instance.locale.languageCode;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 48),
                Expanded(
                  child: Center(
                    child: Text(
                      translator.word(TranslationKeys.selectLanguage),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          ListTile(
            leading:
                Icon(Icons.flag, color: current == 'ar' ? Colors.green : null),
            title: const Text('العربية'),
            onTap: () {
              SettingsCubit.instance.setLocale('ar');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading:
                Icon(Icons.flag, color: current == 'en' ? Colors.green : null),
            title: const Text('English'),
            onTap: () {
              SettingsCubit.instance.setLocale('en');
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
