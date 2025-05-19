import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/themes/empThemes.dart';

import '../commanScreen/punchInOutScreen.dart';
import '../commanScreen/routes.dart';
import '../sharedPrefancePage/ShardPre.dart';


class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
bool? setShowPayroll;
int? orgId;
//List<Data>? allUsernew=[];
//List<Data>? foundDataNew=[];
late List<String?> list = [];
String valuenew="listText";

var titleName = "Landing Page";
int value = 0;
var dropdownvalue;


class _LandingPageState extends State<LandingPage> {
  Future getSharedPrfanceList() async {

    sessionId = await shared.getSessionId();
    setShowPayroll = await shared.getShowPayroll();
    orgId = await shared.getOrgId();

    setState(() {

    });
  }

  @override
  void initState() {
    getSharedPrfanceList();

    super.initState();
  }

  int pageIndex = 0;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;

    // You can use these values to determine the size of your widget
    double widgetWidth = screenWidth * 0.03; // 80% of the screen width
    //double widgetHeight = screenHeight * 0.5; // 50% of the screen height
    double boxText = widgetWidth;
    timeDilation = 0.5;
    List<Widget> generateGridViewItems() {
      print("CheckOrg - $orgId");
      List<Widget> items = [];

      items.add(
        Hero(
          tag: 'reportAnimate',
          child: Card(
            color: Mythemes.whitish,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, MyRoutings.timeAttRoute);
              },
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.access_time_filled,
                      size: 50,
                      color: Mythemes.lightBluishColor,
                    ),
                    /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 75, left: 10),
                      padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                      child: Text(
                          'Attendance',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                          TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      items.add(
        Hero(
          tag: 'leaveReport',
          child: Card(
            color: Mythemes.whitish,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, MyRoutings.leaveManageReportRoute);
              },
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.calendar_month_rounded,
                      size: 50,
                      color: Mythemes.successColor,
                    ),
                    /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 75, left: 10),
                      padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                      child: Text(
                          'Leave',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                          TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      if(setShowPayroll == true) {
        items.add(
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, MyRoutings.documentsAddedRoute);
              /*Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
            },
            child: Hero(
              tag: 'e-doc',
              child: Card(
                //color: Mythemes.whiteShadeSeventy,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.document_scanner_sharp,
                        size: 50,
                        color: Mythemes.warningColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                          'E-Doc',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                          TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      items.add(
        Hero(
          tag: 'hrisReport',
          child: InkWell(
            onTap: () {
              /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
              Navigator.pushNamed(context, MyRoutings.hrDetailsRoute);
            },
            child: Card(
              color: Mythemes.whitish,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.supervised_user_circle,
                      size: 50,
                      color: Mythemes.alertColor,
                    ),
                    /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 75, left: 10),
                      padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                      child: Text(
                          'HRIS',
                          style:
                          TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      items.add(
        Hero(
          tag: 'odReport',
          child: Card(
            color: Mythemes.whitish,
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, MyRoutings.onDutyTypes);
                /*Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
              },
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.business_center,
                      size: 50,
                      color: Mythemes.dangerColorOne,
                    ),
                    /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 75, left: 10),
                      padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                      child: Text(
                          'OD',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                          TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      if(orgId == 3 || orgId == 145) {
        items.add(
          Hero(
            tag: 'claim',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.claimItemsListRoute);
                  /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.handshake_outlined,
                        size: 50,
                        color: Mythemes.warningColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Claim',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      if(orgId == 3 || orgId == 145) {
        items.add(
          Hero(
            tag: 'loanAdvanceReport',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.loanAdvanceRoute);
                  /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.currency_exchange,
                        size: 50,
                        color: Mythemes.lightBluishColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Loan',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      if(orgId == 3 || orgId == 145) {
        items.add(
          Hero(
            tag: 'helpdeskItems',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.helpDeskItemsRoute);
                  /*Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.support_agent_rounded,
                        size: 50,
                        color: Mythemes.warningColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Helpdesk',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }


      if(orgId == 3 || orgId == 145) {
        items.add(
          Hero(
            tag: 'tracking',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: (){
                  /* Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                  Navigator.pushNamed(context, MyRoutings.empListRoute);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.location_on,
                        size: 50,
                        color: Mythemes.dangerColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Tracking',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      if(orgId == 3 || orgId == 145) {
        items.add(
          Hero(
            tag: 'ocr',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, MyRoutings.ocrPageRoute);
                  /*Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.document_scanner_outlined,
                        size: 50,
                        color: Mythemes.activeStepColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'OCR',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      if(orgId == 3 || orgId == 145) {
        items.add(
          Hero(
            tag: 'face_recognition',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, MyRoutings.faceRecognitionHome);
                  /*Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.face_retouching_natural,
                        size: 50,
                        color: Mythemes.successColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Face Recognition',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }


      if(orgId == 3 || orgId == 145) {
        items.add(
          Hero(
            tag: 'visitorManage',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.visitorManageSections);
                  /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.approval,
                        size: 50,
                        color: Mythemes.alertColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Visitor ',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      if(orgId == 3 || orgId == 145) {
        items.add(
          Hero(
            tag: 'frontPage',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  //Navigator.pushNamed(context, MyRoutings.visitorManageSections);
                  Navigator.pushNamed(context, MyRoutings.landingPageRoute);
                  /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.new_releases_sharp,
                        size: 50,
                        color: Mythemes.warningColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'New',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      return items;
    }
    return Scaffold(
      appBar: AppBar(
        title: titleName.text.make(),
      ),
      body:  Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedToggleSwitch<int>.size(
                height: 30,
                current: min(value, 2),
                style: ToggleStyle(
                  backgroundColor: Mythemes.greyishade,
                  indicatorColor: Mythemes.lightBluishColor,
                  borderColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                  indicatorBorderRadius: BorderRadius.zero,
                ),
                values: const [0, 1],
                iconOpacity: 1.0,
                selectedIconScale: 1.0,
                indicatorSize: const Size.fromWidth(150),
                iconAnimationType: AnimationType.onHover,
                styleAnimationType: AnimationType.onHover,
                spacing: 2.0,
                customSeparatorBuilder: (context, local, global) {
                  final opacity =
                  ((global.position - local.position).abs() - 0.5)
                      .clamp(0.0, 1.0);
                  return VerticalDivider(
                      indent: 10.0,
                      endIndent: 10.0,
                      color: Colors.white38.withOpacity(opacity));
                },
                customIconBuilder: (context, local, global) {
                  final text = const ['ESS', 'MSS'][local.index];
                  return Center(
                      child: Text(text,
                          style: TextStyle(
                              color: Color.lerp(Colors.black, Colors.white,
                                  local.animationValue))));
                },
                borderWidth: 0.0,
                onChanged: (i) {
                  setState(() {
                    value = i;
                    print(i);

                  });
                },
              )
            ],
          ).py16(),
          Visibility(
            visible: value == 1,
            child: Form(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0, bottom: 20.0),
                      child: DropdownButtonFormField(
                        value: dropdownvalue,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                            borderSide: BorderSide(
                                width: 1, color: Mythemes.blackishade),
                          ),
                          //labelText: "Select Department",
                          hintText: "Profiles",
                          hintStyle: TextStyle(
                            fontSize: 14,
                          ),
                          contentPadding: EdgeInsets.all(10),
                          /*border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(8))),*/
                          // labelText: "Location",
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,fontSize: 13,
                              color: Mythemes.blackish),
                        ),
                        items: list.map<DropdownMenuItem<String>>((String? value) {
                          return DropdownMenuItem<String>(
                            alignment: Alignment.centerLeft,
                            value: value,
                            child: Text(value!),
                          );

                        }).toList(),
                        onChanged: (newVal) {
                          valuenew = newVal.toString();
                          int i =list.indexOf(valuenew);
                         // empNewIdRo = employeeListModelglobel?.data?[i].empId.toString();
                         // print("EmpId  $empNewIdRo");
                          setState(() {

                            dropdownvalue = newVal;

                          });
                        },

                      ),
                    ),
                  ],
                )
            ),
          ),

      Expanded(
        child: GridView.count(
          crossAxisCount: 3,
          children: generateGridViewItems(),
        ),
      ),
        ],
      ),
      bottomNavigationBar:
      BottomNavigationBar (
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        iconSize: 25,
        selectedFontSize: 12,
          unselectedFontSize: 10,
        onTap: (index) {

          if(index==0){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
            //Navigator.of(context, rootNavigator: true).pop();
            print('home tab');
          }
          if(index==1){
            Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Attendance');
          }
          if(index==2){
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Dashboard');
          }
          if(index==3){
            Navigator.pushNamed(context, MyRoutings.profileRoute);
            print('Profile');
          }
          /*if(index==3){
                title="Notifications";
              }*/
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
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
