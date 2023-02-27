import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perpustakaan/utils/screen_size_helper.dart';

class AppTheme {
  static var colorPrimary = Color(AppTheme.getColorFromHex('#543884'));
  static var colorPrimaryLight = Color(AppTheme.getColorFromHex('#9A77CF'));
  static var colorPrimaryDark = Color(AppTheme.getColorFromHex('#262254'));
  static var colorAccent = Color(AppTheme.getColorFromHex('#EC4176'));
  static var colorAccentDark = Color(AppTheme.getColorFromHex('#A13670'));
  static var colorYellow = Color(AppTheme.getColorFromHex('#FFA45E'));

  static var lightGrey1 = Color(AppTheme.getColorFromHex('#FAFAFA'));
  static var lightGrey2 = Color(AppTheme.getColorFromHex('#F7F7F7'));
  static var lightGrey3 = Color(AppTheme.getColorFromHex('#F3F3F3'));
  static var white = Color(AppTheme.getColorFromHex("#FFFFFF"));

  static var textLight = Color(AppTheme.getColorFromHex("#BACC5D3"));
  static var textDarker = Color(AppTheme.getColorFromHex("#000000"));
  static var textDark = Color(AppTheme.getColorFromHex("#4C5264"));
  static var transparent = Colors.transparent;

  static int getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  static appBackground() {
    return BoxDecoration(
      color: AppTheme.white,
    );
  }

  static tabbarDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      color: AppTheme.colorPrimaryDark,
    );
  }

  static customAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: AppTheme.colorPrimaryDark),
      elevation: 0.0,
      backgroundColor: AppTheme.white,
    );
  }

  static customAppBarButton(context,
      {required buttonText, required callbackFunction}) {
    return AppBar(
      backgroundColor: AppTheme.white,
      elevation: 0.0,
      actions: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: callbackFunction,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.colorAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              children: [
                Text(
                  buttonText ?? 'buttonText',
                  style: GoogleFonts.raleway(
                      textStyle: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: AppTheme.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static customAppBarTitle({required title, required isCenter}) {
    return AppBar(
      iconTheme: IconThemeData(color: AppTheme.colorPrimaryDark),
      elevation: 0.0,
      backgroundColor: AppTheme.white,
      title: Text(
        title,
        style: GoogleFonts.raleway(
            textStyle: TextStyle(
                color: AppTheme.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 25)),
      ),
      centerTitle: isCenter,
    );
  }

  static appBarSale({required title, required status}) {
    return AppBar(
      iconTheme: IconThemeData(color: AppTheme.colorPrimaryDark),
      elevation: 0.0,
      backgroundColor: AppTheme.white,
      title: Text(
        title,
        style: GoogleFonts.raleway(
            textStyle: TextStyle(
                color: AppTheme.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 28)),
      ),
      centerTitle: false,
      actions: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 15, 0),
          child: status,
        ),
      ],
    );
  }

  static listDecoration() {
    return BoxDecoration(
      color: AppTheme.lightGrey1,
      border: Border.all(
        color: AppTheme.lightGrey2,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  static inputDecoration() {
    return BoxDecoration(
      color: AppTheme.lightGrey2,
      border: Border.all(
        color: AppTheme.lightGrey2,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  static inputDecoration2() {
    return BoxDecoration(
      color: AppTheme.lightGrey2,
      border: Border.all(
        color: AppTheme.lightGrey2,
      ),
      borderRadius: BorderRadius.circular(20),
    );
  }

  static inputDecoration3() {
    return BoxDecoration(
      color: AppTheme.lightGrey2,
      border: Border.all(
        color: AppTheme.lightGrey2,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  static inputDecoration4() {
    return BoxDecoration(
      color: AppTheme.lightGrey2,
      border: Border.all(
        color: AppTheme.lightGrey2,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  static inputDecoration5() {
    return BoxDecoration(
      color: AppTheme.white,
      border: Border.all(
        color: AppTheme.textDark.withOpacity(0.3),
      ),
      borderRadius: BorderRadius.circular(4),
    );
  }

  static inputDecoration6() {
    return BoxDecoration(
      color: Color(AppTheme.getColorFromHex("#9D9D9D")),
      border: Border.all(
        color: Color(AppTheme.getColorFromHex("#9D9D9D")),
      ),
      borderRadius: BorderRadius.circular(4),
    );
  }

  static listBackground() {
    return BoxDecoration(
      color: AppTheme.colorPrimaryDark,
      borderRadius: BorderRadius.circular(12),
    );
  }

  static roundButton() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    );
  }

  static dateDecoration() {
    return BoxDecoration(
      color: AppTheme.textDark,
      borderRadius: BorderRadius.circular(8),
    );
  }

  static cardDecorationShadow() {
    return BoxDecoration(
      color: AppTheme.white,
      border: Border.all(
        color: AppTheme.white,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 5,
          offset: Offset(1, 2),
        ),
      ],
    );
  }

  static cardListDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      color: Color(0xfff2f3f6),
    );
  }

  static decorationNew() {
    return BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        color: AppTheme.white);
  }

  static customContainer(context, {required padding, required child}) {
    return Container(
      padding: padding,
      width: ScreenSizeHelper.getDisplaySize(context).width,
      decoration: AppTheme.decorationNew(),
      child: child,
    );
  }
}
