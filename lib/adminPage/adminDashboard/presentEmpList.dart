import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/adminPage/modelClass/dashboardModel.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../../themes/empThemes.dart';
import '../../commanScreen/homePage.dart';
import '../../commanScreen/routes.dart';
import '../../profiles/profilePageWithHead.dart';


class PresentEmpList extends StatefulWidget {
  final DashboardModel dashboardModelGlobal;

  PresentEmpList(this.dashboardModelGlobal);

  @override
  State<PresentEmpList> createState() => _PresentEmpListState(dashboardModelGlobal);
}

class _PresentEmpListState extends State<PresentEmpList> {
  DashboardModel? dashboardModelGlobal;
  TextEditingController searchController = TextEditingController();
  List<PresentEmp> filteredEmployees = [];

  _PresentEmpListState(this.dashboardModelGlobal);

  @override
  void initState() {
    super.initState();
    // Initialize filtered list with all employees
    filteredEmployees = dashboardModelGlobal?.presentEmp ?? [];
    searchController.addListener(_filterEmployees);
  }

  void _filterEmployees() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredEmployees = dashboardModelGlobal!.presentEmp!
          .where((employee) =>
      employee.employeeName!.toLowerCase().contains(query) ||
          employee.branchName!.toLowerCase().contains(query) ||
          employee.deptName!.toLowerCase().contains(query))
          .toList();
    });
  }

  int pageIndex = 0;
  int currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Present Employees".text.make(),
        elevation: 0.5,
        actions: [
          "Total - ${dashboardModelGlobal!.presentEmp!.length}".text.size(14).bold.color(Mythemes.successColor).make().px(10)
        ],
      ),
      body: Column(
        children: [
          // 🔹 Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search employees...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),

          // 🔹 Display Filtered Employee List
          Expanded(
            child: dashboardModelGlobal == null
                ? Center(child: CircularProgressIndicator())
                : getPresentEmp(filteredEmployees),
          ),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          }
          if (index == 1) {
            Navigator.pushNamed(context, MyRoutings.timeAttRoute);
          }
          if (index == 2) {
            Navigator.pushNamed(context, MyRoutings.reportSectionHead);
          }
          if (index == 3) {
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
          }
          if (index == 4) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePageNew()));
          }
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pending_actions), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.doc_chart), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
    );
  }

  getPresentEmp(List<PresentEmp> employeeList) {
    return ListView.builder(
      padding: const EdgeInsets.all(4.0),
      itemCount: employeeList.length,
      itemBuilder: (context, index) {
        var employee = employeeList[index];
        var distance = employee.distance;

        return Card(
          elevation: 2,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    employee.employeeName!.text.make().px8().py4(),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          employee.date!.text.make().px8(),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    employee.branchName!.text.textStyle(context.captionStyle).make().px8(),
                  ],
                ),
                Row(
                  children: [
                    employee.deptName!.text.textStyle(context.captionStyle).make().px8(),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.touch_app, size: 35, color: Mythemes.lightBluishColor),
                      ],
                    ),
                    Column(
                      children: [
                        "In Time".text.sm.make(),
                        employee.inTime!.text.sm.make()
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                      child: Column(
                        children: [
                          Icon(Icons.touch_app, size: 35, color: Mythemes.dangerColor),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                      child: Column(
                        children: [
                          "Out Time".text.sm.make(),
                          employee.outTime!.text.sm.make()
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                      child: Column(
                        children: [
                          Icon(Icons.update, size: 35, color: Mythemes.lightBluishColor),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                      child: Column(
                        children: [
                          "Work Hours".text.sm.make(),
                          employee.workingHours!.text.sm.make()
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
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
