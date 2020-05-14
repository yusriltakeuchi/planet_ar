import 'package:animations/animations.dart';
import 'package:earthmodel/ui/widgets/info_dialog.dart';
import 'package:flutter/material.dart';

class DialogUtils {

  static DialogUtils instance = DialogUtils();

  void showDialog(BuildContext context, String text, String buttonText) {
    showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(),
      builder: (context) {
        return InfoDialog(
          text: text,
          onClickOK: () => Navigator.pop(context),
          icon: Icons.info,
          clickText: buttonText,
        );
      }
    );
  }
}