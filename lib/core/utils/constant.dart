import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConstant {
//Url Network
  static const String baseUrl =
      "https://engineer-test-eight.vercel.app/course-status.json";

//UI Color
  static const Color baseColor = Colors.blue;
  static const Color backgroundColor = Colors.white;

//Textstyle
  TextStyle titleTextStyle = GoogleFonts.roboto(
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );
  TextStyle normalTextStyle = GoogleFonts.roboto(
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );
  TextStyle thinTextStyle = GoogleFonts.roboto(
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  //Course Data Type
  static const String sectionType = "section";
  static const String unitType = "unit";
}
