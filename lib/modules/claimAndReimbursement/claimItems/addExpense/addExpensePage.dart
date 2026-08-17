import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:er_flutter_project/modules/claimAndReimbursement/claimItems/modalClass/addExpDropPolicyModal.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../modalClass/addExpensesDropsModal.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

String? setPath;
File? file;
var imageValue;
Future<File> _fileFromImageUrl() async {
  final response = await MobileHttpClient.instance.get(
    Uri.parse(
      'https://s3.ap-south-1.amazonaws.com/employroll.com/images/1707640420694.png',
    ),
  );
  //final responseNew = await MobileHttpClient.instance.get(Uri.parse('https://s3.ap-south-1.amazonaws.com/employroll.com/images/1707640420694.png'));

  final documentDirectory = await getApplicationDocumentsDirectory();
  file = File(join(documentDirectory.path, 'imagetest.png'));

  file!.writeAsBytes(response.bodyBytes);
  //imageValue!.writeAsBytes(responseNew.bodyBytes);

  return file!;
}

Map<String, dynamic> mapResponse = {};
Map<String, dynamic> catMapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
List<String?> list = [];
List<String?> expList = [];
List<String?> subExpList = [];
List<String?> catList = [];
List<int?> policyList = [];
List<String?> newList = [];
AddExpDropPolicyModal? addExpDropPolicyLabel;
AddExpensesDrops? addExpensesDropsLabel;
String valuenew = "listText";

