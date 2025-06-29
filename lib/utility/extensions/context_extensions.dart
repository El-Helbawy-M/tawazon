import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext{
  ThemeData get theme => Theme.of(this);

  void showSnackBar (Color backgroundColor, String message){
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      content: Text(message),
    ));
  }
}