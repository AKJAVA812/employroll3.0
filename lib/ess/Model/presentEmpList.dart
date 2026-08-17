import 'package:er_flutter_project/ess/EssDashboarrddModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../../themes/empThemes.dart';
import '../../commanScreen/punchInOutScreen.dart';
import '../essDashboardNavigate.dart';
import '../myAllReports.dart';


class PresentEmpList extends StatefulWidget {
  final EssDashboarrdModel dashboardModelGlobal;

  const PresentEmpList(this.dashboardModelGlobal, {super.key});


  @override
  State<PresentEmpList> createState() => _PresentEmpListState(dashboardModelGlobal);
}
class _PresentEmpListState extends State<PresentEmpList> {
  EssDashboarrdModel? dashboardModelGlobal;

  _PresentEmpListState(this.dashboardModelGlobal);
  @override
  void initState() {
    setState(() {
    });
    // TODO: implement initState
    super.initState();
  }

  int pageIndex = 0;
  int currentIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Attendance".text.make(),
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
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 0,)));
            //Navigator.pop(context);
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 1,)));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
          }
          if(index==2){
            /*Navigator.pushNamed(context, MyRoutings.timeAttRoute);
              print('Attendance');*/
          }
          if(index==3){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyAllReportsPage(showAppBar: true,)));
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
          }
          if(index==4){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EssAdminDashboardHead(EssDashboarrdModel())));
            //Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => ProfilePageNew())
            // );
            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
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
            icon: Icon(Icons.manage_accounts_outlined),
            label: 'Workflow',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.app_badge_fill),
            label: 'My Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_chart),
            label: 'My Reports',
            //backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
            //backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  getPresentEmp(EssDashboarrdModel dashboardModel){
    final attendanceRows = _attendanceRows(dashboardModel);
    return ListView.builder(
      padding: const EdgeInsets.all(4.0),
      itemCount: attendanceRows.length,
      itemBuilder: (context, itemCount) {
        final attendance = attendanceRows[itemCount];
        //var distance =dashboardModelGlobal!.presentEmp![itemCount].distance;


        return InkWell(
          onTap: () {
            //print('attendanceReport$dashboardModelGlobal!.data![itemCount]');
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
                        (attendance.empName ?? '').text.make().px8().py4(),
                        Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                (attendance.status ?? '').text.bold.size(16).color(Mythemes.successColor).make().px8(),
                                (attendance.logDate ?? '').text.make().px8(),
                              ],
                            )
                        )
                      ],
                    ),
                    Row(
                      children: [
                        (attendance.branch ?? '').text.textStyle(context.captionStyle).make().px8(),

                      ],
                    ),
                    Row(
                      children: [
                        (attendance.dept ?? '').text.textStyle(context.captionStyle).make().px8(),

                      ],
                    ),
                    _isPresent(attendance.status, attendance.statusCode) ?
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            (attendance.inTime ?? '--:--').text.sm.make()
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              Icon(
                                Icons.touch_app, size: 35, color: Mythemes.dangerColor,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              "Out Time".text.sm.make(),
                              (attendance.outTime ?? '--:--').text.sm.make()
                            ],
                          ),
                        ),
                      /*  Padding(
                          padding: const EdgeInsets.only(top:15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [
                              Icon(
                                Icons.update, size: 35, color: Mythemes.lightBluishColor,
                              ),
                            ],
                          ),
                        ),*/
                        /*Padding(
                          padding:  EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                          child: Column(
                            children: [

                              "Working Hours".text.sm.make(),
                              dashboardModelGlobal!.countData!.totalList![itemCount].workingHours!.text.sm.make()
                            ],
                          ),
                        ),*/
                      ],
                    ) :
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: Mythemes.lightBluishColor,
                                  child: (attendance.status ?? '').text.bold.center.color(Mythemes.whitish).make(),
                                ),
                              ),
                            )
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

  List<PresentList> _attendanceRows(EssDashboarrdModel dashboardModel) {
    final rows = <PresentList>[...?dashboardModel.countData?.presentList];
    final existingDates = rows
        .map((row) => '${row.empId ?? ''}|${row.logDate ?? ''}')
        .toSet();
    for (final row in dashboardModel.countData?.totalList ?? <TotalList>[]) {
      final rowKey = '${row.empId ?? ''}|${row.logDate ?? ''}';
      if (isAttendanceCardStatus(row.status, row.statusCode) &&
          !existingDates.contains(rowKey)) {
        rows.add(PresentList.fromJson(row.toJson()));
        existingDates.add(rowKey);
      }
    }
    rows.sort((left, right) => (left.logDate ?? '').compareTo(right.logDate ?? ''));
    return rows;
  }

  bool _isPresent(String? status, String? statusCode) {
    final value = '${status ?? ''} ${statusCode ?? ''}'
        .toLowerCase()
        .replaceAll('-', ' ')
        .replaceAll('_', ' ');
    return value.contains('present') ||
        const {'p', 'pp'}.contains((statusCode ?? '').trim().toLowerCase());
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
