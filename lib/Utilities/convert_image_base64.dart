import 'dart:convert';
import 'dart:io';

String fileToBase64(File file) {
  final bytes = file.readAsBytesSync();
  return base64Encode(bytes);
}
