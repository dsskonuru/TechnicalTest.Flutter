import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kOrange = Color(0xFFff8800);
const kOrangeLight = Color(0xFFffb944);
const kOrangeDark = Color(0xFFc55900);

const kCream = Color(0xFFf8dda4);
const kCreamLight = Color(0xFFffffd6);
const kCreamDark = Color(0xFFc4ab75);

const kErrorRed = Color(0xFFC5032B);

final buttonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(kOrange),
);

final textTheme = TextTheme(
  headline1: GoogleFonts.quicksand(
    fontSize: 98,
    fontWeight: FontWeight.w300,
    letterSpacing: -1.5,
  ),
  headline2: GoogleFonts.quicksand(
    fontSize: 61,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.5,
  ),
  headline3: GoogleFonts.quicksand(
    fontSize: 49,
    fontWeight: FontWeight.w400,
  ),
  headline4: GoogleFonts.quicksand(
    fontSize: 35,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  ),
  headline5: GoogleFonts.quicksand(
    fontSize: 24,
    fontWeight: FontWeight.w400,
  ),
  headline6: GoogleFonts.quicksand(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  ),
  subtitle1: GoogleFonts.quicksand(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  ),
  subtitle2: GoogleFonts.quicksand(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  ),
  bodyText1: GoogleFonts.ptSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  ),
  bodyText2: GoogleFonts.ptSans(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  ),
  button: GoogleFonts.ptSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
  ),
  caption: GoogleFonts.ptSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  ),
  overline: GoogleFonts.ptSans(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
  ),
);

final colorScheme = const ColorScheme.light().copyWith(
  primary: kOrange,
  primaryContainer: kOrangeDark,
  secondary: kCreamLight,
  secondaryContainer: kCreamDark,
  surface: kOrangeLight,
  background: kCream,
  error: kErrorRed,
);

ThemeData themeData(BuildContext context) => ThemeData(
      textTheme: textTheme,
      colorScheme: colorScheme,
    ).copyWith(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
