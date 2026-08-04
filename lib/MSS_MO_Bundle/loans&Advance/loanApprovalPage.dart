import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:er_flutter_project/MSS_MO_Bundle/loans&Advance/pendingLoanRequestList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/commanNotificationPage.dart';
import '../../commanScreen/homePage.dart';
import '../../commanScreen/punchInOutScreen.dart';
import '../../commanScreen/routes.dart';
import '../../ess/EssDashboarrddModel.dart';
import '../../ess/essDashboardNavigate.dart';
import '../../profiles/profilePageWithHead.dart';
import '../../sharedPrefancePage/ShardPre.dart';
import '../../themes/empThemes.dart';
import 'modalClass/loanDataShowApprovalModal.dart';

class LoanApprovalPage extends StatefulWidget {
  final dynamic loanReqId;

  const LoanApprovalPage({super.key, required this.loanReqId});
  @override
  _LoanApprovalPageState createState() =>
      _LoanApprovalPageState(loanReqId.toString());
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
dynamic userPanel;
dynamic loanApprovalL1Perm;
dynamic loanApprovalL2Perm;
dynamic loanApprovalL3Perm;
dynamic loanDisApprovalL1Perm;
dynamic loanDisApprovalL2Perm;
dynamic loanDisApprovalL3Perm;
bool isLoading = true;
bool isLoadingCount = true;
List<DataNew>? allUsernew = [];
List<DataNew>? foundDataNew = [];

LoanDataShowApprovalModal? loanDataShowApprovalLabel;
LoanDataShowApprovalModal? loanDataShowApprovalLabeled;

dynamic loanReqIdReceived;

class _LoanApprovalPageState extends State<LoanApprovalPage> {
  final dynamic loanReqIdReceive;
  var principalBalance;
  var instalmentRequested;
  var loanTypeSelected;
  var interestBalL1;
  var interestBalL2;
  var interestBalL3;
  _LoanApprovalPageState(this.loanReqIdReceive);
  final TextEditingController _deductionDateController =
      TextEditingController();
  final TextEditingController _deductionDateControllerL1 =
      TextEditingController();
  final TextEditingController _deductionDateControllerL2 =
      TextEditingController();
  final TextEditingController _deductionDateControllerL3 =
      TextEditingController();
  final TextEditingController _totalLoanRequestedControllerL1 =
      TextEditingController();
  final TextEditingController _totalLoanRequestedControllerL2 =
      TextEditingController();
  final TextEditingController _totalLoanRequestedControllerL3 =
      TextEditingController();
  final TextEditingController _installmentsApprovedController =
      TextEditingController();
  final TextEditingController _installmentsApprovedControllerL1 =
      TextEditingController();
  final TextEditingController _installmentsApprovedControllerL2 =
      TextEditingController();
  final TextEditingController _installmentsApprovedControllerL3 =
      TextEditingController();
  List<Map<String, String>> monthlyStatusL1 = [];
  List<Map<String, String>> monthlyStatusL2 = [];
  List<Map<String, String>> monthlyStatusL3 = [];
  //final double totalLoan = 340000.0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (valueChange == 0) {
          _deductionDateControllerL1.text = DateFormat(
            'dd-MM-yyyy',
          ).format(picked);
        }
        if (valueChange == 1) {
          _deductionDateControllerL2.text = DateFormat(
            'dd-MM-yyyy',
          ).format(picked);
        }
        if (valueChange == 2) {
          _deductionDateControllerL3.text = DateFormat(
            'dd-MM-yyyy',
          ).format(picked);
        }

