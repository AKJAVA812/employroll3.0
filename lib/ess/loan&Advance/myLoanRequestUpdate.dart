import 'dart:convert';
import 'package:er_flutter_project/ess/loan&Advance/myLoanRequestList.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/commanNotificationPage.dart';
import '../../sharedPrefancePage/ShardPre.dart';

class UpdateLoanRequestPage extends StatefulWidget {
  dynamic deptName;
  dynamic branchName;
  dynamic empName;
  dynamic loanType;
  dynamic loanAmount;
  dynamic loanStartDate;
  dynamic instalments;
  dynamic remarks;
  dynamic loanIdSend;

  UpdateLoanRequestPage(
    this.deptName,
    this.branchName,
    this.empName,
    this.loanType,
    this.loanAmount,
    this.loanStartDate,
    this.instalments,
    this.remarks,
    this.loanIdSend, {super.key}
  );

  @override
  _UpdateLoanRequestPageState createState() => _UpdateLoanRequestPageState(
    deptName,
    branchName,
    empName,
    loanType,
    loanAmount,
    loanStartDate,
    instalments,
    remarks,
    loanIdSend,
  );
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
String? department;
String? branch;
String? employeeName;

class _UpdateLoanRequestPageState extends State<UpdateLoanRequestPage> {
  _UpdateLoanRequestPageState(
    dynamic deptName,
    dynamic branchName,
    dynamic empName,
    dynamic loanType,
    dynamic loanAmount,
    dynamic loanStartDate,
    dynamic instalments,
    dynamic remarks,
    dynamic loanId,
  );

  /*  var deptNameCheck;
  var empNameCheck;
  var branchNameCheck;
  var loanTypeCheck;
  var loanAmountCheck;
  var loanStartDateCheck;
  var instalmentsCheck;
  var remarksCheck;
  var loanIdCheck;*/
  var loanIdCheck;
  String loanTypeSelectedRadio = 'loan';
  String loanTypeSelected = 'loan';
  String? selectedLoanType;
  DateTime? startDate;
  TextEditingController startDateController = TextEditingController();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController installmentController = TextEditingController();

  List<String?> loanTypes = [];
  List<String?> loanTypeId = [];
  List<String?> loanTypeSend = [];

  /*  List<Map<String, String>> breakupList = [
    {
      "employee": "Bharat Rajora (EMP-1024)",
      "months": "June-25",
      "amount": "93,000.00",
      "date": "Jul 15, 2025",
      "status": "Approved"
    },
    {
      "employee": "Bharat Rajora (EMP-1024)",
      "months": "July-25",
      "amount": "93,000.00",
      "date": "Aug 15, 2025",
      "status": "Pending"
    }
  ];*/
  List<Map<String, String>> breakupList = [];
  bool isLoading = false;
  Widget infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Expanded(
            child: Text("$label:", style: TextStyle(color: Colors.black54)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  bool isFormExpanded = true;
  var requestType = "loan";
  var loanId = "";
  var loanTypeSending = "";
  TextEditingController departmentController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();

  Future getLoanTypeMaster(String sessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanTypeMasterApi;

    //print('employeeList11: ${SessionId}');

    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    //print("Status $status");
    //print(inductionListLabel!.data!.length);

    mapResponse = json.decode(response.body);

    for (int i = 0; i < mapResponse['loandata'].length; i++) {
      loanTypes.add(mapResponse['loandata'][i]['loanName'].toString());
      loanTypeId.add(mapResponse['loandata'][i]['loanId'].toString());
      loanTypeSend.add(mapResponse['loandata'][i]['loantype'].toString());
      //print('ID -  ${mapResponse['data'][i]['branchId']}');
    }
    loanTypeSelected = mapResponse['loandata'][0]['loanName'].toString();
    setState(() {});
  }

  @override
  void initState() {
    getSharedPrfanceList();
    // TODO: implement initState
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    department = await shared.getDept();
    branch = await shared.getBranch();
    employeeName = await shared.getempName();
    departmentController.text = department ?? '';
    branchController.text = branch ?? '';
    employeeNameController.text = employeeName ?? '';
    loanIdCheck = loanIdSend;
    amountController.text = loanAmount.toString();
    startDateController.text = loanStartDate;
    installmentController.text = instalments.toString();
    remarkController.text = remarks;
    if (loanType != null && loanTypes.contains(loanType)) {
      selectedLoanType = loanType;
    } else {
      selectedLoanType = null;
    }
    getLoanTypeMaster(sessionId!);
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Update Loan Request'),
          //backgroundColor: Colors.green.shade700,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Loan / Advance Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio<String>(
                    value: 'loan',
                    groupValue: loanTypeSelectedRadio,
                    onChanged: (val) {
                      setState(() {
                        loanTypeSelectedRadio = val!;
                        requestType = "Loan";
                      });
                    },
                  ),
                  const Text('Loan'),
                  Radio<String>(
                    value: 'advance',
                    groupValue: loanTypeSelectedRadio,
                    onChanged: (val) {
                      setState(() {
                        loanTypeSelectedRadio = val!;
                        requestType = "Advance";
                      });
                    },
                  ),
                  const Text('Advance'),
                ],
              ),
              const SizedBox(height: 16),

