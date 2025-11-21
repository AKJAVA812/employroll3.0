import 'package:er_flutter_project/ess/EssDashboarrddModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/adminPage/modelClass/dashboardModel.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../../themes/empThemes.dart';
import '../../commanScreen/homePage.dart';
import '../../commanScreen/punchInOutScreen.dart';
import '../../commanScreen/routes.dart';
import '../../profiles/profilePageWithHead.dart';
import '../essDashboardNavigate.dart';
import '../myAllReports.dart';


class OnDutyEmpList extends StatefulWidget {
  final EssDashboarrdModel dashboardModelGlobal;

  OnDutyEmpList(this.dashboardModelGlobal);

  @override
  State<OnDutyEmpList> createState() => _OnDutyEmpListState(dashboardModelGlobal);
}
dynamic itemCount = "";
class _OnDutyEmpListState extends State<OnDutyEmpList> {
  EssDashboarrdModel? dashboardModelGlobal;

  _OnDutyEmpListState(this.dashboardModelGlobal);
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
        title: "Working Days".text.make(),
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
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 0,)));
            //Navigator.pop(context);
            print('home tab');
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 1,)));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if(index==2){
            /*Navigator.pushNamed(context, MyRoutings.timeAttRoute);
              print('Attendance');*/
          }
          if(index==3){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyAllReportsPage(showAppBar: true,)));
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('Dashboard');
          }
          if(index==4){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EssAdminDashboardHead(EssDashboarrdModel())));
            //Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => ProfilePageNew())
            // );
            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
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
    for(int i = 0; i < dashboardModelGlobal!.countData!.data!.length; i++) {
      itemCount = dashboardModelGlobal!.countData!.presentList!.length;
    }
    print("ItemCount - $itemCount");
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return InkWell(
         /* onTap: () {
            Navigator.pushNamed(context, MyRoutings.hdRaisedTicketReplyRoute);
          },*/
          child: Card(
              elevation: 2,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        dashboardModelGlobal!.countData!.presentList![index].empName!.text.make().px8().py4(),
                        Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                dashboardModelGlobal!.countData!.presentList![index].logDate!.text.make().px8(),
                              ],
                            )
                        )
                      ],
                    ),
                    Row(
                      children: [
                        dashboardModelGlobal!.countData!.presentList![index].branch!.text.textStyle(context.captionStyle).make().px8(),

                      ],
                    ),
                    Row(
                      children: [
                        dashboardModelGlobal!.countData!.presentList![index].dept!.text.textStyle(context.captionStyle).make().px8(),

                      ],
                    ),
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
                            dashboardModelGlobal!.countData!.presentList![index].inTime!.text.sm.make()
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
                              dashboardModelGlobal!.countData!.presentList![index].outTime!.text.sm.make()
                            ],
                          ),
                        ),
                        Padding(
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
                              dashboardModelGlobal!.countData!.presentList![index].workingHours!.text.sm.make()
                            ],
                          ),
                        ),
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
