import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perpustakaan/utils/app_theme.dart';

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
          title: Text(title, style: GoogleFonts.montserrat()),
          content: Text(
            message!,
            style: GoogleFonts.montserrat(textStyle: TextStyle(color: AppTheme.textDarker)),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Tutup", style: GoogleFonts.montserrat()),
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
