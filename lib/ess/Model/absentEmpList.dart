import 'package:er_flutter_project/ess/EssDashboarrddModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../../themes/empThemes.dart';
import '../../commanScreen/homePage.dart';
import '../../commanScreen/routes.dart';
import '../../profiles/profilePageWithHead.dart';


class AbsentEmpList extends StatefulWidget {
  final EssDashboarrdModel dashboardModelGlobal;

  AbsentEmpList(this.dashboardModelGlobal);


  @override
  State<AbsentEmpList> createState() => _AbsentEmpListState(dashboardModelGlobal);
}
dynamic itemCount = "";
class _AbsentEmpListState extends State<AbsentEmpList> {
  EssDashboarrdModel? dashboardModelGlobal;

  _AbsentEmpListState(this.dashboardModelGlobal);
  @override
  void initState() {
    setState(() {
    });
    // TODO: implement initState
    super.initState();
  }

  int pageIndex = 0;
  int currentIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Absence".text.make(),
        elevation: 0.5,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context, delegate: SearchItems(),
                );

              }, icon: Icon(Icons.search))
        ],
      ),

      body: Container(
        color: context.canvasColor,
        child: Center(child: dashboardModelGlobal==null?CircularProgressIndicator():getPresentEmp(dashboardModelGlobal!)),
      ).p2(),

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
                MaterialPageRoute(builder: (context) => HomePage()));
            //Navigator.pop(context);
            print('home tab');
          }
          if(index==1){
            Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Attendance');
          }
          if(index==2){
            Navigator.pushNamed(context, MyRoutings.reportSectionHead);
            print('Reports');
          }
          if(index==3){
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('Dashboard');
          }
          if(index==4){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePageNew())
            );
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
            icon: Icon(CupertinoIcons.doc_chart),
            label: 'Reports',
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
  var empName = "";
  var onDate = "";
  var absentDate = "";
  var branch = "";
  var department = "";
  var status = "";
  var inTime = "";
  var outTime = "";
  var workHour = "";

  getPresentEmp(EssDashboarrdModel dashboardModel){

    print("Data Length - ${dashboardModelGlobal!.countData!.data!.length}");
 /*   for(int i = 0; i < dashboardModelGlobal!.countData!.data!.length; i++) {
      itemCount = dashboardModelGlobal!.countData!.absentList!.length;
      onDate = dashboardModelGlobal!.countData!.absentList![i].logDate!;
      print("My Absentees - $onDate");
    }*/

    //var distance =dashboardModelGlobal!.presentEmp![itemCount].distance;


    print("ItemCount - $itemCount");
    return ListView.builder(
      padding: const EdgeInsets.all(4.0),
      itemCount: dashboardModelGlobal!.countData!.absentList!.length,
      itemBuilder: (context, itemCount) {
        if (dashboardModelGlobal!.countData != null &&
            dashboardModelGlobal!.countData!.data!.isNotEmpty &&
            itemCount < dashboardModelGlobal!.countData!.data!.length &&
            dashboardModelGlobal!.countData!.absentList != null &&
            dashboardModelGlobal!.countData!.absentList!.isNotEmpty &&
            itemCount < dashboardModelGlobal!.countData!.absentList!.length) {
          for(int i = 0; i < dashboardModelGlobal!.countData!.absentList!.length; i++) {
            empName =  dashboardModelGlobal!.countData!.absentList![i].empName!.toString();
            branch =  dashboardModelGlobal!.countData!.absentList![i].branch!.toString();
            department =  dashboardModelGlobal!.countData!.absentList![i].dept!.toString();
            status =  dashboardModelGlobal!.countData!.absentList![i].status!.toString();
            inTime =  dashboardModelGlobal!.countData!.absentList![i].inTime!.toString();
            outTime =  dashboardModelGlobal!.countData!.absentList![i].outTime!.toString();
            //workHour =  dashboardModelGlobal!.countData!.absentList![i].workingHours!.toString();
            absentDate =  dashboardModelGlobal!.countData!.absentList![i].logDate!.toString();

            print("Absent Date- $absentDate");
          }
          print("Status - $status");
        } else {
          print("Invalid index or empty list.");
        }
        return InkWell(
          onTap: () {
            //print('attendanceReport$dashboardModelGlobal!');
            /* Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                AttendanceRequisition(attendanceModelGlobel,onDateAttModel,itemCount)));*/
          },
          child: Card(
              elevation: 2,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        dashboardModelGlobal!.countData!.absentList![itemCount].empName!.text.make().px8().py4(),
                        Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                dashboardModelGlobal!.countData!.absentList![itemCount].logDate!.toString().text.make().px8(),
                              ],
                            )
                        )
                      ],
                    ),
                    Row(
                      children: [
                        dashboardModelGlobal!.countData!.absentList![itemCount].branch!.text.textStyle(context.captionStyle).make().px8(),

                      ],
                    ),
                    Row(
                      children: [
                        dashboardModelGlobal!.countData!.absentList![itemCount].dept!.text.textStyle(context.captionStyle).make().px8(),

                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.touch_app, size: 35, color: Mythemes.lightBluishColor,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            "In Time".text.sm.make(),
                            dashboardModelGlobal!.countData!.absentList![itemCount].inTime!.text.sm.make()
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              Icon(
                                Icons.touch_app, size: 35, color: Mythemes.lightBluishColor,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              "Out Time".text.sm.make(),
                              dashboardModelGlobal!.countData!.absentList![itemCount].outTime!.text.sm.make()
                            ],
                          ),
                        ),
                        /*Padding(
                          padding: const EdgeInsets.only(top:15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              Icon(
                                Icons.update, size: 35, color: Mythemes.lightBluishColor,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [

                              "Working Hours".text.sm.make(),
                              workHour.text.sm.make()
                            ],
                          ),
                        ),*/
                      ],
                    )
                  ],
                ),
              )
          ),
        );
      },
    );
  }
}

class SearchItems extends SearchDelegate {

  List<String> searchTerms = [

  ];
  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
