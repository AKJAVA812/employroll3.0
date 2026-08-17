import 'package:er_flutter_project/modules/timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/services/mobile_api_foundation.dart';
import '../commanScreen/allAPIList.dart';
import '../commanScreen/punchInOutScreen.dart';
import '../main.dart';
import '../themes/empThemes.dart';
import 'EssDashboarrddModel.dart';
import 'Model/myManagersModalList.dart';
import 'essDashboardNavigate.dart';
import 'package:velocity_x/velocity_x.dart';

import 'myAllReports.dart';

class ReportingOfficersPage extends StatefulWidget {
  const ReportingOfficersPage({super.key});

  @override
  _ReportingOfficersPageState createState() => _ReportingOfficersPageState();
}

Map<String, dynamic> mapResponse = {};

List<ListData>? allUsernew = [];
List<ListData>? foundDataNew = [];
List<DottedEmpList>? allUsernewDotted = [];
List<SharedEmpList>? allUsernewShared = [];
List<DirectEmpList>? allUsernewDirect = [];
List<DesignatedEmpList>? allUsernewDesignated = [];
List<DottedEmpList>? foundDataNewDotted = [];
List<SharedEmpList>? foundDataNewShared = [];
List<DirectEmpList>? foundDataNewDirect = [];
List<DesignatedEmpList>? foundDataNewDesignated = [];

MyManagersModalList? myManagersModalListLabel;
MyManagersModalList? myManagersModalListLabeled;

