import 'dart:io';

import 'package:mime/mime.dart';

extension FileExtensions on File {
  String? get contentType {
    final mimeType = lookupMimeType(path);
    return mimeType;
  }
}