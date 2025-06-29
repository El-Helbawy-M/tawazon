import 'package:flutter/material.dart';

import '../../utility/style/app_colors.dart';

abstract class StatusSnackBars {
  static SnackBar successSnackBar(String content) => SnackBar(
        content: Text(content),
        backgroundColor: AppColors.successColor,
      );
}