              // ðŸ”½ Expand/Collapse Toggle Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Raise $requestType Request",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      isFormExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                    onPressed: () {
                      setState(() {
                        isFormExpanded = !isFormExpanded;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Visibility(
                visible: isFormExpanded,
                child: Column(
                  children: [
                    // Department & Branch Name (Row)
                    Row(
                      children: [
                        Expanded(
                          child: customReadOnlyInput(
                            icon: Icons.apartment,
                            label: "Department Name",
                            controller: departmentController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: customReadOnlyInput(
                            icon: Icons.location_city,
                            label: "Branch Name",
                            controller: branchController,
                          ),
                        ),
                      ],
                    ),

                    // Employee Name
                    customReadOnlyInput(
                      icon: Icons.person,
                      label: "Employee Name",
                      controller: employeeNameController,
                    ),

                    // Loan Type Dropdown
                    customDropdown(
                      icon: Icons.menu,
                      label: "Loan Type",
                      value:
                          selectedLoanType ??
                          (loanTypes.isNotEmpty ? loanTypes.first : null),
                      items: loanTypes, // Pass the raw list of strings
                      onChanged: (newVal) {
                        setState(() {
                          selectedLoanType = newVal;

                          // Get first matching index
                          int i = loanTypes.indexOf(newVal);
                          if (i != -1 && i < loanTypeId.length) {
                            loanId = loanTypeId[i].toString();
                          } else {
                            loanTypeId;
                          }
                          int j = loanTypes.indexOf(newVal);
                          if (i != -1 && j < loanTypeSend.length) {
                            loanTypeSending = loanTypeSend[i].toString();
                          } else {
                            loanTypeSending;
                          }
                        });
                      },
                    ),

                    // Amount
                    customTextField(
                      icon: Icons.currency_rupee,
                      label: "Amount",
                      controller: amountController,
                      keyboardType: TextInputType.number,
                    ),

                    // Loan Start Date & Requested Installments (Row)
                    Row(
                      children: [
                        Expanded(
                          child: customDatePicker(
                            icon: Icons.date_range,
                            label: "Loan Start Date",
                            selectedDate: startDate,
                            controller: startDateController,
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2023),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setState(() {
                                  startDate = picked;
                                  startDateController.text = DateFormat(
                                    'MMM dd, yyyy',
                                  ).format(picked);
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: customTextField(
                            icon: Icons.format_list_numbered,
                            label: "Installments",
                            controller: installmentController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),

                    // Remark
                    customTextField(
                      icon: Icons.comment,
                      label: "Remark",
                      controller: remarkController,
                    ),

                    const SizedBox(height: 15),
                    // Submit Button
                    ElevatedButton.icon(
                      onPressed: () async {
                        final totalAmount =
                            double.tryParse(amountController.text) ?? 0.0;
                        final totalInstallments =
                            int.tryParse(installmentController.text) ?? 1;
                        //final employeeName = "Bharat Rajora (EMP-1024)";

                        if (startDate != null &&
                            totalAmount > 0 &&
                            totalInstallments > 0) {
                          /*setState(() {
                          isLoading = true;
                        });*/
                          //sendLoanRequest(context);
                          updateLoanRequest(context);
                        } else {
                          // Optionally show error if fields are missing
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill all required fields'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.update),
                      label: const Text(
                        "Update",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),

              //const SizedBox(height: 32),
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (breakupList.isNotEmpty) ...[
                const Divider(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Loan Breakup Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: breakupList.length,
                  itemBuilder: (context, index) {
                    final item = breakupList[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['employee']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        item['status'] == 'Approved'
                                            ? Colors.green.shade100
                                            : Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    item['status']!,
                                    style: TextStyle(
                                      color:
                                          item['status'] == 'Approved'
                                              ? Colors.green.shade800
                                              : Colors.orange.shade800,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            infoRow(
                              Icons.calendar_today,
                              "Installment Months",
                              item['months']!,
                            ),
                            infoRow(
                              Icons.payments,
                              "Installment Amount",
                              "â‚¹ ${item['amount']}",
                            ),
                            infoRow(
                              Icons.date_range,
                              "Disbursement Date",
                              item['date']!,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendLoanRequest(BuildContext context) async {
    // âœ… Proceed with the API call if both checks pass
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanRequestRaiseApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['Remarks'] = remarkController.text;
    request.fields['requestRadio'] = requestType;
    request.fields['LoanType'] = loanTypeSending;
    request.fields['LoanAmount'] = amountController.text;
    request.fields['LoanStartDate'] = startDateController.text;
    request.fields['Instalments'] = installmentController.text;

    try {
      http.StreamedResponse response = await request.send();
      http.Response httpResponse = await http.Response.fromStream(response);

      Navigator.of(context, rootNavigator: true).pop();

      if (httpResponse.statusCode == 200) {
        var mapResponse = json.decode(httpResponse.body);
        String reason = mapResponse['reason'];
        String result = mapResponse['result'];

        if (result.compareToIgnoringCase("Success") == 0) {
          showDialgSucess(context, "${reason.upperCamelCase} ", "Success");
          final totalAmount = double.tryParse(amountController.text) ?? 0.0;
          final totalInstallments =
              int.tryParse(installmentController.text) ?? 1;

          // Simulate delay (e.g., API call)
          await Future.delayed(Duration(seconds: 2));

          final monthlyAmount = (totalAmount / totalInstallments)
              .toStringAsFixed(2);

          List<Map<String, String>> generatedList = [];

          for (int i = 0; i < totalInstallments; i++) {
            final installmentDate = DateTime(
              startDate!.year,
              startDate!.month + i,
              startDate!.day,
            );
            generatedList.add({
              "employee": employeeName.toString(),
              "months": DateFormat('MMMM yyyy').format(installmentDate),
              "amount": monthlyAmount,
              "date": DateFormat('MMM dd, yyyy').format(installmentDate),
              "status": "Pending",
            });
          }

          setState(() {
            breakupList = generatedList;
            isLoading = false;
            isFormExpanded = false; // Collapse form
          });
        } else if (result.compareToIgnoringCase("Error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, "Error");
        }
      }
    } catch (e) {
    }
  }

  Future<void> updateLoanRequest(BuildContext context) async {
    // âœ… Proceed with the API call if both checks pass
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.loanRequestUpdateApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

    // Add static fields
    request.fields['sessionId'] = sessionId!;
    request.fields['remarks'] = remarkController.text;
    request.fields['requestRadio'] = requestType;
    request.fields['loanId'] = loanIdCheck.toString();
    request.fields['loanTypeId'] = loanId.toString();
    request.fields['loanAmount'] = amountController.text;
    request.fields['loanStartDate'] = startDateController.text;
    request.fields['installments'] = installmentController.text;

    // Construct the API URL with parameters (for debugging)
    String apiWithParams =
        '$urlapi?${request.fields.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&')}';

    // Debugging: Print the full API URL with parameters
    try {
      http.StreamedResponse response = await request.send();
      http.Response httpResponse = await http.Response.fromStream(response);

      Navigator.of(context, rootNavigator: true).pop();

      if (httpResponse.statusCode == 200) {
        var mapResponse = json.decode(httpResponse.body);
        String reason = mapResponse['reason'];
        String result = mapResponse['result'];

        if (result.compareToIgnoringCase("Success") == 0) {
          showDialgSucess(context, "${reason.upperCamelCase} ", "Success");
          final totalAmount = double.tryParse(amountController.text) ?? 0.0;
          final totalInstallments =
              int.tryParse(installmentController.text) ?? 1;

          // Simulate delay (e.g., API call)
          await Future.delayed(Duration(seconds: 2));

          final monthlyAmount = (totalAmount / totalInstallments)
              .toStringAsFixed(2);

          List<Map<String, String>> generatedList = [];

          for (int i = 0; i < totalInstallments; i++) {
            final installmentDate = DateTime(
              startDate!.year,
              startDate!.month + i,
              startDate!.day,
            );
            generatedList.add({
              "employee": employeeName.toString(),
              "months": DateFormat('MMMM yyyy').format(installmentDate),
              "amount": monthlyAmount,
              "date": DateFormat('MMM dd, yyyy').format(installmentDate),
              "status": "Pending",
            });
          }

          setState(() {
            breakupList = generatedList;
            isLoading = false;
            isFormExpanded = false; // Collapse form
          });
        } else if (result.compareToIgnoringCase("Error") == 0) {
          showDialgSucess(context, reason.upperCamelCase, "Error");
        }
      }
    } catch (e) {
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
                  //Navigator.of(buildContext).maybePop();
                } else {
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

  Widget customReadOnlyInput({
    required IconData icon,
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget customDropdown({
    required IconData icon,
    required String label,
    required String? value,
    required List<String?> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.indigo),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          //filled: true,
          //fillColor: Colors.grey.shade100,
        ),
        value: value,
        items:
            items.map((item) {
              return DropdownMenuItem<String>(value: item, child: Text(item!));
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget customTextField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.teal),
          labelText: label,
          //filled: true,
          //fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget customDatePicker({
    required IconData icon,
    required String label,
    required DateTime? selectedDate,
    required Function() onTap,
    required TextEditingController controller, // <-- Add this
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller, // <-- Use controller here
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.deepOrange),
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
