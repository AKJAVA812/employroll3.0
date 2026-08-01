import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/employeePage/employeeListPage.dart';
import 'package:er_flutter_project/employeePage/mapView.dart';
import 'package:timelines/timelines.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import '../commanScreen/allAPIList.dart';
import '../sharedPrefancePage/ShardPre.dart';
import 'modalClasses/timeLineModal.dart';

class TimeLineEmp extends StatefulWidget {
  int? empId;
  var selectedDate;

  TimeLineEmp(this.empId, this.selectedDate);

  @override
  State<TimeLineEmp> createState() => _TimeLineEmpState(empId, selectedDate);
}

bool isLoading = true;
Future<TimeLineModal>? futureTimeline;
Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
TimeLineModal? timeLineModalGlobal;
var titleName = 'Timeline';
var getData;

class _TimeLineEmpState extends State<TimeLineEmp> {
  _TimeLineEmpState(int? empId, selectedDate);

  var getDate;
  var getEmpId;
  var timelineLength;

  @override
  void initState() {
    getDate = selectedDate;
    getEmpId = empId;

    //print('getDate $getDate');
    //print('getEmpId $getEmpId');

    // TODO: implement initState
    super.initState();
    getSharedPrfanceList();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<TimeLineModal> getEmployeeList11 = getTimeLine(sessionId!);
    futureTimeline = getTimeLine(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait"),
      ],
    );