class _AddExpensePageState extends State<AddExpensePage> {
  var titleName = "Expense Draft";
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _fromPlaceController = TextEditingController();
  final TextEditingController _toPlaceController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  int? claimIdCheck;
  int? policyIdCheck;
  var dropdownvalue;
  var dropdownvalueType;
  var subExpDropType;
  var catDropType;
  var dropdownNewvalue;
  var expName;
  var expId;
  var expIdNew;
  var subExpName;
  var catName;
  var catId;
  var subExpId;
  var catSubExpId;
  var billShow = false;
  var billAllow = false;

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    // await Future.delayed(Duration(seconds: 5));
    Future<AddExpDropPolicyModal> getAppReq11 = getReimbursementTypeList(
      sessionId!,
    );
    //Future<AddExpensesDrops> getAppReq12 = getExpTypeList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait"),
      ],
    );

    getAppReq11.then((value) {
      setState(() {
        addExpDropPolicyLabel = value;
      });
      //print('employeeList00${advanceRequestedListLabel!.data!.length}');
    });

    /*getAppReq12.then((value) {
      setState(() {
        addExpensesDropsLabel=value;
      });
      //print('employeeList00${advanceRequestedListLabel!.data!.length}');
    });*/
  }

  @override
  void initState() {
    int i = 0;
    _fileFromImageUrl();
    //claimId = addExpDropPolicyLabel?.claimDataList![i].claimId;
    //policyId = addExpDropPolicyLabel?.claimDataList![i].policyId;
    // TODO: implement initState
    super.initState();
    getSharedPrfanceList();
    //getAllCategory(sessionId!);
  }

  Future<AddExpDropPolicyModal> getReimbursementTypeList(
    String SessionId,
  ) async {
    list = [];
    newList = [];
    policyList = [];

    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.addExpDropPolicy;
    AddExpDropPolicyModal addExpensesDrops;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await MobileHttpClient.instance.post(urlapi);

    mapResponse = json.decode(response.body);
    catMapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    addExpensesDrops = AddExpDropPolicyModal.fromJson(mapResponse);
    int length = addExpensesDrops.claimDataList!.length;
    for (int i = 0; i < addExpensesDrops.claimDataList!.length; i++) {
      String? policyName = addExpensesDrops.claimDataList![i].policyName;
      policyIdCheck = addExpensesDrops.claimDataList![i].policyId;
      claimIdCheck = addExpensesDrops.claimDataList![i].claimId;
      String? policyCode = addExpensesDrops.claimDataList![i].policyCode;
      list.add(addExpensesDrops.claimDataList![i].policyName);
      policyList.add(addExpensesDrops.claimDataList![i].policyId);
    }
    String? newPolicyCode = addExpensesDrops.claimDataList![0].policyCode;
    newList.add(addExpensesDrops.claimDataList![0].policyName);

    return addExpensesDrops;
  }

  Future<AddExpensesDrops> getExpTypeList(String SessionId) async {
    list = [];
    expList = [];
    subExpList = [];
    catList = [];
    //newList = [];
    //policyList=[];

    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.addExpenseDrops;
    AddExpensesDrops addExpensesDrops;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$SessionId&"
      "claimId=$claimIdCheck&"
      "policyId=$policyIdCheck",
    );
    final response = await MobileHttpClient.instance.post(urlapi);

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    addExpensesDrops = AddExpensesDrops.fromJson(mapResponse);
    int length = addExpensesDrops.expenseDataList!.length;
    for (int i = 0; i < addExpensesDrops.expenseDataList!.length; i++) {
      expName = addExpensesDrops.expenseDataList![i].expenseName;

      expList.add(addExpensesDrops.expenseDataList![i].expenseName);
      policyList.add(addExpensesDrops.expenseDataList![i].expenseId);
    }
    for (int i = 0; i < addExpensesDrops.subExpDataList!.length; i++) {
      subExpName = addExpensesDrops.subExpDataList![i].subExpName;
      subExpId = addExpensesDrops.subExpDataList![i].subExpId;
      subExpList.add(addExpensesDrops.subExpDataList![i].subExpName);
      //policyList.add(addExpensesDrops.expenseDataList![i].expenseId);
    }
    for (int i = 0; i < addExpensesDrops.catDataList!.length; i++) {
      catId = addExpensesDrops.catDataList![i].catId;
      catList.add(addExpensesDrops.catDataList![i].catName);
    }

    /*for(int i=0; i<addExpensesDrops.catDataList!.length;i++){
      catName = addExpensesDrops.catDataList![i].catName;
      catSubExpId = addExpensesDrops.catDataList![i].subExpId;
      print(" Category SubExpId - $catSubExpId");
      if(subExpId == catSubExpId) {
        //catList.add(addExpensesDrops.catDataList![i].catName);
      }



      //policyList.add(addExpensesDrops.expenseDataList![i].expenseId);
      print('Category Name $catName');
      print('Category SubExpId $catSubExpId');
      print('dataExpense $policyId');
      print('dataExpense $claimId');
    }*/

    //String? newPolicyCode = addExpensesDrops.expenseDataList![0].policyCode;
    //newList.add(addExpensesDrops.expenseDataList![0].expenseName);


    return addExpensesDrops;
  }

  List categoryItemlist = [];

  Future getAllCategory(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.addExpDropPolicy;
    var baseUrl = Uri.parse("$conn$apiUrl?sessionId=$SessionId");

    final response = await MobileHttpClient.instance.post(baseUrl);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryItemlist = jsonData;
      });
    }
  }

  final ImagePicker _picker = ImagePicker();
  TextEditingController filePath = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    void imagePickerModal(
      BuildContext context, {
      VoidCallback? onCameraTap,
      VoidCallback? onGalleryTap,
    }) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 120,
            child: Column(
              children: [
                OverflowBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          //ImagePicker picker = ImagePicker();
                          imageValue = await _picker.pickImage(
                            source: ImageSource.camera,
                          );

                          //picker.dispose();
                          if (imageValue == null) return;
                          setState(() {
                            final imagePath = File(imageValue!.path);
                            //this._workDoneImage=imagePath;
                            file = File(imageValue!.path);
                            filePath.text = File(imageValue!.path).toString();
                          });
                          imageValue = null;
                          //imageCache.clear();
                        } on Exception catch (e) {
                        }
                        Navigator.pop(context);
                      },
                      child: "Camera".text.make(),
                    ).px8(),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final result = await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                          );
                          if (result == null) return;

                          final file = result.files.first;
                          filePath.text = file.name;
                          //print('Bytes: ${file.bytes}');

                          //print('Size: ${file.size}');
                          //print('Size: ${file.extension}');
                          //print('Path: ${file.path}');

                          final newFile = await saveFilePermanently(file);
                          //openFiles(result.files);
                          final kb = file.size / 1024;
                          final mb = kb / 1024;
                          final fileSize =
                              mb >= 1
                                  ? '${mb.toStringAsFixed(2)} MB'
                                  : '${kb.toStringAsFixed(2)} KB';
                          final extension = file.extension ?? 'none';
                          /*setState(() {
          //filePath.text=file.name;
          //print('File Object: $file');
        });*/
                        } catch (e) {
                        }
                        Navigator.pop(context);
                      },
                      child: "Gallery".text.make(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(title: titleName.text.make()),

        body: Container(
          height: height,
          color: Mythemes.whitish,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child:
                            TextFormField(
                              onTap: () async {
                                DateTime? fromDate = DateTime.now();
                                FocusScope.of(
                                  context,
                                ).requestFocus(FocusNode());

                                fromDate = await showDatePicker(
                                  context: context,
                                  initialDate: fromDate,
                                  firstDate: DateTime(1947),
                                  lastDate: DateTime.now().add(
                                    Duration(days: 0),
                                  ),
                                );
                                setState(() {
                                  //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                                  _fromDateController.text = DateFormat(
                                    "dd-MM-yyyy",
                                  ).format(fromDate!);
                                });

                              },
                              readOnly: true,
                              enabled: true,
                              controller: _fromDateController,
                              // initialValue: "Head Office",
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  size: 18,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                labelText: "From Date",
                                hintStyle: TextStyle(fontSize: 12),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Mythemes.blackish,
                                ),
                              ),
                            ).p8(),
                      ),
                      Expanded(
                        child:
                            TextFormField(
                              onTap: () async {
                                DateTime? toDate = DateTime.now();
                                FocusScope.of(
                                  context,
                                ).requestFocus(FocusNode());

                                toDate = await showDatePicker(
                                  context: context,
                                  initialDate: toDate,
                                  firstDate: DateTime(1947),
                                  lastDate: DateTime.now().add(
                                    Duration(days: 0),
                                  ),
                                );
                                setState(() {
                                  //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                                  _toDateController.text = DateFormat(
                                    "dd-MM-yyyy",
                                  ).format(toDate!);
                                });

                              },
                              readOnly: true,
                              enabled: true,
                              controller: _toDateController,
                              // initialValue: "Head Office",
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  size: 18,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                labelText: "To Date",
                                hintStyle: TextStyle(fontSize: 12),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Mythemes.blackish,
                                ),
                              ),
                            ).p8(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                            TextFormField(
                              controller: _fromPlaceController,
                              enabled: true,
                              // initialValue: "Head Office",
                              //maxLines: 3,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                //labelText: "Select Department",
                                hintText: "From Place",
                                labelText: "From Place",
                                hintStyle: TextStyle(fontSize: 14),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Mythemes.blackish,
                                ),
                              ),
                            ).p8(),
                      ),
                      Expanded(
                        child:
                            TextFormField(
                              controller: _toPlaceController,
                              enabled: true,
                              // initialValue: "Head Office",
                              //maxLines: 3,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                //labelText: "Select Department",
                                hintText: "To Place",
                                labelText: "To Place",
                                hintStyle: TextStyle(fontSize: 14),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Mythemes.blackish,
                                ),
                              ),
                            ).p8(),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child:
                            TextFormField(
                              controller: _purposeController,
                              enabled: true,
                              // initialValue: "Head Office",
                              //maxLines: 3,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                //labelText: "Select Department",
                                hintText: "Add Purpose",
                                labelText: "Purpose",
                                hintStyle: TextStyle(fontSize: 14),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Mythemes.blackish,
                                ),
                              ),
                            ).p8(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                            DropdownButtonFormField(
                              value: dropdownvalue,
                              decoration: InputDecoration(
                                //enabled: true,
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                //labelText: "Select Department",
                                hintText: "Select",
                                labelText: "Reimbursement Type",
                                hintStyle: TextStyle(fontSize: 14),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: Mythemes.blackish,
                                ),
                              ),
                              items:
                                  newList.map<DropdownMenuItem<String>>((
                                    String? value,
                                  ) {
                                    final truncatedValue =
                                        value!.length > 18
                                            ? '${value.substring(0, 18)}...'
                                            : value;
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        truncatedValue,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ), // Adjust the font size as needed
                                      ),
                                    );
                                  }).toList(),

                              /*categoryItemlist.map((item) {
                      return DropdownMenuItem(
                        value: item['ClassCode'].toString(),
                        child: Text(item['ClassName'].toString()),
                      );
                    }).toList(),*/
                              onChanged: (newVal) {
                                // print('valuestring $newVal');
                                valuenew = newVal.toString();
                                int i = list.indexOf(valuenew);
                                int? policyidnew = policyList.elementAt(i);
                                setState(() {
                                  dropdownvalue = newVal;
                                  Future<AddExpensesDrops> getAppReq12 =
                                      getExpTypeList(sessionId!);
                                  getAppReq12.then((value) {
                                    setState(() {
                                      addExpensesDropsLabel = value;
                                    });
                                    //print('employeeList00${advanceRequestedListLabel!.data!.length}');
                                  });
                                });
                              },
                            ).p8(),
                      ),

                      /*FutureBuilder<List<String>>(
                        future: getAddExpDrops(),
                          builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data!;
                            return
                          } else {
                            return const CircularProgressIndicator();
                          }
                          }
                      ),*/
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                            DropdownButtonFormField(
                              value: dropdownvalueType,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                //labelText: "Select Department",
                                hintText: "Select",
                                labelText: "Expense Type",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                  color: Mythemes.blackish,
                                ),
                              ),
                              items:
                                  expList.map<DropdownMenuItem<String>>((
                                    String? value,
                                  ) {
                                    // Truncate the value if it exceeds a certain length
                                    final truncatedValue =
                                        value!.length > 18
                                            ? '${value.substring(0, 18)}...'
                                            : value;
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        truncatedValue,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ), // Adjust the font size as needed
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  dropdownvalueType = value;
                                  valuenew = value.toString();
                                  int i = expList.indexOf(valuenew);
                                  expIdNew =
                                      mapResponse['expenseDataList'][i]['expenseId'];

                                  /*subExpId = mapResponse['subExpDataList'][i]['expenseId'];
                                    subExpName = mapResponse['subExpDataList'][i]['subExpName'];
                                    print('SUB EXPENSE ID -  $subExpId');
                                    print('SUB EXPENSE NAMe -  $subExpName');*/

                                  /* for(int i=0; i<addExpensesDropsLabel!.subExpDataList!.length;i++){
                                      subExpList = [];
                                      subExpList.add(addExpensesDropsLabel!.subExpDataList![i].subExpName);
                                    }*/

                                  /*for(int i=0; i<addExpensesDropsLabel!.subExpDataList!.length;i++){
                                      print("Sub Exp List COunt");
                                      print(addExpensesDropsLabel!.subExpDataList!.length);

                                      print("Sub Exp Id - $subExpId");
                                      subExpList.add(addExpensesDropsLabel!.subExpDataList![i].subExpName);
                                     */ /* if(expId == subExpId) {

                                      }*/ /*
                                    }*/
                                });
                              },
                            ).p8(),
                      ),
                      Expanded(
                        child:
                            DropdownButtonFormField(
                              value: subExpDropType,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                //labelText: "Select Department",
                                hintText: "Select",
                                labelText: "Sub Expense Type",
                                hintStyle: TextStyle(fontSize: 14),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Mythemes.blackish,
                                ),
                              ),
                              items:
                                  subExpList.map<DropdownMenuItem<String>>((
                                    String? value,
                                  ) {
                                    // Truncate the value if it exceeds a certain length
                                    final truncatedValue =
                                        value!.length > 18
                                            ? '${value.substring(0, 18)}...'
                                            : value;
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        truncatedValue,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ), // Adjust the font size as needed
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                catList = [];
                                setState(() {
                                  subExpDropType = value;
                                  valuenew = value.toString();
                                  int i = subExpList.indexOf(valuenew);
                                  subExpId =
                                      mapResponse['subExpDataList'][i]['subExpId'];

                                  for (
                                    int j = 0;
                                    j <
                                        addExpensesDropsLabel!
                                            .catDataList!
                                            .length;
                                    j++
                                  ) {
                                    catSubExpId =
                                        addExpensesDropsLabel!
                                            .catDataList![j]
                                            .subExpId;
                                    if (subExpId ==
                                        addExpensesDropsLabel!
                                            .catDataList![j]
                                            .subExpId) {
                                      catList.add(
                                        addExpensesDropsLabel!
                                            .catDataList![j]
                                            .catName,
                                      );
                                    }
                                  }

                                  /*catSubExpId = mapResponse['catDataList'][i]['subExpId'];
                                  catName = mapResponse['catDataList'][i]['catName'];
                                  print('CATEGORY SUB EXPENSE ID -  $catSubExpId');
                                  print('CATEGORY NAME -  $catName');*/

                                  /*if(subExpId == catSubExpId) {
                                    catList = [];
                                    for(int j=0; j<addExpensesDropsLabel!.subExpDataList!.length;j++){
                                      catList.add(mapResponse['catDataList'][j]['catName']);
                                    }


                                  }*/
                                });
                              },
                            ).p8(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                            DropdownButtonFormField(
                              value: catDropType,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                //labelText: "Select Department",
                                hintText: "Select",
                                labelText: "Category",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Mythemes.blackish,
                                ),
                              ),
                              items:
                                  catList.map<DropdownMenuItem<String>>((
                                    String? value,
                                  ) {
                                    // Truncate the value if it exceeds a certain length
                                    final truncatedValue =
                                        value!.length > 18
                                            ? '${value.substring(0, 18)}...'
                                            : value;
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        truncatedValue,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ), // Adjust the font size as needed
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  catDropType = value;
                                  int i = catList.indexOf(valuenew);
                                  for (
                                    int j = 0;
                                    j <
                                        addExpensesDropsLabel!
                                            .catDataList!
                                            .length;
                                    j++
                                  ) {
                                    catId =
                                        addExpensesDropsLabel!
                                            .catDataList![j]
                                            .catId;
                                  }
                                });
                              },
                            ).p8(),
                      ),
                      Expanded(
                        child:
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _distanceController,
                              enabled: true,
                              // initialValue: "Head Office",
                              //maxLines: 3,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                //labelText: "Select Department",
                                hintText: "0",
                                labelText: "Distance",
                                hintStyle: TextStyle(fontSize: 14),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Mythemes.blackish,
                                ),
                              ),
                            ).p8(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                            TextFormField(
                              controller: _remarksController,
                              enabled: true,
                              // initialValue: "Head Office",
                              //maxLines: 3,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                //labelText: "Select Department",
                                hintText: "Approved Amount",
                                labelText: "Remarks",
                                hintStyle: TextStyle(fontSize: 14),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Mythemes.blackish,
                                ),
                              ),
                            ).p8(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _amountController,
                              enabled: true,
                              // initialValue: "Head Office",
                              //maxLines: 3,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                //labelText: "Select Department",
                                hintText: "1200",
                                labelText: "Amount",
                                hintStyle: TextStyle(fontSize: 14),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Mythemes.blackish,
                                ),
                              ),
                            ).p8(),
                      ),
                      Expanded(
                        child:
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Mythemes.blackishade,
                                  ),
                                ),
                                //labelText: "Select Department",
                                hintText: "Select",
                                labelText: "Bill Available",
                                hintStyle: TextStyle(fontSize: 14),
                                contentPadding: EdgeInsets.all(5),
                                /*border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(8))),*/
                                // labelText: "Location",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Mythemes.blackish,
                                ),
                              ),
                              items: [
                                DropdownMenuItem(value: 1, child: Text('Yes')),
                                DropdownMenuItem(value: 2, child: Text('No')),

                                /* DropdownMenuItem(
                                      child: Text('Advance'),
                                      value: 2,
                                    ),*/
                              ],
                              onChanged: (int? value) {
                                setState(() {
                                  value = value!;

                                  if (value == 1) {
                                    billShow = true;
                                    billAllow = true;
                                  } else {
                                    billShow = false;
                                    billAllow = false;
                                  }
                                });
                              },
                            ).p8(),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: billShow,
                    child: Row(
                      children: [
                        Expanded(
                          child:
                              TextFormField(
                                controller: filePath,
                                onTap:
                                    () => imagePickerModal(
                                      context,
                                      onCameraTap: () {},
                                      onGalleryTap: () {},
                                    ),
                                //style: TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis),
                                // Remove readOnly property
                                decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.upload_file),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Mythemes.blackishade,
                                    ),
                                  ),
                                  //hintText: filePath.text,
                                  labelText: "Add Document",
                                  hintStyle: TextStyle(fontSize: 14),
                                  contentPadding: EdgeInsets.all(5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Mythemes.blackish,
                                  ),
                                ),
                              ).p8(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 80,
          color: context.cardColor,
          child: OverflowBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  //Navigator.pushNamed(context, MyRoutings.singleDateAttendanceRoute);
                  file ?? 0;
                  saveExpense(
                    sessionId!,
                    _fromDateController.text,
                    _toDateController.text,
                    _fromPlaceController.text,
                    _toPlaceController.text,
                    _purposeController.text,
                    "PENDING",
                    claimIdCheck.toString(),
                    policyIdCheck.toString(),
                    catId.toString(),
                    subExpId.toString(),
                    expIdNew.toString(),
                    _remarksController.text,
                    _amountController.text,
                    billAllow,
                    _distanceController.text,
                    "0",
                    "0",
                    file!,
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Mythemes.lightBluishColor,
                  ),
                ),
                child: "Submit".text.make(),
              ).wh(150, 40).py12(),
            ],
          ),
        ),
      ),
    );
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

  Future<void> saveExpense(
    String sessionId,
    String fromDate,
    String toDate,
    String fromPlace,
    String toPlace,
    String purpose,
    String status,
    String claimId,
    String policyId,
    String categoryId,
    String subExpId,
    String expId,
    String remarks,
    String claimedAmt,
    bool billAllow,
    String perKm,
    String claimNumberRequition,
    String claimReqId,
    File document,
  ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.saveExpenses;
    CommonNotificationPage.showLoaderDialog(this.context);

    /*var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "id=0&"
        "orgId=151&"
        "empId=8&"
        "worktype=$workTypeId&"
        "locations=$locationId&"
        "radioNmr=$radioNmr&"
        "singleDate1=$singleDate1&"
        "totalDays=$totalDays&"
        "radioShift=$radioShift&"
        "totalShift=$totalShift&"
        "remark=$remark&"
        "sublocations=0&"
        "status=$status&"
        "image=&"
        "shift=$shift&"
        "workmen=$workerRequired&"
        "unskilled=$unskill&"
        "skilled=$skill"
    );*/
    var uri = Uri.parse(
      "http://www.employroll.com/restful/service/claim/requisition/form/details/save",
    );
    var request = http.MultipartRequest("Post", uri);
    request.fields['sessionId'] = sessionId;
    request.fields['fromDate'] = _fromDateController.text;
    request.fields['toDate'] = _toDateController.text;
    request.fields['fromPlace'] = _fromPlaceController.text;
    request.fields['toPlace'] = _toPlaceController.text;
    request.fields['purpose'] = _purposeController.text;
    request.fields['status'] = "PENDING";
    request.fields['claimId'] = claimIdCheck.toString();
    request.fields['policyId'] = policyIdCheck.toString();
    request.fields['categoryId'] = catId.toString();
    request.fields['subExpId'] = subExpId;
    request.fields['expenseId'] = "$expIdNew";
    request.fields['remarks'] = _remarksController.text;
    request.fields['claimedAmt'] = _amountController.text;
    request.fields['billAllow'] = billAllow.toString();
    request.fields['perkilometer'] = _distanceController.text;
    request.fields['claimNumberRequition'] = "0";
    request.fields['claimReqId'] = "0";

    /*  String jsonString = createJsonWithImage(imageValue);

    // Make an HTTP post request with the JSON string
    final response = await MobileHttpClient.instance.post(
      'your_api_endpoint',
      headers: {'Content-Type': 'application/json'},
      body: jsonString,
    );

    // Handle the response as needed
    if (response.statusCode == 200) {
      print('Image sent successfully');
    } else {
      print('Failed to send image. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }*/

    /*   var stream = http.ByteStream(file!.openRead());
    stream.cast();
    var length = await file!.length();
    print('Response status: ${length}');
    print('Response body: ${stream}');
    print('Response body: ${file}');
    print("$stream");

    var multipart = new http.MultipartFile('document', stream, length,
        filename: basename('image.jpg'));
    request.files.add(multipart);*/
    /*request.files.add(new http.MultipartFile.fromBytes('file',
        await File.fromUri(imageValue!.path).readAsBytes(),
        contentType: new MediaType('image', 'jpeg')));*/

    /*request.send().then((response) {
      if (response.statusCode == 200) print("Uploaded!");
    });*/

    /*if(value!.length()!=0){

    }*/

    // Send the request
    //var response = await request.send();

    http.Response response = await http.Response.fromStream(
      await request.send(),
    );

    //final response = await MobileHttpClient.instance.post(urlapi);
    if (response.statusCode == 200) {
      var responseResult = response.body;
      Navigator.pop(this.context);
      mapResponse = json.decode(response.body);
      //String reason = mapResponse['reason'];
      //String status = mapResponse['status'];
      String result = mapResponse['result'];
      //print('reason both $reason $status');
      //print('reason${reason}');
      if (result.compareToIgnoringCase("success") == 0) {
        CommonNotificationPage.showDialgSucess(
          this.context,
          "${result.upperCamelCase} ",
          "Success",
        );
      } else if (result.compareToIgnoringCase("error") == 0) {
        CommonNotificationPage.showDialgSucess(
          this.context,
          result.upperCamelCase,
          " Error ",
        );
      }
    }
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
