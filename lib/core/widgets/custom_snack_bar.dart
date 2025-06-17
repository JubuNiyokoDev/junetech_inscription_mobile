import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class CustomSnackBar {
  static String getText(ContentType contentType) {
    if (contentType == ContentType.failure) {
      return 'Error';
    } else if (contentType == ContentType.success) {
      return 'Success';
    } else if (contentType == ContentType.help) {
      return 'Help';
    } else {
      return 'Warning';
    }
  }

  static void show(
    BuildContext context, {
    String? title,
    required String content,
    required ContentType status,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      duration: duration,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: getText(status),
        message: content,
        contentType: status,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showWithKey({
    required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
    required String content,
    required ContentType status,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title ?? getText(status),
        message: content,
        contentType: status,
      ),
      duration: duration,
    );

    scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
