import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Mythemes {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
    brightness: Brightness.light,
      primaryColor: Colors.lightBlue,
      primarySwatch: Colors.lightBlue,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.lightBlue),
      datePickerTheme: DatePickerThemeData(
          todayBackgroundColor: WidgetStatePropertyAll(Colors.lightBlue),
          todayBorder: BorderSide(style: BorderStyle.none),
        backgroundColor: Mythemes.whitish
      ),
      disabledColor: Colors.black12,
      inputDecorationTheme: InputDecorationTheme(disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Mythemes.greyish), // Change color as needed
      ),
        focusedBorder: UnderlineInputBorder(              // Border color when focused
          borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),
         // borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: UnderlineInputBorder(            // Border color when not focused
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
          //borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      radioTheme: RadioThemeData(fillColor: WidgetStatePropertyAll(Colors.lightBlue)),
      buttonTheme: ButtonThemeData(
        buttonColor: Mythemes.lightBluishColor,
        textTheme: ButtonTextTheme.accent
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white), // Text color
            backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue), // Background color (optional)
          ),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        color: Colors.white,
        //shadowColor: Mythemes.lightBluishColor
      ),
      //primarySwatch: Colors.deepPurple,

      fontFamily: GoogleFonts.poppins().fontFamily,
      cardColor: Colors.white,
      canvasColor: creamColor,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 6,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blueGrey[200],
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(
              color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400)
        /*  toolbarTextStyle: Theme.of(context).textTheme.bodyText2,*/
      ),
      tabBarTheme: const TabBarTheme(
        labelStyle: TextStyle(color: Colors.lightBlue, fontSize: 13),
        unselectedLabelStyle: TextStyle(fontSize: 10, color: Colors.grey),
        labelColor: Colors.lightBlue,
        unselectedLabelColor: Colors.grey,
      ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Mythemes.lightBluishColor,
    ),

    drawerTheme: DrawerThemeData(
      backgroundColor: Mythemes.whitish,
      shadowColor: Mythemes.lightBluishColor,
    )
  );

  static ThemeData darkTheme(BuildContext context) =>  ThemeData(
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.poppins().fontFamily,
      cardColor: Colors.black,
      canvasColor: darkCreamColor,
      appBarTheme: const AppBarTheme(
          color: Colors.black,
          elevation: 0.5,
          iconTheme: IconThemeData(
              color: Colors.white),
          /* textTheme: Theme.of(context).textTheme.copyWith(headline6: context.textTheme.headline6!.copyWith(color: Colors.white)),*/
          titleTextStyle: TextStyle(color: Colors.white , fontSize: 20, fontWeight: FontWeight.w400)
        /*  toolbarTextStyle: Theme.of(context).textTheme.bodyText2,*/
      ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black38,
      unselectedLabelColor: Colors.grey,
    )
  );


  //Colors
  static Color BluishColor = Color(0xff403b58);
  static Color VoiletColor = Color(0xff00b0ff);
  static Color lightBlue = Color(0xffe1f5fe);
  static Color blueShade = Colors.grey.shade200;
  static Color cyan = Color(0xB2FFFF);
  static Color darkCreamColor = Color(0x4FFFB0);
  static Color lightBluishColor = Colors.lightBlue;
  static Color creamColor = Color(0xfff5f5f5);
  static Color whiteShadeSeventy = Colors.white70;
  static Color whitish = Colors.white;
  static Color greyish = Colors.grey;
  static Color greyishade = Colors.grey.shade300;
  static Color greyLight = Colors.grey.shade200;
  static Color blackish = Colors.black54;
  static Color black = Colors.black87;
  static Color blackishade = Colors.black38;
  static Color purplish = Colors.purple.shade700;
  static Color deepPurple = Colors.deepPurple.shade700;
  static Color dangerColor = Colors.red;
  static Color dangerColorOne = Colors.redAccent;
  static Color warningColor = Color(0xfffcc44d);
  static Color successColor = Colors.green;
  static Color alertColor = Color(0xff967adc);
  static Color activeStepColor = Color(0xfff6bb42);
  static Color stepColor = Color(0xff41a6de);
}