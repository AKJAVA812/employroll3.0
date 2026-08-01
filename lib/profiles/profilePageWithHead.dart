import 'package:flutter/material.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../adminPage/modelClass/dashboardModel.dart';
import '../adminPage/mssDashboard.dart';
import '../commanScreen/punchInOutScreen.dart';
import '../commanScreen/routes.dart';
import '../sharedPrefancePage/ShardPre.dart';
import '../utils/profile_image_provider.dart';

class ProfilePageNew extends StatefulWidget {
  const ProfilePageNew({Key? key}) : super(key: key);

  @override
  State<ProfilePageNew> createState() => _ProfilePageNewState();
}

SessionManager shared = SessionManager();

class _ProfilePageNewState extends State<ProfilePageNew> {
  late String name = " ",
      designation = "",
      mobileNo = "",
      emailId = "",
      dept = "",
      branch = "",
      dateOfBirth = "",
      urlImage = "";
  Future getUserDetails() async {
    urlImage = await shared.getProfileImage();
    name = await shared.getempName();
    emailId = await shared.getEmailId();
    dept = await shared.getDept();
    branch = await shared.getBranch();
    dateOfBirth = await shared.getDob();
    mobileNo = await shared.getMobileNo();
    designation = await shared.getDesignation();
    if (dateOfBirth.isNotEmpty) {
      try {
        String formattedDate = DateFormat(
          "dd-MM-yyyy",
        ).format(DateFormat("dd-MM-yyyy").parse(dateOfBirth));

        // Use formattedDate in your widget
        Container(child: formattedDate.text.letterSpacing(1).bold.make());
      } catch (e) {
        print('Error parsing dateOfBirth: $e');
        // Handle error, e.g., show a default message or placeholder
        Container(child: Text('Invalid date format').text.bold.make());
      }
    } else {
      // Handle the case when dateOfBirth is empty or null
      Container(child: Text('Date of birth not provided').text.bold.make());
    }

    print('profilePage: ${urlImage}');
    print('profilePage: ${name}');
    print('profilePage: ${emailId}');
    print('profilePage: ${dept}');
    print('profilePage: ${branch}');
    print('profilePage: ${dateOfBirth}');
    print('profilePage: ${mobileNo}');
    print('profilePage: ${designation}');
    setState(() {});
  }

  @override
  void initState() {
    getUserDetails();
    // TODO: implement initState
    super.initState();
  }