class _ReportingOfficersPageState extends State<ReportingOfficersPage>
    with RouteAware {
  String selectedFilter = "Direct";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // âœ… Called when coming back from Form Page
    getSharedPrfanceList();
    super.didPopNext();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getSharedPrfanceList());
  }

  @override
  void didUpdateWidget(covariant ReportingOfficersPage oldWidget) {
    //getSharedPrfanceList();
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  Future getSharedPrfanceList() async {
    await getMyReportingOfficersList();
  }

  showNodata(BuildContext buildContext, result, reason) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Text(result),
        ],
      ),
      content: Text(reason),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(buildContext, rootNavigator: true).pop();
            Navigator.pop(buildContext);
            setState(() {});
          },
          child: Text("Ok"),
        ),
      ],
      elevation: 24.0,
    );
    showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  bool isLoadingCount = true;

  Future<MyManagersModalList> getMyReportingOfficersList() async {

    if (mounted) {
      setState(() {
      isLoadingCount = true; // âœ… Start loader before API
    });
    }

    try {
      final api = MobileApiFoundation.instance;
      final headers = await api.authHeaders(requestId: api.newRequestId());
      final response = await api.get(
        ApiDetails.mobileMyManagers,
        headers: headers,
        tag: 'MY_MANAGERS',
      );
      mapResponse = api.decodeMap(response.body);
      if (!api.isSuccess(response)) {
        throw MobileApiException(
          'MY_MANAGERS_FAILED',
          message:
              mapResponse['message']?.toString() ?? 'Unable to load managers',
        );
      }

      MyManagersModalList myManagersModalList = MyManagersModalList.fromJson(
        mapResponse,
      );
      if (mounted) {
        setState(() {
          allUsernew = myManagersModalList.listData ?? [];
          allUsernewDotted = myManagersModalList.dottedEmpList ?? [];
          allUsernewShared = myManagersModalList.sharedEmpList ?? [];
          allUsernewDirect = myManagersModalList.directEmpList ?? [];
          allUsernewDesignated = myManagersModalList.designatedEmpList ?? [];
          foundDataNew = allUsernew;
          foundDataNewDotted = allUsernewDotted;
          foundDataNewShared = allUsernewShared;
          foundDataNewDirect = allUsernewDirect;
          foundDataNewDesignated = allUsernewDesignated;
          myManagersModalListLabel = myManagersModalList;
          myManagersModalListLabeled = myManagersModalList;
        });
      }

      return myManagersModalList;
    } catch (e) {
      final errorMessage =
          e is MobileApiException
              ? (e.message ?? e.code)
              : 'Unable to load managers';
      final empty = MyManagersModalList(
        listData: [],
        directEmpList: [],
        dottedEmpList: [],
        sharedEmpList: [],
        designatedEmpList: [],
      );
      if (mounted) {
        setState(() {
          foundDataNew = [];
          foundDataNewDirect = [];
          foundDataNewDotted = [];
          foundDataNewShared = [];
          foundDataNewDesignated = [];
          myManagersModalListLabel = empty;
          myManagersModalListLabeled = empty;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
      return empty;
    } finally {
      if (mounted) {
        setState(() {
        isLoadingCount = false; // âœ… Always stop loader
      });
      }
    }
  }

  final List<Map<String, String>> officers = [
    {"name": "Rajesh Kumar", "type": "Direct", "level": "Level 1"},
    {"name": "Anita Sharma", "type": "Dotted", "level": "Level 2"},
    {"name": "Vikram Singh", "type": "Designated", "level": "Level 1"},
    {"name": "Priya Mehta", "type": "Shared", "level": "Level 3"},
  ];

  List<Map<String, String>> get filteredOfficers {
    if (selectedFilter == "All") return officers;
    return officers.where((o) => o["type"] == selectedFilter).toList();
  }

  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Managers",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        //backgroundColor: Colors.deepPurple,
        elevation: 3,
      ),

      /*body: Column(
        children: [
          // Filter buttons
          Container(
            padding: EdgeInsets.all(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  filterChip("All"),
                  filterChip("Direct"),
                  filterChip("Designated"),
                  filterChip("Shared"),
                  filterChip("Dotted"),
                ],
              ),
            ),
          ),
          Divider(thickness: 1),

          // List
          Expanded(
            child: ListView.builder(
              itemCount: filteredOfficers.length,
              itemBuilder: (context, index) {
                var officer = filteredOfficers[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: ListTile(
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    title: Text(
                      officer["name"]!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Type: ${officer["type"]}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple),
                        ),
                        SizedBox(height: 4),
                        Text(
                          officer["level"]!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple.shade100,
                      child: Icon(Icons.person, color: Colors.deepPurple),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),*/
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
              MaterialPageRoute(
                builder: (context) => PunchInOUtActivity(selectedIndex: 0),
              ),
            );
            //Navigator.of(context, rootNavigator: true).pop();
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PunchInOUtActivity(selectedIndex: 1),
              ),
            );
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GetAttendanceDet(showAppBar: true),
              ),
            );

          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyAllReportsPage(showAppBar: true),
              ),
            );

            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
          }
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => EssAdminDashboardHead(EssDashboarrdModel()),
              ),
            );
            /* Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePageNew())
            );*/
            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
          }
          /*if(index==3){
                title="Notifications";
              }*/
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
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

      body: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(6.0),
            crossAxisCount: 5,
            children: <Widget>[
              Hero(
                tag: 'nrCount',
                child: Card(
                  color: Mythemes.alertColor,
                  child: InkWell(
                    onTap: () {
                      setState(() => selectedFilter = "All");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child:
                              isLoadingCount
                                  ? CircularProgressIndicator(
                                    color: Mythemes.whitish,
                                  ) // Loader when fetching data
                                  : "${myManagersModalListLabel?.listData?.length ?? 0}"
                                      .text
                                      .bold
                                      .color(Mythemes.whitish)
                                      .size(16)
                                      .make(),
                        ),
                        Center(
                          child: Container(
                            //margin: EdgeInsets.only(top: 30, left: 10),
                            //padding: EdgeInsets.fromLTRB(2, 5, 10, 5),
                            child: Text(
                              'Total',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: Mythemes.whitish,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Hero(
                tag: 'WR',
                child: Card(
                  color: Mythemes.lightBluishColor,
                  child: InkWell(
                    onTap: () {
                      setState(() => selectedFilter = "Direct");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child:
                              isLoadingCount
                                  ? CircularProgressIndicator(
                                    color: Mythemes.whitish,
                                  ) // Loader when fetching data
                                  : "${myManagersModalListLabel?.directEmpList?.length ?? 0}"
                                      .text
                                      .bold
                                      .color(Mythemes.whitish)
                                      .size(16)
                                      .make(),
                        ),
                        Center(
                          child: Container(
                            //margin: EdgeInsets.only(top: 70, left: 10),
                            //padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                              'Direct',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: Mythemes.whitish,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Hero(
                tag: 'AP',
                child: Card(
                  color: Mythemes.warningColor,
                  child: InkWell(
                    onTap: () {
                      setState(() => selectedFilter = "Shared");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child:
                              isLoadingCount
                                  ? CircularProgressIndicator(
                                    color: Mythemes.whitish,
                                  ) // Loader when fetching data
                                  : "${myManagersModalListLabel?.sharedEmpList?.length ?? 0}"
                                      .text
                                      .bold
                                      .color(Mythemes.whitish)
                                      .size(16)
                                      .make(),
                        ),
                        Center(
                          child: Container(
                            //margin: EdgeInsets.only(top: 70, left: 10),
                            //padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                              'Shared',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: Mythemes.whitish,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Hero(
                tag: 'PR',
                child: Card(
                  color: Mythemes.successColor,
                  child: InkWell(
                    onTap: () {
                      setState(() => selectedFilter = "Dotted");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child:
                              isLoadingCount
                                  ? CircularProgressIndicator(
                                    color: Mythemes.whitish,
                                  ) // Loader when fetching data
                                  : "${myManagersModalListLabel?.dottedEmpList?.length ?? 0}"
                                      .text
                                      .bold
                                      .color(Mythemes.whitish)
                                      .size(16)
                                      .make(),
                        ),
                        Center(
                          child: Container(
                            //margin: EdgeInsets.only(top: 70, left: 10),
                            //padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                              'Dotted',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: Mythemes.whitish,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Hero(
                tag: 'Designated',
                child: Card(
                  color: Mythemes.lightBluishColor,
                  child: InkWell(
                    onTap: () {
                      setState(() => selectedFilter = "Designated");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child:
                              isLoadingCount
                                  ? CircularProgressIndicator(
                                    color: Mythemes.whitish,
                                  ) // Loader when fetching data
                                  : "${myManagersModalListLabel?.designatedEmpList?.length ?? 0}"
                                      .text
                                      .bold
                                      .color(Mythemes.whitish)
                                      .size(16)
                                      .make(),
                        ),
                        Center(
                          child: Container(
                            //margin: EdgeInsets.only(top: 70, left: 10),
                            //padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                              'Assigned',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: Mythemes.whitish,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child:
                isLoadingCount
                    ? Center(child: CircularProgressIndicator()) // Show loader
                    : myManagersModalListLabeled == null
                    ? Center(child: Text("No Data Available"))
                    : getManagersContent(),
          ),
        ],
      ),
    );
  }

  Widget getManagersContent() {
    final managers = _selectedManagers();
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                filterChip("All"),
                filterChip("Direct"),
                filterChip("Shared"),
                filterChip("Dotted"),
                filterChip("Designated"),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await getSharedPrfanceList();
            },
            child:
                managers.isEmpty
                    ? LayoutBuilder(
                      builder: (context, constraints) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: constraints.maxHeight,
                              child: const Center(
                                child: Text("No managers mapped"),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                    : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      itemCount: managers.length,
                      itemBuilder: (context, index) {
                        final dynamic manager = managers[index];
                        final name = _managerText(
                          manager.reportingOfficerName,
                          "Manager",
                        );
                        final type = _managerType(manager.reportieeType);
                        final profile = _managerText(
                          manager.profileName,
                          "Profile not assigned",
                        );
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple.shade100,
                              child: const Icon(
                                Icons.person,
                                color: Colors.deepPurple,
                              ),
                            ),
                            title: Text(
                              name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    type,
                                    style: const TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    profile,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ),
      ],
    );
  }

  List<dynamic> _selectedManagers() {
    switch (selectedFilter) {
      case "All":
        return List<dynamic>.from(foundDataNew ?? const <ListData>[]);
      case "Shared":
        return List<dynamic>.from(
          foundDataNewShared ?? const <SharedEmpList>[],
        );
      case "Dotted":
        return List<dynamic>.from(
          foundDataNewDotted ?? const <DottedEmpList>[],
        );
      case "Designated":
        return List<dynamic>.from(
          foundDataNewDesignated ?? const <DesignatedEmpList>[],
        );
      case "Direct":
      default:
        return List<dynamic>.from(
          foundDataNewDirect ?? const <DirectEmpList>[],
        );
    }
  }

  String _managerText(Object? value, String fallback) {
    final text = value?.toString().trim() ?? "";
    return text.isEmpty || text.toLowerCase() == "null" ? fallback : text;
  }

  String _managerType(Object? value) {
    final type = _managerText(value, "Manager").toUpperCase();
    switch (type) {
      case "SHARED_SERVICES":
        return "Shared Manager";
      case "DIRECT":
        return "Direct Manager";
      case "DOTTED":
        return "Dotted Manager";
      case "DESIGNATED":
        return "Designated Manager";
      default:
        return type;
    }
  }

  getMyReportings(MyManagersModalList myManagersModalList) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (a, b, c) => ReportingOfficersPage(),
            transitionDuration: Duration(seconds: 1),
            maintainState: true,
          ),
        );
        return Future.value(false);
      },
      child: Column(
        children: [
          // Filter buttons
          Container(
            padding: EdgeInsets.all(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  filterChip("All"),
                  filterChip("Direct"),
                  filterChip("Shared"),
                  filterChip("Dotted"),
                  filterChip("Designated"),
                ],
              ),
            ),
          ),
          Divider(thickness: 1),

          // List
          Visibility(
            visible: selectedFilter == "All",
            child: Expanded(
              child: ListView.builder(
                itemCount: foundDataNew!.length,
                itemBuilder: (context, index) {
                  var officer = foundDataNew![index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      title: Text(
                        foundDataNew![index].reportingOfficerName.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type: ${foundDataNew![index].reportieeType.toString()}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            foundDataNew![index].profileName.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Icon(Icons.person, color: Colors.deepPurple),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Visibility(
            visible: selectedFilter == "Direct",
            child: Expanded(
              child: ListView.builder(
                itemCount: foundDataNewDirect!.length,
                itemBuilder: (context, index) {
                  var officer = foundDataNewDirect![index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      title: Text(
                        foundDataNewDirect![index].reportingOfficerName
                            .toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type: ${foundDataNewDirect![index].reportieeType.toString()}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            foundDataNewDirect![index].profileName.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Icon(Icons.person, color: Colors.deepPurple),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Visibility(
            visible: selectedFilter == "Designated",
            child: Expanded(
              child: ListView.builder(
                itemCount: foundDataNewDesignated!.length,
                itemBuilder: (context, index) {
                  var officer = foundDataNewDesignated![index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      title: Text(
                        foundDataNewDesignated![index].reportingOfficerName
                            .toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type: ${foundDataNewDesignated![index].reportieeType.toString()}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            foundDataNewDesignated![index].profileName
                                .toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Icon(Icons.person, color: Colors.deepPurple),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Visibility(
            visible: selectedFilter == "Shared",
            child: Expanded(
              child: ListView.builder(
                itemCount: foundDataNewShared!.length,
                itemBuilder: (context, index) {
                  var officer = foundDataNewShared![index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      title: Text(
                        foundDataNewShared![index].reportingOfficerName
                            .toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type: ${foundDataNewShared![index].reportieeType.toString()}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            foundDataNewShared![index].profileName.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Icon(Icons.person, color: Colors.deepPurple),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Visibility(
            visible: selectedFilter == "Dotted",
            child: Expanded(
              child: ListView.builder(
                itemCount: foundDataNewDotted!.length,
                itemBuilder: (context, index) {
                  var officer = foundDataNewDotted![index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      title: Text(
                        foundDataNewDotted![index].reportingOfficerName
                            .toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type: ${foundDataNewDotted![index].reportieeType.toString()}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            foundDataNewDotted![index].profileName.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Icon(Icons.person, color: Colors.deepPurple),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        checkmarkColor: selectedFilter == label ? Colors.white : Colors.black87,
        label: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selectedFilter == label ? Colors.white : Colors.black87,
          ),
        ),
        selected: selectedFilter == label,
        selectedColor: Colors.deepPurple,
        onSelected: (val) {
          setState(() {
            selectedFilter = label;
          });
        },
      ),
    );
  }
}
