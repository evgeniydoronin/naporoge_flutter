part of 'app_theme.dart';

class AppLayout {
  static Border primaryBorder = Border.all(color: const Color(0xFFE7E7E7));
  static BorderRadius smallRadius = const BorderRadius.all(Radius.circular(8));
  static BorderRadius primaryRadius =
      const BorderRadius.all(Radius.circular(15));

  static ButtonStyle primaryBTNStyle = ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      backgroundColor: AppColor.primary,
      shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius));

  static ButtonStyle accentBowBTNStyle = ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      backgroundColor: AppColor.accentBOW,
      shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius));

  static ButtonStyle accentBTNStyle = ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      backgroundColor: AppColor.accent,
      shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius));

  static BoxDecoration boxDecorationShadowBGBorderNone = BoxDecoration(
    borderRadius: AppLayout.primaryRadius,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 10,
        spreadRadius: 0,
      )
    ],
  );

  static BoxDecoration boxDecorationShadowBG = BoxDecoration(
    color: AppColor.lightBGItem,
    border: AppLayout.primaryBorder,
    borderRadius: AppLayout.primaryRadius,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 5,
        spreadRadius: 0,
      )
    ],
  );
  static BoxDecoration boxDecorationOpacityShadowBG = BoxDecoration(
    color: AppColor.lightBGItem.withOpacity(0.9),
    border: AppLayout.primaryBorder,
    borderRadius: AppLayout.primaryRadius,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 5,
        spreadRadius: 0,
      )
    ],
  );
}
