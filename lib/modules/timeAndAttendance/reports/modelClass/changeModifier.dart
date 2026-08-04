import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/modelClass/attendanceReportModel.dart';

class MyAttendanceReportData extends ChangeNotifier {
  late AttendanceReportModel employeeListModel;
  Map<String, dynamic> mapResponse = {};

  Future getEmployeeList(
    String sessionId,
    String fromdate,
    String toDate,
  ) async {
    print('employeeList11: ${sessionId}');

    var urlapi = Uri.parse(
      "http://www.employroll.com/restful/service/get/attendance/logs/multiple?sessionId=$sessionId&toDate=$toDate&fromDate=$fromdate",
    );
    final response = await MobileHttpClient.instance.post(urlapi);

    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    this.employeeListModel = AttendanceReportModel.fromJson(mapResponse);
    this.notifyListeners();
  }
}