        _updateMonthlyStatus();
      });
    }
  }

  var monthlyInstalmentL1;
  var monthlyInstalmentL2;
  var monthlyInstalmentL3;

  void _updateMonthlyStatus() {
    if (valueChange == 0) {
      monthlyStatusL1.clear();
      final int installments =
          int.tryParse(_installmentsApprovedControllerL1.text) ?? 0;
      if (installments > 0 && _deductionDateControllerL1.text.isNotEmpty) {
        DateTime startDate = DateFormat(
          'dd-MM-yyyy',
        ).parse(_deductionDateControllerL1.text);
        double totalLoan =
            double.tryParse(_totalLoanRequestedControllerL1.text) ?? 0.0;
        monthlyInstalmentL1 = totalLoan / installments;

        for (int i = 0; i < installments; i++) {
          String monthYear = DateFormat(
            'MMMM-yyyy',
          ).format(DateTime(startDate.year, startDate.month + i));
          monthlyStatusL1.add({
            'month': monthYear,
            'amount': monthlyInstalmentL1.toStringAsFixed(2),
          });
        }
      }
    }
    if (valueChange == 1) {
      monthlyStatusL2.clear();
      final int installments =
          int.tryParse(_installmentsApprovedControllerL2.text) ?? 0;
      if (installments > 0 && _deductionDateControllerL2.text.isNotEmpty) {
        DateTime startDate = DateFormat(
          'dd-MM-yyyy',
        ).parse(_deductionDateControllerL2.text);
        double totalLoan =
            double.tryParse(_totalLoanRequestedControllerL2.text) ?? 0.0;
        monthlyInstalmentL2 = totalLoan / installments;

        for (int i = 0; i < installments; i++) {
          String monthYear = DateFormat(
            'MMMM-yyyy',
          ).format(DateTime(startDate.year, startDate.month + i));
          monthlyStatusL2.add({
            'month': monthYear,
            'amount': monthlyInstalmentL2.toStringAsFixed(2),
          });
        }
      }
    }
    if (valueChange == 2) {
      monthlyStatusL3.clear();
      final int installments =
          int.tryParse(_installmentsApprovedControllerL3.text) ?? 0;
      if (installments > 0 && _deductionDateControllerL3.text.isNotEmpty) {
        DateTime startDate = DateFormat(
          'dd-MM-yyyy',
        ).parse(_deductionDateControllerL3.text);
        double totalLoan =
            double.tryParse(_totalLoanRequestedControllerL3.text) ?? 0.0;
        monthlyInstalmentL3 = totalLoan / installments;

        for (int i = 0; i < installments; i++) {
          String monthYear = DateFormat(
            'MMMM-yyyy',
          ).format(DateTime(startDate.year, startDate.month + i));
          monthlyStatusL3.add({
            'month': monthYear,
            'amount': monthlyInstalmentL3.toStringAsFixed(2),
          });
        }
      }
    }
    setState(() {});
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    loanApprovalL1Perm = await shared.getLoanApprovalL1MSS();
    loanApprovalL2Perm = await shared.getLoanApprovalL2MSS();
    loanApprovalL3Perm = await shared.getLoanApprovalL3MSS();

    print("Loan Approval L1 - $loanApprovalL1Perm");
    print("Loan Approval L2 - $loanApprovalL2Perm");
    print("Loan Approval L3 - $loanApprovalL3Perm");
    // await Future.delayed(Duration(seconds: 5));
    Future<LoanDataShowApprovalModal> getEmployeeList11 =
        getLoanDataForApproval(sessionId!);
    isLoading = true;
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait"),
      ],
    );

    getEmployeeList11.then((value) {
      setState(() {
        foundDataNew = allUsernew;
        loanDataShowApprovalLabel = value;
        loanDataShowApprovalLabeled = loanDataShowApprovalLabel;
        isLoading = false;
        print('Loan Data - ${foundDataNew!.length}');

        principalBalance = foundDataNew![0].principalbalance.toString();
        instalmentRequested = foundDataNew![0].installmentRequested.toString();
        loanTypeSelected = foundDataNew![0].loanType.toString();
        if (valueChange == 0) {
          if (_deductionDateControllerL1.text == "" ||
              _installmentsApprovedControllerL1.text == "" ||
              _totalLoanRequestedControllerL1.text == "") {
            _deductionDateControllerL1.text =
                foundDataNew![0].deductFroDate.toString();
            _installmentsApprovedControllerL1.text =
                foundDataNew![0].installmentlevelOne.toString();
            _totalLoanRequestedControllerL1.text =
                foundDataNew![0].loanAmount.toString();
          } else {
            _deductionDateControllerL1.text;
            _installmentsApprovedControllerL1.text;
            _totalLoanRequestedControllerL1.text;
          }

          interestBalL1 = foundDataNew![0].interestRateL1;
        } else if (valueChange == 1) {
          if (_deductionDateControllerL2.text == "" ||
              _installmentsApprovedControllerL2.text == "" ||
              _totalLoanRequestedControllerL2.text == "") {
            _deductionDateControllerL2.text =
                foundDataNew![0].deductFromDateL2.toString();
            _installmentsApprovedControllerL2.text =
                foundDataNew![0].installmentlevelTwo.toString();
            _totalLoanRequestedControllerL2.text =
                foundDataNew![0].loanAmount.toString();
          } else {
            _deductionDateControllerL2.text;
            _installmentsApprovedControllerL2.text;
            _totalLoanRequestedControllerL2.text;
          }
          interestBalL2 = foundDataNew![0].interestRateL2;
          print("Int Bal 2$interestBalL2");
        } else if (valueChange == 2) {
          if (_deductionDateControllerL3.text == "" ||
              _installmentsApprovedControllerL3.text == "" ||
              _totalLoanRequestedControllerL3.text == "") {
            _deductionDateControllerL3.text =
                foundDataNew![0].deductFromDateL3.toString();
            _installmentsApprovedControllerL3.text =
                foundDataNew![0].installmentlevelThree.toString();
            _totalLoanRequestedControllerL3.text =
                foundDataNew![0].loanAmount.toString();
          } else {
            _deductionDateControllerL3.text;
            _installmentsApprovedControllerL3.text;
            _totalLoanRequestedControllerL3.text;
          }
          interestBalL3 = foundDataNew![0].interestRateL3;
          print("Int Bal 3$interestBalL3");
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _updateMonthlyStatus();
    loanReqIdReceived = loanReqIdSend;
    print("Loan Req Id - $loanReqIdReceived");
    getSharedPrfanceList();
  }

  Future<LoanDataShowApprovalModal> getLoanDataForApproval(
    String SessionId,
  ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanDataViewToApproveApi;
    print('employeeList11: ${SessionId}');
    LoanDataShowApprovalModal loanDataShowApprovalModal;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$SessionId&"
      "loanReqId=$loanReqIdReceived",
    );
    final response = await MobileHttpClient.instance.post(urlapi);

    print('responseemployeeList ${response.body}');
    setState(() {
      isLoadingCount = true;
      isLoading = true;
    });
    print('URL ${response.request}');
    mapResponse = json.decode(response.body);
    print('responseemployeeList $mapResponse');
    var getData = mapResponse.length;

    loanDataShowApprovalModal = LoanDataShowApprovalModal.fromJson(mapResponse);

    allUsernew = loanDataShowApprovalModal.data;

    setState(() {
      isLoadingCount = false;
      isLoading = false;
    });

    return loanDataShowApprovalModal;
  }

  int valueChange = 0;
  var statusChange = "LEVEL_ONE_PENDING";
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        //backgroundColor: Colors.indigo,
        title: Text('Loan Approval'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 100),
            child: Column(
              children: [
                _buildToggleSwitch(),
                SizedBox(height: 10),

                Visibility(
                  visible: valueChange == 0,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildEditableRow(
                            'Total Loan Requested',
                            _totalLoanRequestedControllerL1,
                            false,
                          ),
                          _buildLoanDetailRow(
                            'Loan Type',
                            '$loanTypeSelected',
                            Colors.teal.shade700,
                          ),
                          _buildLoanDetailRow(
                            'Interest Rate',
                            '${interestBalL1}%',
                            Colors.orange,
                          ),
                          _buildLoanDetailRow(
                            'Principle Balance',
                            '$principalBalance',
                            Colors.blue,
                          ),
                          _buildLoanDetailRow(
                            'Interest Balance',
                            '-',
                            Colors.red,
                          ),
                          _buildLoanDetailRow(
                            'Installments Requested',
                            '$instalmentRequested',
                            Colors.deepPurple,
                          ),
                          _buildEditableRow(
                            'Deduction Date',
                            _deductionDateControllerL1,
                            true,
                          ),
                          _buildEditableRow(
                            'Installments Approved L1',
                            _installmentsApprovedControllerL1,
                            false,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Monthly Installment Breakdown',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo,
                            ),
                          ),
                          Divider(),
                          Container(
                            constraints: BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: monthlyStatusL1.length,
                              itemBuilder: (context, index) {
                                return _buildStatusRow(
                                  monthlyStatusL1[index]['month']!,
                                  monthlyStatusL1[index]['amount']!,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: valueChange == 1,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildEditableRow(
                            'Total Loan Requested',
                            _totalLoanRequestedControllerL2,
                            false,
                          ),
                          _buildLoanDetailRow(
                            'Loan Type',
                            '$loanTypeSelected',
                            Colors.teal.shade700,
                          ),
                          _buildLoanDetailRow(
                            'Interest Rate',
                            '${interestBalL2}%',
                            Colors.orange,
                          ),
                          _buildLoanDetailRow(
                            'Principle Balance',
                            '$principalBalance',
                            Colors.blue,
                          ),
                          _buildLoanDetailRow(
                            'Interest Balance',
                            '-',
                            Colors.red,
                          ),
                          _buildLoanDetailRow(
                            'Installments Requested',
                            '$instalmentRequested',
                            Colors.deepPurple,
                          ),
                          _buildEditableRow(
                            'Deduction Date',
                            _deductionDateControllerL2,
                            true,
                          ),
                          _buildEditableRow(
                            'Installments Approved L1',
                            _installmentsApprovedControllerL2,
                            false,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Monthly Installment Breakdown',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo,
                            ),
                          ),
                          Divider(),
                          Container(
                            constraints: BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: monthlyStatusL2.length,
                              itemBuilder: (context, index) {
                                return _buildStatusRow(
                                  monthlyStatusL2[index]['month']!,
                                  monthlyStatusL2[index]['amount']!,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: valueChange == 2,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildEditableRow(
                            'Total Loan Requested',
                            _totalLoanRequestedControllerL3,
                            false,
                          ),
                          _buildLoanDetailRow(
                            'Loan Type',
                            '$loanTypeSelected',
                            Colors.teal.shade700,
                          ),
                          _buildLoanDetailRow(
                            'Interest Rate',
                            '${interestBalL3}%',
                            Colors.orange,
                          ),
                          _buildLoanDetailRow(
                            'Principle Balance',
                            '$principalBalance',
                            Colors.blue,
                          ),
                          _buildLoanDetailRow(
                            'Interest Balance',
                            '-',
                            Colors.red,
                          ),
                          _buildLoanDetailRow(
                            'Installments Requested',
                            '$instalmentRequested',
                            Colors.deepPurple,
                          ),
                          _buildEditableRow(
                            'Deduction Date',
                            _deductionDateControllerL3,
                            true,
                          ),
                          _buildEditableRow(
                            'Installments Approved L1',
                            _installmentsApprovedControllerL3,
                            false,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Monthly Installment Breakdown',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo,
                            ),
                          ),
                          Divider(),
                          Container(
                            constraints: BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: monthlyStatusL3.length,
                              itemBuilder: (context, index) {
                                return _buildStatusRow(
                                  monthlyStatusL3[index]['month']!,
                                  monthlyStatusL3[index]['amount']!,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              //color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (valueChange == 0) {
                        disApproveLoanL1(context);
                      }
                      if (valueChange == 1) {
                        disApproveLoanL2(context);
                      }
                      if (valueChange == 2) {
                        disApproveLoanL3(context);
                      }
                    },
                    icon: Icon(Icons.cancel),
                    label: Text('Disapprove'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (valueChange == 0) {
                        approveLoanL1(context);
                      }
                      if (valueChange == 1) {
                        approveLoanL2(context);
                      }
                      if (valueChange == 2) {
                        approveLoanL3(context);
                      }
                    },
                    icon: Icon(Icons.check_circle),
                    label: Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            //Navigator.of(context, rootNavigator: true).pop();
            print('home tab');
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PunchInOUtActivity()),
            );
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Workflow');
          }
          if (index == 2) {
            Navigator.pushNamed(context, MyRoutings.myAllRequestRoute);
            print('My Requests');
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => EssAdminDashboardHead(EssDashboarrdModel()),
              ),
            );
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            print('Dashboard');
          }
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePageNew()),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts_outlined),
            label: 'Workflow',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree_outlined),
            label: 'My Requests',
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

  Future<void> approveLoanL1(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanApproveL1Api;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['permission'] = loanApprovalL1Perm;
    request.fields['installNum'] = _installmentsApprovedControllerL1.text;
    request.fields['dedDate'] = _deductionDateControllerL1.text;
    request.fields['loanReqId'] = loanReqIdReceived.toString();
    request.fields['loanAmount'] = foundDataNew![0].loanAmount.toStringAsFixed(
      2,
    );
    request.fields['loanAmountlevelOne'] = _totalLoanRequestedControllerL1.text;
    request.fields['loanAccountNo'] = foundDataNew![0].loanAccountNo;
    request.fields['interestRate'] = interestBalL1.toString();
    request.fields['montlyInstallAmt'] = monthlyInstalmentL1.toStringAsFixed(2);
    request.fields['interestBlnc'] = interestBalL1.toString();
    request.fields['loanDesc'] = "";

    // Construct the API URL with parameters (for debugging)
    String apiWithParams =
        urlapi.toString() +
        '?' +
        request.fields.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&');

    // Debugging: Print the full API URL with parameters
    print('API URL with Parameters: $apiWithParams');

    try {
      // Send the request
      http.StreamedResponse response = await request.send();

      // Parse the response
      http.Response httpResponse = await http.Response.fromStream(response);
      print('URL: ${httpResponse.request}');
      print('Response Status Code: ${httpResponse.statusCode}');
      print('Response Body: ${httpResponse.body}');

      if (httpResponse.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
        var mapResponse = json.decode(httpResponse.body);
        String reason = mapResponse['reason'];
        String result = mapResponse['result'];

        // Handle success or error response
        if (result.compareToIgnoringCase("Success") == 0) {
          showDialgSucess(context, reason.upperCamelCase + " ", "Success");
        } else if (result.compareToIgnoringCase("Error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, "Error");
        }
      } else {
        print('API Call Failed: ${httpResponse.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> disApproveLoanL1(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanDisApproveL1Api;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['permission'] = loanDisApprovalL1Perm;
    request.fields['installNum'] = _installmentsApprovedControllerL1.text;
    request.fields['dedDate'] = _deductionDateControllerL1.text;
    request.fields['loanReqId'] = loanReqIdReceived.toString();
    request.fields['loanAmount'] = foundDataNew![0].loanAmount.toStringAsFixed(
      2,
    );
    request.fields['loanAmountlevelOne'] = _totalLoanRequestedControllerL1.text;
    request.fields['loanAccountNo'] = foundDataNew![0].loanAccountNo;
    request.fields['interestRate'] = interestBalL1.toString();
    request.fields['montlyInstallAmt'] = monthlyInstalmentL1.toStringAsFixed(2);
    request.fields['interestBlnc'] = interestBalL1.toString();
    request.fields['loanDesc'] = "";

    // Construct the API URL with parameters (for debugging)
    String apiWithParams =
        urlapi.toString() +
        '?' +
        request.fields.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&');

    // Debugging: Print the full API URL with parameters
    print('API URL with Parameters: $apiWithParams');

    try {
      // Send the request
      http.StreamedResponse response = await request.send();

      // Parse the response
      http.Response httpResponse = await http.Response.fromStream(response);
      print('URL: ${httpResponse.request}');
      print('Response Status Code: ${httpResponse.statusCode}');
      print('Response Body: ${httpResponse.body}');

      if (httpResponse.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
        var mapResponse = json.decode(httpResponse.body);
        String reason = mapResponse['reason'];
        String result = mapResponse['result'];

        // Handle success or error response
        if (result.compareToIgnoringCase("Success") == 0) {
          showDialgSucess(context, reason.upperCamelCase + " ", "Success");
        } else if (result.compareToIgnoringCase("Error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, "Error");
        }
      } else {
        print('API Call Failed: ${httpResponse.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> approveLoanL2(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanApproveL2Api;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['permission'] = loanApprovalL2Perm;
    request.fields['installNum'] = _installmentsApprovedControllerL1.text;
    request.fields['dedDate'] = _deductionDateControllerL1.text;
    request.fields['loanReqId'] = loanReqIdReceived.toString();
    request.fields['loanAmount'] = foundDataNew![0].loanAmount.toStringAsFixed(
      2,
    );
    request.fields['loanAmountlevelOne'] = _totalLoanRequestedControllerL1.text;
    request.fields['loanAccountNo'] = foundDataNew![0].loanAccountNo;
    request.fields['interestRate'] = interestBalL1.toString();
    request.fields['montlyInstallAmt'] = monthlyInstalmentL1.toStringAsFixed(2);
    request.fields['interestBlnc'] = interestBalL1.toString();
    request.fields['loanDesc'] = "";

    // Construct the API URL with parameters (for debugging)
    String apiWithParams =
        urlapi.toString() +
        '?' +
        request.fields.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&');

    // Debugging: Print the full API URL with parameters
    print('API URL with Parameters: $apiWithParams');

    try {
      // Send the request
      http.StreamedResponse response = await request.send();

      // Parse the response
      http.Response httpResponse = await http.Response.fromStream(response);
      print('URL: ${httpResponse.request}');
      print('Response Status Code: ${httpResponse.statusCode}');
      print('Response Body: ${httpResponse.body}');

      if (httpResponse.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
        var mapResponse = json.decode(httpResponse.body);
        String reason = mapResponse['reason'];
        String result = mapResponse['result'];

        // Handle success or error response
        if (result.compareToIgnoringCase("Success") == 0) {
          showDialgSucess(context, reason.upperCamelCase + " ", "Success");
        } else if (result.compareToIgnoringCase("Error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, "Error");
        }
      } else {
        print('API Call Failed: ${httpResponse.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> disApproveLoanL2(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanDisApproveL2Api;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['permission'] = loanDisApprovalL2Perm;
    request.fields['installNum'] = _installmentsApprovedControllerL1.text;
    request.fields['dedDate'] = _deductionDateControllerL1.text;
    request.fields['loanReqId'] = loanReqIdReceived.toString();
    request.fields['loanAmount'] = foundDataNew![0].loanAmount.toStringAsFixed(
      2,
    );
    request.fields['loanAmountlevelOne'] = _totalLoanRequestedControllerL1.text;
    request.fields['loanAccountNo'] = foundDataNew![0].loanAccountNo;
    request.fields['interestRate'] = interestBalL1.toString();
    request.fields['montlyInstallAmt'] = monthlyInstalmentL1.toStringAsFixed(2);
    request.fields['interestBlnc'] = interestBalL1.toString();
    request.fields['loanDesc'] = "";

    // Construct the API URL with parameters (for debugging)
    String apiWithParams =
        urlapi.toString() +
        '?' +
        request.fields.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&');

    // Debugging: Print the full API URL with parameters
    print('API URL with Parameters: $apiWithParams');

    try {
      // Send the request
      http.StreamedResponse response = await request.send();

      // Parse the response
      http.Response httpResponse = await http.Response.fromStream(response);
      print('URL: ${httpResponse.request}');
      print('Response Status Code: ${httpResponse.statusCode}');
      print('Response Body: ${httpResponse.body}');

      if (httpResponse.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
        var mapResponse = json.decode(httpResponse.body);
        String reason = mapResponse['reason'];
        String result = mapResponse['result'];

        // Handle success or error response
        if (result.compareToIgnoringCase("Success") == 0) {
          showDialgSucess(context, reason.upperCamelCase + " ", "Success");
        } else if (result.compareToIgnoringCase("Error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, "Error");
        }
      } else {
        print('API Call Failed: ${httpResponse.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> approveLoanL3(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanApproveL3Api;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['permission'] = loanApprovalL3Perm;
    request.fields['installNum'] = _installmentsApprovedControllerL1.text;
    request.fields['dedDate'] = _deductionDateControllerL1.text;
    request.fields['loanReqId'] = loanReqIdReceived.toString();
    request.fields['loanAmount'] = foundDataNew![0].loanAmount.toStringAsFixed(
      2,
    );
    request.fields['loanAmountlevelOne'] = _totalLoanRequestedControllerL1.text;
    request.fields['loanAccountNo'] = foundDataNew![0].loanAccountNo;
    request.fields['interestRate'] = interestBalL1.toString();
    request.fields['montlyInstallAmt'] = monthlyInstalmentL1.toStringAsFixed(2);
    request.fields['interestBlnc'] = interestBalL1.toString();
    request.fields['loanDesc'] = "";

    // Construct the API URL with parameters (for debugging)
    String apiWithParams =
        urlapi.toString() +
        '?' +
        request.fields.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&');

    // Debugging: Print the full API URL with parameters
    print('API URL with Parameters: $apiWithParams');

    try {
      // Send the request
      http.StreamedResponse response = await request.send();

      // Parse the response
      http.Response httpResponse = await http.Response.fromStream(response);
      print('URL: ${httpResponse.request}');
      print('Response Status Code: ${httpResponse.statusCode}');
      print('Response Body: ${httpResponse.body}');

      if (httpResponse.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
        var mapResponse = json.decode(httpResponse.body);
        String reason = mapResponse['reason'];
        String result = mapResponse['result'];

        // Handle success or error response
        if (result.compareToIgnoringCase("Success") == 0) {
          showDialgSucess(context, reason.upperCamelCase + " ", "Success");
        } else if (result.compareToIgnoringCase("Error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, "Error");
        }
      } else {
        print('API Call Failed: ${httpResponse.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> disApproveLoanL3(BuildContext context) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanDisApproveL3Api;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['permission'] = loanDisApprovalL3Perm;
    request.fields['installNum'] = _installmentsApprovedControllerL1.text;
    request.fields['dedDate'] = _deductionDateControllerL1.text;
    request.fields['loanReqId'] = loanReqIdReceived.toString();
    request.fields['loanAmount'] = foundDataNew![0].loanAmount.toStringAsFixed(
      2,
    );
    request.fields['loanAmountlevelOne'] = _totalLoanRequestedControllerL1.text;
    request.fields['loanAccountNo'] = foundDataNew![0].loanAccountNo;
    request.fields['interestRate'] = interestBalL1.toString();
    request.fields['montlyInstallAmt'] = monthlyInstalmentL1.toStringAsFixed(2);
    request.fields['interestBlnc'] = interestBalL1.toString();
    request.fields['loanDesc'] = "";

    // Construct the API URL with parameters (for debugging)
    String apiWithParams =
        urlapi.toString() +
        '?' +
        request.fields.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&');

    // Debugging: Print the full API URL with parameters
    print('API URL with Parameters: $apiWithParams');

    try {
      // Send the request
      http.StreamedResponse response = await request.send();

      // Parse the response
      http.Response httpResponse = await http.Response.fromStream(response);
      print('URL: ${httpResponse.request}');
      print('Response Status Code: ${httpResponse.statusCode}');
      print('Response Body: ${httpResponse.body}');

      if (httpResponse.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
        var mapResponse = json.decode(httpResponse.body);
        String reason = mapResponse['reason'];
        String result = mapResponse['result'];

        // Handle success or error response
        if (result.compareToIgnoringCase("Success") == 0) {
          showDialgSucess(context, reason.upperCamelCase + " ", "Success");
        } else if (result.compareToIgnoringCase("Error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, "Error");
        }
      } else {
        print('API Call Failed: ${httpResponse.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  static showDialgSucess(
    BuildContext buildContext,
    String result,
    String alert,
  ) {
    showDialog(
      context: buildContext,
      barrierDismissible: false, // Prevents accidental dismiss
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Row(children: [Expanded(child: Text(alert))]),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  // âœ… Using `context` inside the builder
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pop(); // Close the dialog
                  Navigator.of(buildContext).maybePop();
                } else {
                  print("âš ï¸ Warning: No route to close.");
                }
              },
              child: Text("Ok"),
            ),
          ],
          elevation: 24.0,
        );
      },
    );
  }

  Widget _buildToggleSwitch() {
    return AnimatedToggleSwitch<int>.size(
      height: 36,
      current: min(valueChange, 3),
      style: ToggleStyle(
        backgroundColor: Colors.grey.shade300,
        indicatorColor: Colors.lightBlue,
        borderRadius: BorderRadius.circular(10.0),
        borderColor: Mythemes.lightBlue,
      ),
      values: const [0, 1, 2],
      iconOpacity: 1.0,
      selectedIconScale: 1.0,
      indicatorSize: const Size.fromWidth(70),
      spacing: 4.0,
      customIconBuilder: (context, local, global) {
        final text = const ['Level 1', 'Level 2', 'Level 3'][local.index];
        return Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color.lerp(
                Colors.black,
                Colors.white,
                local.animationValue,
              ),
            ),
          ),
        );
      },
      onChanged: (i) async {
        setState(() {
          valueChange = i;
          print("Level Value - $valueChange");
          getSharedPrfanceList();
        });
        switch (valueChange) {
          case 0:
            statusChange = "LEVEL_ONE_PENDING";
            break;
          case 1:
            statusChange = "LEVEL_TWO_PENDING";
            break;
          case 2:
            statusChange = "LEVEL_THREE_PENDING";
            break;
        }
      },
    );
  }

  Widget _buildStatusRow(String month, String amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            month,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            'â‚¹ $amount',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanDetailRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableRow(
    String label,
    TextEditingController controller,
    bool isDate,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 6,
            child: TextField(
              controller: controller,
              readOnly: isDate,
              onTap: isDate ? () => _selectDate(context) : null,
              onTapOutside: (event) => _updateMonthlyStatus(),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                suffixIcon:
                    isDate ? Icon(Icons.calendar_today, size: 18) : null,
              ),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}