  int pageIndex = 0;
  int currentIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.5, title: "Profile".text.make()),
      /* body: Container(
        color: context.canvasColor,
        child: Center(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                SizedBox(
                  height: 45,
                ),
                CircleAvatar(
                  maxRadius: 65,
                  backgroundImage: AssetImage("assets/images/avtar7.png"),
                ).h15(context),

                Expanded(child: VxArc(
                  height: 40.0,
                  edge: VxEdge.TOP,
                  arcType: VxArcType.CONVEX,
                  child: Container(
                    color: context.cardColor,
                    width: context.screenWidth,
                    child: Column(
                      children: [
                        "Bharat Rajora".text.xl2.color(context.accentColor).make(),
                        "Designer".text.textStyle(context.captionStyle).make(),
                      ],
                    ),
                  ),
                ))

              ],
            ),
          ),
        ),
      ),*/
      body: Stack(
        alignment: Alignment.center,
        children: [
          /*Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 450,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                ),
              )
            ],
          ),*/
          /*CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            //painter: CurvedHeaderContainer(),
          ),*/
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),

                  // child: "Profile".text.make(),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Mythemes.lightBluishColor,
                      width: 3,
                    ),
                    shape: BoxShape.circle,
                    color: Mythemes.whitish,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: profileImageProvider(urlImage),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      children: [
                        name.text.xl2.make(),
                        designation.text.textStyle(context.captionStyle).make(),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Container(
                        height: 68,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.email,
                                  size: 25,
                                  color: Mythemes.lightBluishColor,
                                ).py16(),
                              ],
                            ).px16(),
                            Expanded(
                              child:
                                  Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child:
                                              "Email Id".text
                                                  .align(TextAlign.left)
                                                  .color(Mythemes.greyish)
                                                  .make(),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child:
                                              emailId.text
                                                  .letterSpacing(1)
                                                  .bold
                                                  .make(),
                                        ),
                                      ),
                                    ],
                                  ).px8(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 68,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 25,
                                  color: Mythemes.lightBluishColor,
                                ).py16(),
                              ],
                            ).px16(),
                            Expanded(
                              child:
                                  Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child:
                                              "Mobile No.".text
                                                  .align(TextAlign.left)
                                                  .color(Mythemes.greyish)
                                                  .make(),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child:
                                              mobileNo.text
                                                  .letterSpacing(1)
                                                  .bold
                                                  .make(),
                                        ),
                                      ),
                                    ],
                                  ).px8(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 68,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.work,
                                  size: 25,
                                  color: Mythemes.lightBluishColor,
                                ).py16(),
                              ],
                            ).px16(),
                            Expanded(
                              child:
                                  Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child:
                                              "Department".text
                                                  .align(TextAlign.left)
                                                  .color(Mythemes.greyish)
                                                  .make(),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child:
                                              dept.text
                                                  .letterSpacing(1)
                                                  .bold
                                                  .make(),
                                        ),
                                      ),
                                    ],
                                  ).px8(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 68,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.apartment,
                                  size: 25,
                                  color: Mythemes.lightBluishColor,
                                ).py16(),
                              ],
                            ).px16(),
                            Expanded(
                              child:
                                  Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child:
                                              "Branch".text
                                                  .align(TextAlign.left)
                                                  .color(Mythemes.greyish)
                                                  .make(),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child:
                                              branch.text
                                                  .letterSpacing(1)
                                                  .bold
                                                  .make(),
                                        ),
                                      ),
                                    ],
                                  ).px8(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 68,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  size: 25,
                                  color: Mythemes.lightBluishColor,
                                ).py16(),
                              ],
                            ).px16(),
                            Expanded(
                              child:
                                  Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child:
                                              "Date Of Birth".text
                                                  .align(TextAlign.left)
                                                  .color(Mythemes.greyish)
                                                  .make(),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child:
                                              (dateOfBirth.isNotEmpty)
                                                  ? (() {
                                                    try {
                                                      return DateFormat(
                                                            "dd-MM-yyyy",
                                                          )
                                                          .format(
                                                            DateFormat(
                                                              "dd-MM-yyyy",
                                                            ).parse(
                                                              dateOfBirth,
                                                            ),
                                                          )
                                                          .text
                                                          .letterSpacing(1)
                                                          .bold
                                                          .make();
                                                    } catch (e) {
                                                      print(
                                                        'Error parsing dateOfBirth: $e',
                                                      );
                                                      return Text(
                                                        'Invalid date format',
                                                      ).text.bold.make();
                                                    }
                                                  }())
                                                  : Text(
                                                    'Date of birth not provided',
                                                  ).text.bold.make(),
                                        ),
                                      ),
                                    ],
                                  ).px8(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /*Padding(padding: EdgeInsets.only(bottom: 270, left: 184),
            child: CircleAvatar(
              backgroundColor: Mythemes.blackish,
              child: IconButton(
                icon: Icon(
                    Icons.edit,
                  color: Mythemes.whitish,
                ),
                onPressed: () {},

              ),
            ),

          ),*/
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        iconSize: 25,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PunchInOUtActivity()),
            );
            //Navigator.pop(context);
            print('home tab');
          }
          if (index == 1) {
            Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Attendance');
          }
          if (index == 2) {
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('Dashboard');
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePageNew()),
            );
            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
            print('Profile');
          }
          /*if(index==3){
                title="Notifications";
              }*/
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize),
            label: 'Dashboard',
            //backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            //backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class CurvedHeaderContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xff00b0ff);
    Path path =
        Path()
          ..relativeLineTo(0, 130)
          ..quadraticBezierTo(size.width / 2, 225, size.width, 130)
          ..relativeLineTo(0, -150)
          ..close();
    canvas.drawPath(path, paint);

    @override
    bool shouldRepaint(CustomPainter oldDelegate) => false;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
