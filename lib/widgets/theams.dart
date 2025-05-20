import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class Theams {
  static ThemeData lightTheam(BuildContext context) =>
      ThemeData(
          brightness: Brightness.light,
          cardColor: Colors.black,
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts
              .poppins()
              .fontFamily,
          appBarTheme: AppBarTheme(
            color: Colors.blueAccent,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          )
      );
}