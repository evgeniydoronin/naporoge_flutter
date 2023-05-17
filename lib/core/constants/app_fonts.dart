part of 'app_theme.dart';

class AppFont {
  static double largest = 20;
  static double large = 18;
  static double regular = 16;
  static double small = 14;
  static double smaller = 12;

  static TextStyle scaffoldTitleDark = TextStyle(
      fontSize: large, fontWeight: FontWeight.w600, color: AppColor.blk);
  static TextStyle largeExtraBold =
      TextStyle(fontSize: large, fontWeight: FontWeight.w800);
  static TextStyle largeSemibold =
      TextStyle(fontSize: large, fontWeight: FontWeight.w500);
  static TextStyle regularSemibold =
      TextStyle(fontSize: regular, fontWeight: FontWeight.w500);
  static TextStyle smallNormal =
      TextStyle(fontSize: small, fontWeight: FontWeight.w400);

  static TextStyle formLabel =
      TextStyle(fontSize: small, fontWeight: FontWeight.w400);
}