    getEmployeeList11.then((value) {
      setState(() {
        timeLineModalGlobal = value;
      });
      //print('employeeList00${timeLineModalGlobal!.data!.length}');
    });
  }
  /*
  Future<TimeLineModal> getTimeLine(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.timeLineApi;
    //print('employeeList11: ${SessionId}');
    TimeLineModal timeLineModal;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$SessionId&"
        "empId=$empId&"
        "date=$selectedDate"
    );
    final response = await MobileHttpClient.instance.post(urlapi);

    print('URL ${response.request}');
    //print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    getData = mapResponse['data'];
    //print('responseemployeeList $getData');
    //print(getData.length);

    timeLineModal=TimeLineModal.fromJson(mapResponse);



    return timeLineModal;
  }*/

  Future<TimeLineModal> getTimeLine(String sessionId) async {
    setState(() {
      isLoading = true; // âœ… Show loader before API call
    });

    try {
      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.timeLineApi;
      var urlapi = Uri.parse(
        "$conn$apiUrl?sessionId=$sessionId&empId=$empId&date=$selectedDate",
      );

      final response = await MobileHttpClient.instance.post(urlapi);

      print('URL: ${response.request}');

      mapResponse = json.decode(response.body);
      getData = mapResponse['data'];

      TimeLineModal timeLineModal = TimeLineModal.fromJson(mapResponse);

      setState(() {
        isLoading = false; // âœ… Hide loader after API success
      });

      return timeLineModal; // âœ… Always return a valid object
    } catch (e) {
      print("âŒ Error fetching timeline data: $e");

      setState(() {
        isLoading = false; // âœ… Hide loader on error
      });

      // âœ… Instead of returning null, return an empty TimeLineModal object
      return TimeLineModal(data: []);
    }
  }

  var colorChange;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mythemes.whitish,
      appBar: AppBar(title: titleName.text.make()),

      body: FutureBuilder<TimeLineModal>(
        future: futureTimeline,
        builder: (context, snapshot) {
          if (isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            ); // âœ… Show loader
          } else if (snapshot.hasError) {
            return Center(child: Text("âŒ Error loading data"));
          } else if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
            return Center(child: Text("There is no data available."));
          }

          // âœ… Timeline UI when data is available
          return Timeline.tileBuilder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            builder: TimelineTileBuilder.connected(
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
              itemCount: timeLineModalGlobal!.data!.length,
              contentsAlign: ContentsAlign.alternating,

              // âœ… Custom Icons Instead of Default Dots
              indicatorBuilder:
                  (context, index) => Indicator.widget(
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: getColor(
                          timeLineModalGlobal!.data![index].type,
                        ), // Background color
                      ),
                      child: Icon(
                        getTimelineIcon(timeLineModalGlobal!.data![index].type),
                        color: Colors.white, // Icon color
                        size: 24,
                      ),
                    ),
                  ),

              // âœ… Connector between timeline items
              connectorBuilder:
                  (context, index, type) =>
                      Connector.solidLine(color: Colors.grey.shade400),
              // âœ… Timeline Content (Text)
              contentsBuilder: (context, index) {
                if (timeLineModalGlobal!.data![index].type! == "Logged IN") {
                  colorChange = Mythemes.successColor;
                } else if (timeLineModalGlobal!.data![index].type! ==
                    "Logged OUT") {
                  colorChange = Mythemes.dangerColor;
                } else if (timeLineModalGlobal!.data![index].type! ==
                    "Attendance IN") {
                  colorChange = Mythemes.successColor;
                } else if (timeLineModalGlobal!.data![index].type! ==
                    "Attendance OUT") {
                  colorChange = Mythemes.dangerColor;
                } else if (timeLineModalGlobal!.data![index].type! ==
                    "Work Done") {
                  colorChange = Mythemes.alertColor;
                }
                return Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          timeLineModalGlobal!.data![index].datetime!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          timeLineModalGlobal!.data![index].type!,
                          style: TextStyle(color: Colors.blue),
                        ),
                        SizedBox(height: 4),
                        Text(
                          timeLineModalGlobal!.data![index].address!,
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ).py8();
        },
      ),

      /* body: Container(
        child:
        timeLineModalGlobal!.data!.isEmpty ? Center(
          child: "There is no data available.".text.make(),
        ) :
        Timeline.tileBuilder(
          shrinkWrap: true,
        scrollDirection: Axis.vertical,

        builder: TimelineTileBuilder.fromStyle(

          itemCount: timeLineModalGlobal!.data!.length,
          contentsAlign: ContentsAlign.alternating,
          contentsBuilder: (context, index) {
            return Card(
              borderOnForeground: true,
              elevation: 3,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      timeLineModalGlobal!.data![index].datetime!
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                        timeLineModalGlobal!.data![index].type!
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                        timeLineModalGlobal!.data![index].address!,
                      style: TextStyle(
                        fontSize: 13
                      ),),
                  ),
                ],
              ),
            );
          }

        ),
      ),
      )*/
    );
  }

  Color getColor(String? color) {
    switch (color) {
      case "Work Done":
        return Mythemes.lightBluishColor; // âœ… Work Done Icon
      case "Logged IN":
        return Mythemes.successColor; // âœ… Logged In Icon
      case "Logged OUT":
        return Mythemes.dangerColor; // âœ… Logged Out Icon
      case "Break":
        return Mythemes.alertColor; // âœ… Break Icon
      case "Attendance IN":
        return Mythemes.successColor; // âœ… Work Done Icon
      case "Attendance OUT":
        return Mythemes.dangerColor; // âœ… Work Done Icon
      default:
        return Mythemes
            .lightBluishColor; // âœ… Default Icon (for unknown types)
    }
  }

  IconData getTimelineIcon(String? type) {
    switch (type) {
      case "Work Done":
        return Icons.task_alt; // âœ… Work Done Icon
      case "Logged IN":
        return Icons.login; // âœ… Logged In Icon
      case "Logged OUT":
        return Icons.logout; // âœ… Logged Out Icon
      case "Break":
        return Icons.free_breakfast; // âœ… Break Icon
      case "Meeting":
        return Icons.business; // âœ… Meeting Icon
      case "Attendance IN":
        return Icons.touch_app; // âœ… Work Done Icon
      case "Attendance OUT":
        return Icons.touch_app; // âœ… Work Done Icon
      default:
        return Icons.circle; // âœ… Default Icon (for unknown types)
    }
  }
}
