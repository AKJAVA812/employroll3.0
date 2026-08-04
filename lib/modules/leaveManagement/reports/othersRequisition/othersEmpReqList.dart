import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../profiles/profilePageWithHead.dart';
import 'package:badges/badges.dart' as badges;

class OthersRequisitionList extends StatefulWidget {
  OthersRequisitionList({Key? key}) : super(key: key);

  @override
  State<OthersRequisitionList> createState() => _OthersRequisitionListState();
}


class _OthersRequisitionListState extends State<OthersRequisitionList> {
  var titleName = "Leave Requisition List";
  int pageIndex = 0;
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleName.text.make(),
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
        child: Center(
            child:
            RequestedLeaveList()
        ),
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
                MaterialPageRoute(builder: (context) => HomePage()));
            //Navigator.of(context, rootNavigator: true).pop();
            print('home tab');
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if(index==2){
            Navigator.pushNamed(context, MyRoutings.leaveManageReportRoute);
            print('Leave');
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
            icon: Icon(Icons.group_off),
            label: 'Leave',
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


class RequestedLeaveList extends StatefulWidget {
  RequestedLeaveList();


  @override
  State<RequestedLeaveList> createState() => _RequestedLeaveListState();
}

class _RequestedLeaveListState extends State<RequestedLeaveList> {

  _RequestedLeaveListState();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(4.0),
      itemCount: 2,
      itemBuilder: (context, itemCount) {
        return InkWell(
            onTap: (){
              Navigator.pushNamed(context, MyRoutings.approveDisapproveLeaveReqRoute);
            },
            child: Card(
                elevation: 2,
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          "Employee Name".text.make().px8().py4(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  badges.Badge(
                                    badgeContent: Text('3'),
                                    child: Icon(Icons.settings),
                                  ).px16().py4()
                                ],
                              )
                          )

                        ],
                      ),
                      Row(
                        children: [
                          "Casual Leave".text.textStyle(context.captionStyle).make().px8(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  "Pending".text.make().px8(),
                                ],
                              )
                          )
                        ],
                      ),
                      Row(
                        children: [
                          "Multiple Day".text.textStyle(context.captionStyle).make().px8(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              "Start Date".text.sm.make(),
                              "10-05-2022".text.sm.make()
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                            child: Column(
                              children: [
                                "End Date".text.sm.make(),
                                "18-05-2022".text.sm.make()
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              "In Time".text.sm.make(),
                              "10:00".text.sm.make()
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                            child: Column(
                              children: [
                                "Out Time".text.sm.make(),
                                "18:30".text.sm.make()
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
            )

          /*  .badge(
              color: Mythemes.lightBluishColor ,
              size: 25 ,
              count: 8,
              position: VxBadgePosition.rightTop,
              textStyle: TextStyle(
                  fontSize: 14,
                  color: Mythemes.whitish)

          ),*/
        );
      },
    );
  }
}

