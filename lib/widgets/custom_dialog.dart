import 'package:flutter/material.dart';

class CustomDialog {
  static getDialog({
      required String title,
      required String? message,
      required BuildContext context,
      required int popCount
    }) { return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message!,
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Tutup"),
              onPressed: () {
                for (int i = 0; i < popCount; i++) {
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      }
    );
  }
}
