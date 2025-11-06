import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/modules/leaveManagement/reports/modalClass/pendingLeaveRequisitionModal.dart';
import 'package:er_flutter_project/modules/leaveManagement/reports/pendingRequisition/pendingLeaveApprovalDis.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../main.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;

import '../../modules/leaveManagement/reports/leaveManageReport.dart';

class UIS_PendingLeaveRequisitionList extends StatefulWidget {
  final PendingLeaveRequisitionModal pendingLeaveRequisitionModal;
  const UIS_PendingLeaveRequisitionList(this.pendingLeaveRequisitionModal);


  @override
  State<UIS_PendingLeaveRequisitionList> createState() => _UIS_PendingLeaveRequisitionListState(pendingLeaveRequisitionModal);
}
Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
List<Data>? allUsernew=[];
List<Data>? foundDataNewUIS=[];
String? userPanel;
dynamic getProfileId;
String? levelOne;
String? levelTwo;
PendingLeaveRequisitionModal? pendingLeaveReqLabel;
PendingLeaveRequisitionModal? pendingLeaveReqLabeled;

class _UIS_PendingLeaveRequisitionListState extends State<UIS_PendingLeaveRequisitionList> with RouteAware{
  final PendingLeaveRequisitionModal pendingLeaveRequisitionModal;
  _UIS_PendingLeaveRequisitionListState(this.pendingLeaveRequisitionModal);

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
    // ✅ Called when coming back from Form Page
    getSharedPrfanceList();
    super.didPopNext();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getSharedPrfanceList();
      var listLength;
      listLength = foundDataNewUIS!.length;
      print('listLength $listLength');
    });
  }

  showNodata(BuildContext buildContext, result,reason) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0),
          )
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
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pop(buildContext);
            setState(() {

            });
          },
          child: Text("Ok"),
        )
      ],
      elevation: 24.0,
    );
    showDialog(
        context:buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    userPanel = await shared!.getUserPanel();
    getProfileId = await shared!.getDefaultProfileId();
    levelOne = await shared!.getLevelOne();
    levelTwo = await shared!.getLevelTwo();
    print("Level 1 - $levelOne");
    print("Level 2 - $levelTwo");
    // await Future.delayed(Duration(seconds: 5));
    Future<PendingLeaveRequisitionModal> getAppReq11 = getPendingLeaveReq(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    getAppReq11.then((value) {
      setState(() {
        foundDataNewUIS = allUsernew;
        pendingLeaveReqLabel=value;
        pendingLeaveReqLabeled=pendingLeaveReqLabel;
        if(foundDataNewUIS != null) {
          foundDataNewUIS!.length;
          print("Fetch data $foundDataNewUIS");
        } else {
          Center(
            child: "There is no data available right now".text.make(),
          );
          foundDataNewUIS = [];
        }
      });
      //print('employeeList00${pendingLeaveReqLabel!.result!.data!.length}');
    });
  }

  Future<PendingLeaveRequisitionModal> getPendingLeaveReq(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.pendingLeaveReqList;
    print('employeeList11: ${SessionId}');
    PendingLeaveRequisitionModal pendingLeaveRequisitionModal;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$SessionId&"
        "profileId=$getProfileId&"
        "userPermission=$userPanel&"
        "orgId=0");
    final response = await http.post(urlapi);
    print('URL ${response.request}');
    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['result']['data'];
    print("My Data - $getData");
    if (getData == null )  {
      print("getData111 $getData");
      showNodata(context, "Oops", "There is no any requisition.");
    }
    print('responseemployeeList $getData');
    pendingLeaveRequisitionModal=PendingLeaveRequisitionModal.fromJson(mapResponse);

    allUsernew = pendingLeaveRequisitionModal.result!.data;

    return pendingLeaveRequisitionModal;
  }

  var titleName = "Leave Requisition List";
  TextEditingController searchType = TextEditingController();

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<Data>?  results = [];

    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      //results = _allUsers;
      setState(() {
        results = allUsernew;
      });
    } else {
      /*results = allUsernew.where((user) =>
        user!.data!.contains(enteredKeyword.toLowerCase()))
          .toList();*/

      results = allUsernew?.where((element) =>
          element.employeeName!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      /*for(int i=0; i<inductionListLabel!.data!.length;i++){
        if(inductionListLabel!.data![i].empName!.toLowerCase().contains(enteredKeyword.toLowerCase())){
          // Refresh the UI
          setState(() {
            inductionListLabeldd=inductionResult;
          });
        }*/
    }
    // we use the toLowerCase() method to make it case-insensitive
    setState(() {
      foundDataNewUIS = results;
    });
  }

  void showAttachmentBottomSheet(BuildContext context, String attachmentUrl) {
    // Clean up any "File:" prefix accidentally passed
    attachmentUrl = attachmentUrl.replaceAll("File: '", "").replaceAll("'", "");

    final isPdf = attachmentUrl.toLowerCase().endsWith('.pdf');
    final isImage = attachmentUrl.toLowerCase().endsWith('.jpg') ||
        attachmentUrl.toLowerCase().endsWith('.jpeg') ||
        attachmentUrl.toLowerCase().endsWith('.png');

    final isLocalFile = attachmentUrl.startsWith('/') || attachmentUrl.startsWith('file://');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("View Attachment",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),

            Expanded(
              child: isPdf
                  ? SfPdfViewer.network(attachmentUrl)
                  : isImage
                  ? (isLocalFile
                  ? Image.file(
                File(attachmentUrl),
                fit: BoxFit.contain,
              )
                  : CachedNetworkImage(
                imageUrl: attachmentUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Center(
                    child: Text("❌ Failed to load image")),
              ))
                  : const Center(
                child: Text(
                  "⚠️ Unsupported file format",
                  style:
                  TextStyle(fontSize: 16, color: Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int pageIndex = 0;
  int currentIndex = 2;
  int value = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(color: Colors.white, border: Border(
                top: BorderSide.none
            ), boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 0.5,
                  spreadRadius: 0,
                  offset: Offset(0, 0.2))
            ]),
            child: AnimationSearchBar(
                searchFieldDecoration: BoxDecoration(
                  color: Mythemes.greyishade,
                  borderRadius: BorderRadius.circular(20),
                ),
                backIcon: Icons.arrow_back_ios,
                backIconColor: Mythemes.black,
                previousScreen:  LeaveManageReports(),
                textStyle: TextStyle(fontSize: 14),
                onChanged: (value) {
                  _runFilter(value);
                },
                horizontalPadding: 8,
                searchIconColor: Mythemes.black,
                centerTitle: titleName,
                verticalPadding: 3,
                centerTitleStyle: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Mythemes.black),
                searchTextEditingController: searchType),
          ),
        ),
      ),

      body: Container(
        color: context.canvasColor,
        child:
            Column(
              children: [
                Visibility(
                  visible: levelOne == "true",
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedToggleSwitch<int>.size(
                        height: 30,
                        current: min(value, 3),
                        style: ToggleStyle(
                          backgroundColor: Mythemes.greyishade,
                          indicatorColor: Mythemes.lightBluishColor,
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                          indicatorBorderRadius: BorderRadius.zero,
                        ),
                        values: const [0, 1, 2],
                        iconOpacity: 1.0,
                        selectedIconScale: 1.0,
                        indicatorSize: const Size.fromWidth(90),
                        iconAnimationType: AnimationType.onHover,
                        styleAnimationType: AnimationType.onHover,
                        spacing: 10.0,
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
                          final text = const ['Pending', 'Level One', 'Level Two'][local.index];
                          return Center(
                              child: Text(text,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.lerp(Colors.black, Colors.white,
                                          local.animationValue))));
                        },
                        borderWidth: 0.0,
                        onChanged: (i) {
                          setState(() {
                            value = i;
                            print(i);

                          });

                          if(value == 0) {
                            Navigator.pushNamed(context, MyRoutings.uisPendingLeaveRequestRoute);
                            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                          }
                          if(value == 1) {
                            Navigator.pushNamed(context, MyRoutings.uisLevelOnePendingReqRoute);
                          }
                           if(value == 2) {
                             Navigator.pushNamed(context, MyRoutings.uisLevelTwoPendingReqRoute);
                          }
                        },
                      )
                    ],
                  ).py(6),
                ),

                Expanded(child:
                pendingLeaveReqLabeled == null ?
                Center(
                    child: CircularProgressIndicator()):
                getPendingLeaveReqList(pendingLeaveReqLabeled!),
                )
              ],
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
                MaterialPageRoute(builder: (context) => HomePage(selectedIndex: 0,)));
            //Navigator.of(context, rootNavigator: true).pop();
            print('home tab');
          }
          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PunchInOUtActivity(selectedIndex: 1,)));
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

  getPendingLeaveReqList(PendingLeaveRequisitionModal pendingLeaveRequisitionModal) {
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (a, b, c) =>
                  UIS_PendingLeaveRequisitionList(PendingLeaveRequisitionModal()),
              transitionDuration: Duration(seconds: 1),
              maintainState: true,
            ));
        return Future.value(false);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: foundDataNewUIS!.length,
        itemBuilder: (context, index) {
          final item = foundDataNewUIS![index];
          return InkWell(
            onTap: (){
              print(foundDataNewUIS!.length);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PendingLeaveApproveDisapprove(
                  pendingLeaveRequisitionModal, index)));
              //Navigator.pushNamed(context, MyRoutings.pendingLeaveAppDisRoute);
              //CommonNotificationPage.showDeleteMessage(context, context, context);
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Employee Name + Status Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.blueAccent, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              item.employeeName.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: item.status.toString().toLowerCase() == 'pending'
                                ? Colors.orange.withOpacity(0.2)
                                : Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: Text(
                            item.status.toString(),
                            style: TextStyle(
                              color: item.status.toString().toLowerCase() == 'pending'
                                  ? Colors.orange
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    /// Leave Type + Length
                    Row(
                      children: [
                        const Icon(Icons.work_outline,
                            color: Colors.indigoAccent, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "${item.leaveType} (${item.leaveLength})",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// Dates row (Start - End - In - Out)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildDateColumn("Start Date", item.startDate.toString()),
                          _buildDateColumn("End Date", item.endDate.toString()),
                          //_buildDateColumn("In Time", "00:00"),
                          //_buildDateColumn("Out Time", "00:00"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Attachment Row
                    Visibility(
                      visible: item.document != null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          "View Attachment".text.bold.color(Mythemes.lightBluishColor).make(),
                          IconButton(
                            tooltip: "View Attachment",
                            icon: const Icon(
                              Icons.attach_file,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () {
                              print("Attachment tapped for ${item.employeeName}");
                              if (item.document != null &&
                                  item.document.toString().isNotEmpty) {
                                showAttachmentBottomSheet(
                                    context, item.document.toString());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("No attachment available")),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 🔹 Helper method for date columns
  Widget _buildDateColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}


/*class PendingReqList extends StatefulWidget {
  final PendingLeaveRequisitionModal pendingLeaveRequisitionModal;
  const PendingReqList(this.pendingLeaveRequisitionModal);


  @override
  State<PendingReqList> createState() => _PendingReqListState(pendingLeaveRequisitionModal);
}

class _PendingReqListState extends State<PendingReqList> {
  final PendingLeaveRequisitionModal pendingLeaveRequisitionModal;
  _PendingReqListState(this.pendingLeaveRequisitionModal);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(4.0),
      itemCount: pendingLeaveRequisitionModal!.result!.data!.length,
      itemBuilder: (context, itemCount) {
        return InkWell(
            onTap: (){
              print(pendingLeaveRequisitionModal!.result!.data!.length);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PendingLeaveApproveDisapprove(
                      pendingLeaveRequisitionModal, itemCount)));
              //Navigator.pushNamed(context, MyRoutings.pendingLeaveAppDisRoute);
              //CommonNotificationPage.showDeleteMessage(context, context, context);
            },
            child: Card(
                elevation: 2,
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          pendingLeaveRequisitionModal!.result!.data![itemCount].employeeName.toString().text.make().px8().py4(),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  pendingLeaveRequisitionModal!.result!.data![itemCount].status.toString().text.make().px8(),
                                ],
                              )
                          )

                        ],
                      ),
                      Row(
                        children: [
                          pendingLeaveRequisitionModal!.result!.data![itemCount].leaveType.toString().text.textStyle(context.captionStyle).make().px8(),
                        ],
                      ),
                      Row(
                        children: [
                          pendingLeaveRequisitionModal!.result!.data![itemCount].leaveLength.toString().text.textStyle(context.captionStyle).make().px8(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              "Start Date".text.sm.make(),
                              pendingLeaveRequisitionModal!.result!.data![itemCount].startDate.toString().text.sm.make()
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                            child: Column(
                              children: [
                                "End Date".text.sm.make(),
                                pendingLeaveRequisitionModal!.result!.data![itemCount].endDate.toString().text.sm.make()
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              "In Time".text.sm.make(),
                              pendingLeaveRequisitionModal!.result!.data![itemCount].startTime.toString().text.sm.make()
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 5, right: 3, bottom: 18),
                            child: Column(
                              children: [
                                "Out Time".text.sm.make(),
                                pendingLeaveRequisitionModal!.result!.data![itemCount].endTime.toString().text.sm.make()
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
            )

            .badge(
              color: Mythemes.lightBluishColor ,
              size: 25 ,
              count: 8,
              position: VxBadgePosition.rightTop,
              textStyle: TextStyle(
                  fontSize: 14,
                  color: Mythemes.whitish)

          ),
        );
      },
    );
  }
}*/

