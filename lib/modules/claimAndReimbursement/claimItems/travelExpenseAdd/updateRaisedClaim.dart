import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:er_flutter_project/modules/claimAndReimbursement/claimItems/claimRequisitionList.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../ess/EssDashboarrddModel.dart';
import '../../../../ess/essDashboardNavigate.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../newModalClasses/categoriesModalClass.dart';
import '../../newModalClasses/reimbursementTypeModal.dart';


class TravelExpenseRequestUpdate extends StatefulWidget {
  String? reimbursementType;
  String? expCategory;
  String? subExpCategory;
  String? travelFrom;
  String? travelTo;
  String? odometerStart;
  String? odometerEnd;
  String? merchant;
  String? kilometers;
  String? month;
  String? date;
  String? claimedAmount;
  String? remarks;
  String? documents;
  String? claimIdCheck;

  TravelExpenseRequestUpdate(
      this.reimbursementType,
      this.expCategory,
      this.subExpCategory,
      this.travelFrom,
      this.travelTo,
      this.odometerStart,
      this.odometerEnd,
      this.merchant,
      this.kilometers,
      this.month,
      this.date,
      this.claimedAmount,
      this.remarks,
      this.documents,
      this.claimIdCheck,
      );

  @override
  State<TravelExpenseRequestUpdate> createState() => _TravelExpenseRequestUpdateState(
    reimbursementType,
    expCategory,
    subExpCategory,
    travelFrom,
    travelTo,
    odometerStart,
    odometerEnd,
    merchant,
    kilometers,
    month,
    date,
    claimedAmount,
    remarks,
    documents,
    claimIdCheck,
  );
}

late List<String?> reimbursementTypeList = [];
late List<String?> expCategoryList = [];
late List<String?> subExpCategoryList = [];
late List<String?> subSubExpCategoryList = [];

List<CardData> cardList = [];

SessionManager sessionManager=SessionManager();
Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
dynamic empId;
late var result;
var reimbursementId;
var expCategoryId;
var subExpCategoryId;
var subSubExpCategoryId;
String valuenew="listText";
String valuenewSub="listText";
String valuenewDesignation="listText";
String valuenewUserType="listText";

dynamic expenseCatShow = false;
dynamic subExpenseCatShow = false;
dynamic subSubExpenseCatShow = false;
dynamic travelFromToShow = false;
dynamic odometerRowShow = false;
dynamic merchantShow = false;
dynamic kmShow = false;
dynamic monthShow = false;
dynamic dateShow = false;
dynamic claimAmtShow = false;
dynamic remarksShow = false;
dynamic addDocShow = false;

class _TravelExpenseRequestUpdateState extends State<TravelExpenseRequestUpdate> {
  _TravelExpenseRequestUpdateState(
      String? reimbursementType,
      String? expCategory,
      String? subExpCategory,
      String? travelFrom,
      String? travelTo,
      String? odometerStart,
      String? odometerEnd,
      String? merchant,
      String? kilometers,
      String? month,
      String? date,
      String? claimedAmount,
      String? remarks,
      String? documents,
      String? claimIdCheck
      );
  CategoriesModalClass? categoriesModalClass;
  var titleName = "Claim Requisition";
  ReimbursementTypeListModal? reimbursementTypeListModal;

  //DOC Upload Code
  File? uploadedFile; // To store the selected file
  final ImagePicker _picker = ImagePicker();

  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 120,
          child: Column(
            children: [
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context); // Close the modal
                      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        setState(() {
                          uploadedFile = File(pickedFile.path);
                        });
                      }
                    },
                    child: Text("Camera"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context); // Close the modal
                      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          uploadedFile = File(pickedFile.path);
                        });
                      }
                    },
                    child: Text("Browse"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    cardList = [];
    addNewCard();
    getSharedPrfanceList();

    // TODO: implement initState
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    empId = await shared!.getEmpId();
    Future<ReimbursementTypeListModal> getEmployeeList13 = getReimbursementTypeList(sessionId!);
    getEmployeeList13.then((value) {
      setState(() {
        reimbursementTypeListModal=value;
      });

      expenseCatShow = false;
      subExpenseCatShow = false;
      subSubExpenseCatShow = false;
      travelFromToShow = false;
      odometerRowShow = false;
      merchantShow = false;
      kmShow = false;
      monthShow = false;
      dateShow = false;
      claimAmtShow = false;
      remarksShow = false;
      addDocShow = false;
      //print('employeeList00${inductionListLabel!.data!.length}');
    });
  }

  var localConveyanceTaxi = false;
  var conveyance_policy = false;
  var mobileReimbursement = false;
  var claimIdCheck;
  var claimedAmtCheck;
  var endReading;
  var odometer;
  var claimRaiseId;
  var claimReqId;

  Future<ReimbursementTypeListModal> getReimbursementTypeList(String sessionId) async {
    reimbursementTypeList=[];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.reimbursementTypeListApi;

    //print('employeeList11: ${SessionId}');
    ReimbursementTypeListModal reimbursementTypeListModal;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId");
    final response = await http.post(urlapi);
    //print("Status $status");
    //print(inductionListLabel!.data!.length);
    print('LOcations ${response.request}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['claimDataList'];
    print('responseemployeeList $getData');
    reimbursementTypeListModal=ReimbursementTypeListModal.fromJson(mapResponse);

    for(int i=0; i<mapResponse['claimDataList'].length;i++){
      reimbursementTypeList.add(mapResponse['claimDataList'][i]['policyName'].toString());
      reimbursementId = mapResponse['claimDataList'][i]['policyId'].toString();

      print('ID -  $reimbursementId');
      //print("HalfDayShow $halfDayRadioShow");
    }

    return reimbursementTypeListModal;
  }

  Future<void> defaultApiCheck(String sessionId, reimbursementId) async {
    try {
      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.reimburseDefaultApiCheck;
      var urlapi = Uri.parse("$conn$apiUrl?"
          "sessionId=$sessionId&"
          "policyId=$reimbursementId");

      // Make the HTTP request
      final response = await http.post(urlapi);

      print('Default Check API - ${response.request}');

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode the JSON response
        Map<String, dynamic> mapResponse = json.decode(response.body);

        // Extract the required values
        claimIdCheck = mapResponse['claimId'];

        localConveyanceTaxi = mapResponse['localConveyanceTaxi'] ?? false;
        conveyance_policy = mapResponse['conveyance_policy'] ?? false;
        mobileReimbursement = mapResponse['mobileReimbursement'] ?? false;
        String status = mapResponse['status'];
        claimIdCheck = mapResponse['claimId'];

        // Print the values to confirm they are retrieved correctly
        print('Claim ID: $claimIdCheck');
        print('Local Conveyance Taxi: $localConveyanceTaxi');
        print('Mobile Reimbursement: $mobileReimbursement');
        print('Conveyance Policy: $conveyance_policy');
        print('Status: $status');

        Future<CategoriesModalClass> getCats = getCategories(sessionId);
        getCats.then((value) {
          print("I am Category");
          setState(() {
            categoriesModalClass=value;
            if(conveyance_policy == true) {
              expenseCatShow = true;
              subExpenseCatShow = true;
              subSubExpenseCatShow = true;
              travelFromToShow = true;
              monthShow = true;
              dateShow = true;
              claimAmtShow = true;
              remarksShow = true;
            }
            if(localConveyanceTaxi == true) {
              expenseCatShow = true;
              subExpenseCatShow = true;
              subSubExpenseCatShow = false;
              travelFromToShow = true;
              merchantShow = true;
              monthShow = true;
              dateShow = true;
              kmShow = true;
              claimAmtShow = true;
              odometerRowShow = true;
              remarksShow = true;
            }
            if(mobileReimbursement == true) {
              expenseCatShow = true;
              subExpenseCatShow = true;
              subSubExpenseCatShow = false;
              travelFromToShow = false;
              merchantShow = true;
              monthShow = true;
              dateShow = true;
              kmShow = false;
              claimAmtShow = true;
              odometerRowShow = false;
              remarksShow = true;
            }
          });

          //print('employeeList00${inductionListLabel!.data!.length}');
        });

        // You can now use these values in your app as needed
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<CategoriesModalClass> getCategories(String sessionId) async {
    expCategoryList = [];
    subExpCategoryList = [];
    subSubExpCategoryList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.categoriesApi;

    //print('employeeList11: ${SessionId}');
    CategoriesModalClass categoriesModalClass;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "defaultLocalConv=$localConveyanceTaxi&"
        "defaultTravelPolicy=$conveyance_policy&"
        "defaultMobile=$mobileReimbursement&"
        "policyId=$reimbursementId");
    final response = await http.post(urlapi);
    //print("Status $status");
    //print(inductionListLabel!.data!.length);
    print('LOcations ${response.request}');

    mapResponse = json.decode(response.body);
    /* var getData = mapResponse['data'];
    print('responseemployeeList $getData');*/
    categoriesModalClass=CategoriesModalClass.fromJson(mapResponse);

    //Expense Category List
    for(int i=0; i<mapResponse['expenseDataList'].length;i++){
      expCategoryList.add(mapResponse['expenseDataList'][i]['expenseName'].toString());
      expCategoryId = mapResponse['expenseDataList'][i]['expenseId'].toString();

      print('Cat ID -  $expCategoryId');
    }
    //Sub Expense Category List
    for(int i=0; i<mapResponse['subExpDataList'].length;i++){
      subExpCategoryList.add(mapResponse['subExpDataList'][i]['subExpName'].toString());
      subExpCategoryId = mapResponse['subExpDataList'][i]['subExpId'].toString();

      print('Sub Cat ID -  $subExpCategoryId');
    }
    //Sub Sub Expense Category List
    for(int i=0; i<mapResponse['catDataList'].length;i++){
      subSubExpCategoryList.add(mapResponse['catDataList'][i]['catName'].toString());
      subSubExpCategoryId = mapResponse['catDataList'][i]['catId'].toString();

      print('Sub Sub Cat ID -  $subSubExpCategoryId');
    }

    return categoriesModalClass;
  }

  bool isExpanded = true;
  bool isExpandedDefault = true;

  void expandTile() {
    setState(() {
      isExpanded = true;
      // keyTile = UniqueKey();
    });
  }

  String? selectedDate;
  void shrinkTile() {
    setState(() {
      isExpanded = false;
      // keyTile = UniqueKey();
    });
  }
  List<int> _selectedDropdownValues = [];
  List<int> _selectedDropdownValuesOne = [];
  List<int> _selectedDropdownValuesTwo = [];

  List<List<DropdownMenuItem<int>>> _dropdownItems = [];
  List<List<DropdownMenuItem<int>>> _dropdownItemsOne = [];
  List<List<DropdownMenuItem<int>>> _dropdownItemsTwo = [];
  void addNewCard() {
    print("Added");
    setState(() {
      cardList.add(
        CardData(
          fromPlaceController: TextEditingController(),
          toPlaceController: TextEditingController(),
          odometerStartController: TextEditingController(),
          odometerEndController: TextEditingController(),
          merchantController: TextEditingController(),
          kilometerController: TextEditingController(),
          monthController: TextEditingController(),
          dateController: TextEditingController(),
          claimedAmtController: TextEditingController(),
          remarksController: TextEditingController(),
          dropdownValue: "", // or set a default value
          catDropType: "",
          subCatDropType: "",
          subSubCatDropType: "",

        ),

      );
      _selectedDropdownValues.add(0);
      _dropdownItems.add([
        DropdownMenuItem(value: 0, child: Text('Item 1')),
        DropdownMenuItem(value: 1, child: Text('Item 2')),
        DropdownMenuItem(value: 2, child: Text('Item 3')),
      ]);

      _selectedDropdownValuesOne.add(0);
      _dropdownItemsOne.add([
        DropdownMenuItem(value: 0, child: Text('Item 1')),
        DropdownMenuItem(value: 1, child: Text('Item 2')),
        DropdownMenuItem(value: 2, child: Text('Item 3')),
      ]);
      _selectedDropdownValuesTwo.add(0);
      _dropdownItemsTwo.add([
        DropdownMenuItem(value: 0, child: Text('Item 1')),
        DropdownMenuItem(value: 1, child: Text('Item 2')),
        DropdownMenuItem(value: 2, child: Text('Item 3')),
      ]);
    });
  }

  List newList = [];

  final TextEditingController _fromPlaceController = TextEditingController();
  final TextEditingController _toPlaceController = TextEditingController();
  final TextEditingController _odometerStartController = TextEditingController();
  final TextEditingController _odometerEndController = TextEditingController();
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _claimAmtController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  int currentIndex = 2;
  var dropdownvalue="0";
  var catDropType="0";
  var subCatDropType="0";
  var dropdownNewvalue;
  var dropdownNewvalueNew;
  var dropdownExpCatValue;
  var dropdownSubExpCatValue;
  var dropdownSubSubExpCatValue;

  String singleDateString="";

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          /* actions: [
             "₹1200 - Total CA".text.size(10).bold.color(Mythemes.successColor).make().px(10)
          ],*/
          title: titleName.text.make(),
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Ensures circular shape
          ),
          mini: false,
          onPressed: () async {
            isExpanded = false;
            addNewCard();
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetAttendanceDet()));
          },
          backgroundColor: Mythemes.lightBluishColor,
          child: Icon(Icons.add, color: Mythemes.whitish,),
        ),

        body: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: cardList.length,
                itemBuilder: (context, index) {
                  final cardData = cardList[index];
                  void calculateKilometers() {
                    final startText = cardData.odometerStartController.text;
                    final endText = cardData.odometerEndController.text;

                    if (startText.isNotEmpty && endText.isNotEmpty) {
                      final start = int.tryParse(startText);
                      final end = int.tryParse(endText);
                      print("Run 1");
                      if (start != null && end != null && end >= start) {
                        final kms = end - start;
                        cardData.kilometerController.text = kms.toString();
                        print("Run 2");
                      } else {
                        // Invalid range, clear kilometer field
                        cardData.kilometerController.text = '';
                      }
                    } else {
                      // One of the fields is empty, clear kilometer field
                      cardData.kilometerController.text = '';
                    }
                  }
                  return Card(
                      elevation: 2,
                      child: ExpansionTile(
                          initiallyExpanded: isExpanded,
                          childrenPadding: EdgeInsets.all(16).copyWith(top: 0),
                          title: "Claim ${index+1}"
                              .text
                              .make(),
                          trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  cardList.removeAt(index);
                                });

                              },
                              icon: Icon(Icons.delete, color: Mythemes.dangerColor,
                              )),
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      "Update Claim".text.bold.size(16).make()
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField(
                                          value: cardData.dropdownValue.isEmpty ? null : cardData.dropdownValue,
                                          decoration: InputDecoration(
                                            //enabled: true,
                                            enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                              borderSide: BorderSide(
                                                  width: 1, color: Mythemes.blackishade),
                                            ),
                                            //labelText: "Select Department",
                                            hintText: "Select",
                                            labelText: "Reimbursement Type",
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                            ),
                                            contentPadding: EdgeInsets.all(5),
                                            /*border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.all(Radius.circular(8))),*/
                                            // labelText: "Location",
                                            labelStyle: TextStyle(
                                                fontWeight: FontWeight.w500,fontSize: 12,
                                                color: Mythemes.blackish),
                                          ),
                                          items: reimbursementTypeList.map<DropdownMenuItem<String>>((String? value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value! , style: TextStyle(fontSize: 12), maxLines: 2),
                                            );

                                          }).toList(),

                                          onChanged: (newVal) {
                                            valuenew = newVal.toString();
                                            print("Type - $valuenew");
                                            for(int i=0; i<reimbursementTypeListModal!.claimDataList!.length;i++){
                                              if(reimbursementTypeListModal!.claimDataList![i].policyName.toString().compareToIgnoringCase(newVal.toString()) ==0)
                                              {
                                                reimbursementId = reimbursementTypeListModal!.claimDataList![i].policyId!.toString();
                                                print("Reimbursement Id $reimbursementId");
                                              }
                                            }
                                            setState(() {
                                              dropdownNewvalueNew = newVal;
                                              defaultApiCheck(sessionId!, reimbursementId);
                                            });
                                            if(valuenew != ""){
                                              expenseCatShow = true;
                                              subExpenseCatShow = true;
                                              subSubExpenseCatShow = true;
                                            }




                                          },

                                        ).p8(),

                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Visibility(
                                        visible: expenseCatShow,
                                        child: Expanded(
                                          child:  DropdownButtonFormField(
                                            value: cardData.catDropType.isEmpty ? null : cardData.catDropType,
                                            decoration: InputDecoration(
                                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                                borderSide: BorderSide(
                                                    width: 1, color: Mythemes.blackishade),
                                              ),
                                              //labelText: "Select Department",
                                              hintText: "Select",
                                              labelText: "Expense Category",
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  overflow: TextOverflow.ellipsis
                                              ),
                                              contentPadding: EdgeInsets.all(5),
                                              /*border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.all(Radius.circular(8))),*/
                                              // labelText: "Location",
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 12,
                                                  color: Mythemes.blackish),
                                            ),
                                            items: expCategoryList.map<DropdownMenuItem<String>>((String? value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value! , style: TextStyle(fontSize: 10), maxLines: 2),
                                              );

                                            }).toList(),

                                            onChanged: (newVal) {
                                              valuenew = newVal.toString();
                                              for(int i=0; i<categoriesModalClass!.expenseDataList!.length;i++){
                                                if(categoriesModalClass!.expenseDataList![i].expenseName.toString().compareToIgnoringCase(newVal.toString()) ==0)
                                                {
                                                  expCategoryId = categoriesModalClass!.expenseDataList![i].expenseId!.toString();
                                                  print("Exp Id $expCategoryId");
                                                }
                                              }
                                              setState(() {
                                                dropdownExpCatValue = newVal;
                                              });

                                            },

                                          ).p8(),

                                        ),
                                      ),
                                      Visibility(
                                        visible: subExpenseCatShow,
                                        child: Expanded(
                                          child:  DropdownButtonFormField(
                                            value: cardData.subCatDropType.isEmpty ? null : cardData.subCatDropType,
                                            decoration: InputDecoration(
                                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                                borderSide: BorderSide(
                                                    width: 1, color: Mythemes.blackishade),
                                              ),
                                              //labelText: "Select Department",
                                              hintText: "Select",
                                              labelText: "Sub Expense Category",
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  overflow: TextOverflow.ellipsis
                                              ),
                                              contentPadding: EdgeInsets.all(5),
                                              /*border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.all(Radius.circular(8))),*/
                                              // labelText: "Location",
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 12,
                                                  color: Mythemes.blackish),
                                            ),
                                            items: subExpCategoryList.map<DropdownMenuItem<String>>((String? value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value! , style: TextStyle(fontSize: 10), maxLines: 2),
                                              );

                                            }).toList(),

                                            onChanged: (newVal) {
                                              valuenew = newVal.toString();
                                              for(int i=0; i<categoriesModalClass!.subExpDataList!.length;i++){
                                                if(categoriesModalClass!.subExpDataList![i].subExpName.toString().compareToIgnoringCase(newVal.toString()) ==0)
                                                {
                                                  subExpCategoryId = categoriesModalClass!.subExpDataList![i].subExpId!.toString();
                                                  print("Exp Id $subExpCategoryId");
                                                }
                                              }
                                              setState(() {
                                                dropdownSubExpCatValue = newVal;
                                              });

                                            },

                                          ).p8(),

                                        ),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: subSubExpenseCatShow,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child:  DropdownButtonFormField(
                                            value: cardData.subSubCatDropType.isEmpty ? null : cardData.subSubCatDropType,
                                            decoration: InputDecoration(
                                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                                borderSide: BorderSide(
                                                    width: 1, color: Mythemes.blackishade),
                                              ),
                                              //labelText: "Select Department",
                                              hintText: "Select",
                                              labelText: "Sub Sub Category",
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  overflow: TextOverflow.ellipsis
                                              ),
                                              contentPadding: EdgeInsets.all(5),
                                              /*border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.all(Radius.circular(8))),*/
                                              // labelText: "Location",
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 12,
                                                  color: Mythemes.blackish),
                                            ),
                                            items: subSubExpCategoryList.map<DropdownMenuItem<String>>((String? value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value! , style: TextStyle(fontSize: 10), maxLines: 2),
                                              );

                                            }).toList(),

                                            onChanged: (newVal) {
                                              valuenew = newVal.toString();
                                              for(int i=0; i<categoriesModalClass!.catDataList!.length;i++){
                                                if(categoriesModalClass!.catDataList![i].catName.toString().compareToIgnoringCase(newVal.toString()) ==0)
                                                {
                                                  subSubExpCategoryId = categoriesModalClass!.catDataList![i].catId!.toString();
                                                  print("Sub Sub Exp Id $subSubExpCategoryId");
                                                }
                                              }
                                              setState(() {
                                                dropdownSubSubExpCatValue = newVal;
                                              });

                                            },

                                          ).p8(),

                                        ),
                                      ],
                                    ),
                                  ),
                                  //Travel From & To
                                  Visibility(
                                    visible: travelFromToShow,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: cardData.fromPlaceController.text.isEmpty ? null : cardData.fromPlaceController,
                                            enabled: true,
                                            // initialValue: "Head Office",
                                            //maxLines: 3,
                                            onChanged: (value) {
                                              //value = cardData.fromPlaceController.text;
                                              _fromPlaceController.text = value;
                                              print("$value");
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                  Icons.airplanemode_active
                                              ),
                                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                                borderSide: BorderSide(
                                                    width: 1, color: Mythemes.blackishade),
                                              ),
                                              //labelText: "Select Department",
                                              hintText: "Travel From",
                                              labelText: "Travel From",
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                              ),
                                              contentPadding: EdgeInsets.all(5),
                                              /*border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.all(Radius.circular(8))),*/
                                              // labelText: "Location",
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 13,
                                                  color: Mythemes.blackish),
                                            ),
                                          ).p8(),

                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: cardData.toPlaceController.text.isEmpty ? null : cardData.toPlaceController,
                                            enabled: true,
                                            // initialValue: "Head Office",
                                            //maxLines: 3,
                                            onChanged: (value) {
                                              //value = cardData.fromPlaceController.text;
                                              _toPlaceController.text = value;
                                              print("$value");
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                  Icons.airplanemode_active
                                              ),
                                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                                borderSide: BorderSide(
                                                    width: 1, color: Mythemes.blackishade),
                                              ),
                                              //labelText: "Select Department",
                                              hintText: "Travel To",
                                              labelText: "Travel To",
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                              ),
                                              contentPadding: EdgeInsets.all(5),
                                              /*border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.all(Radius.circular(8))),*/
                                              // labelText: "Location",
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 13,
                                                  color: Mythemes.blackish),
                                            ),
                                          ).p8(),

                                        ),
                                      ],
                                    ),
                                  ),
                                  //Odometer Row
                                  Visibility(
                                    visible: odometerRowShow,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: cardData.odometerStartController,
                                            enabled: true,
                                            // initialValue: "Head Office",
                                            //maxLines: 3,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              //value = cardData.fromPlaceController.text;
                                              _odometerStartController.text = value;
                                              calculateKilometers();
                                              print("$value");
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                  Icons.electric_meter
                                              ),
                                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                                borderSide: BorderSide(
                                                    width: 1, color: Mythemes.blackishade),
                                              ),
                                              //labelText: "Select Department",
                                              hintText: "Odometer Start",
                                              labelText: "Odometer Start",
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                              ),
                                              contentPadding: EdgeInsets.all(5),
                                              /*border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.all(Radius.circular(8))),*/
                                              // labelText: "Location",
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 13,
                                                  color: Mythemes.blackish),
                                            ),
                                          ).p8(),

                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: cardData.odometerEndController,
                                            enabled: true,
                                            // initialValue: "Head Office",
                                            //maxLines: 3,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              //value = cardData.fromPlaceController.text;
                                              _odometerEndController.text = value;
                                              calculateKilometers();
                                              print("$value");
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                  Icons.electric_meter
                                              ),
                                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                                borderSide: BorderSide(
                                                    width: 1, color: Mythemes.blackishade),
                                              ),
                                              //labelText: "Select Department",
                                              hintText: "Odometer End",
                                              labelText: "Odometer End",
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                              ),
                                              contentPadding: EdgeInsets.all(5),
                                              /*border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.all(Radius.circular(8))),*/
                                              // labelText: "Location",
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 13,
                                                  color: Mythemes.blackish),
                                            ),
                                          ).p8(),

                                        ),
                                      ],
                                    ),
                                  ),
                                  //Merchant & Km
                                  Row(
                                    children: [
                                      Visibility(
                                        visible: merchantShow,
                                        child: Expanded(
                                          child: TextFormField(
                                            controller: cardData.merchantController.text.isEmpty ? null : cardData.merchantController,
                                            enabled: true,
                                            // initialValue: "Head Office",
                                            //maxLines: 3,
                                            onChanged: (value) {
                                              //value = cardData.fromPlaceController.text;
                                              _merchantController.text = value;
                                              print("$value");
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                  Icons.business_center
                                              ),
                                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                                borderSide: BorderSide(
                                                    width: 1, color: Mythemes.blackishade),
                                              ),
                                              //labelText: "Select Department",
                                              hintText: "Merchant",
                                              labelText: "Merchant",
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                              ),
                                              contentPadding: EdgeInsets.all(5),
                                              /*border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.all(Radius.circular(8))),*/
                                              // labelText: "Location",
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 13,
                                                  color: Mythemes.blackish),
                                            ),
                                          ).p8(),

                                        ),
                                      ),
                                      Visibility(
                                        visible: kmShow,
                                        child: Expanded(
                                          child: TextFormField(
                                            controller: cardData.kilometerController.text.isEmpty ? null : cardData.kilometerController,
                                            enabled: true,
                                            // initialValue: "Head Office",
                                            //maxLines: 3,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              //value = cardData.fromPlaceController.text;
                                              _kmController.text = value;
                                              print("$value");
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                  Icons.car_crash_rounded
                                              ),
                                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                                borderSide: BorderSide(
                                                    width: 1, color: Mythemes.blackishade),
                                              ),
                                              //labelText: "Select Department",
                                              hintText: "Kilometers",
                                              labelText: "Kilometers",
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                              ),
                                              contentPadding: EdgeInsets.all(5),
                                              /*border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.all(Radius.circular(8))),*/
                                              // labelText: "Location",
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 13,
                                                  color: Mythemes.blackish),
                                            ),
                                          ).p8(),

                                        ),
                                      ),
                                    ],
                                  ),
                                  //Month & Date
                                  Row(
                                    children: [
                                      Visibility(
                                        visible: monthShow,
                                        child: Expanded(
                                          child: TextFormField(

                                            onTap: () async{
                                              DateTime? date = DateTime.now();
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              date = (await showMonthYearPicker(

                                                context: context,
                                                initialDate: date ?? DateTime.now(),
                                                firstDate: DateTime(1947),
                                                lastDate: DateTime(2070),
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: ThemeData(
                                                      primaryColor: Colors.lightBlue,
                                                      dialogBackgroundColor: Colors.white,
                                                      colorScheme: ColorScheme.light(
                                                        primary: Colors.lightBlue,                         // Color for selected month/year
                                                        onPrimary: Colors.white,                            // Text color on selected month/year
                                                        onSurface: Colors.black,                            // Color for unselected month/year
                                                      ),
                                                      textTheme: TextTheme(
                                                        headlineMedium: TextStyle(                          // Text style for the month/year
                                                          fontSize: 24,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.lightBlue,
                                                        ),
                                                        bodyLarge: TextStyle(fontSize: 16, color: Colors.black, letterSpacing: 0), // Style for unselected items

                                                      ),
                                                    ),
                                                    child: child!,
                                                  );
                                                },
                                              ))!;
                                              setState(() {
                                                cardData.monthController.text = DateFormat("MMMM-yy").format(date!);
                                                selectedDate = cardData.monthController.text;
                                                print('MonthPicker $selectedDate');
                                              });
                                            },
                                            controller: cardData.monthController.text.isEmpty ? null : cardData.monthController,
                                            onChanged: (value) {
                                              //value = cardData.fromPlaceController.text;
                                              _monthController.text = value;
                                              print("$value");
                                            },
                                            readOnly: true,
                                            // initialValue: "Head Office",
                                            //maxLines: 3,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                  Icons.calendar_month
                                              ),
                                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                                borderSide: BorderSide(
                                                    width: 1, color: Mythemes.blackishade),
                                              ),
                                              //labelText: "Select Department",
                                              hintText: "Month",
                                              labelText: "Month",
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                              ),
                                              contentPadding: EdgeInsets.all(5),
                                              /*border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.all(Radius.circular(8))),*/
                                              // labelText: "Location",
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 13,
                                                  color: Mythemes.blackish),
                                            ),
                                          ).p8(),

                                        ),
                                      ),
                                      Visibility(
                                        visible: dateShow,
                                        child: Expanded(
                                          child: TextFormField(
                                            onTap: () async{
                                              DateTime? date = DateTime.now();
                                              FocusScope.of(context).requestFocus(new FocusNode());

                                              date = await showDatePicker(
                                                  context: context,
                                                  initialDate: date,
                                                  firstDate:DateTime(1947),
                                                  lastDate: DateTime(2070).add(Duration(days: 0)));
                                              setState(() {
                                                singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                                                cardData.dateController.text = DateFormat("dd-MM-yyyy").format(date!);
                                                _dateController.text = cardData.dateController.text;
                                                print('Date ${_dateController.text}');

                                                //  DateFormat.yMd().format(date!).toString();
                                              });

                                              print(date);
                                            },
                                            controller: cardData.dateController.text.isEmpty ? null : cardData.dateController,
                                            onChanged: (value) {
                                              //value = cardData.fromPlaceController.text;
                                              _dateController.text = value;
                                              print("$value");
                                            },
                                            readOnly: true,
                                            // initialValue: "Head Office",
                                            //maxLines: 3,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                  Icons.date_range
                                              ),
                                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                                borderSide: BorderSide(
                                                    width: 1, color: Mythemes.blackishade),
                                              ),
                                              //labelText: "Select Department",
                                              hintText: "Date",
                                              labelText: "Date",
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                              ),
                                              contentPadding: EdgeInsets.all(5),
                                              /*border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.all(Radius.circular(8))),*/
                                              // labelText: "Location",
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 13,
                                                  color: Mythemes.blackish),
                                            ),
                                          ).p8(),

                                        ),
                                      ),
                                    ],
                                  ),
                                  //Claim Amt Show
                                  Visibility(
                                    visible: claimAmtShow,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: cardData.claimedAmtController.text.isEmpty ? null : cardData.claimedAmtController,
                                            enabled: true,
                                            // initialValue: "Head Office",
                                            //maxLines: 3,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              //value = cardData.fromPlaceController.text;
                                              _claimAmtController.text = value;
                                              print("$value");
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                  Icons.currency_rupee
                                              ),
                                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                                borderSide: BorderSide(
                                                    width: 1, color: Mythemes.blackishade),
                                              ),
                                              //labelText: "Select Department",
                                              hintText: "Claimed Amount",
                                              labelText: "Claimed Amount",
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                              ),
                                              contentPadding: EdgeInsets.all(5),
                                              /*border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.all(Radius.circular(8))),*/
                                              // labelText: "Location",
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 13,
                                                  color: Mythemes.blackish),
                                            ),
                                          ).p8(),

                                        ),
                                      ],
                                    ),
                                  ),

                                  //Remarks Show
                                  Visibility(
                                    visible: remarksShow,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: cardData.remarksController.text.isEmpty ? null : cardData.remarksController,
                                            enabled: true,
                                            // initialValue: "Head Office",
                                            //maxLines: 3,
                                            onChanged: (value) {
                                              //value = cardData.fromPlaceController.text;
                                              _remarksController.text = value;
                                              print("$value");
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                  Icons.textsms_outlined
                                              ),
                                              enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                                borderSide: BorderSide(
                                                    width: 1, color: Mythemes.blackishade),
                                              ),
                                              //labelText: "Select Department",
                                              hintText: "Remarks",
                                              labelText: "Remarks",
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                              ),
                                              contentPadding: EdgeInsets.all(5),
                                              /*border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.all(Radius.circular(8))),*/
                                              // labelText: "Location",
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 13,
                                                  color: Mythemes.blackish),
                                            ),
                                          ).p8(),

                                        ),
                                      ],
                                    ),
                                  ),

                                  /*Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                         ElevatedButton(
                                          onPressed: () => _showUploadOptions(context),
                                          child: Text('Add Document'),
                                        ),
                                        //"Add Documents".text.size(17).bold.make()
                                      ],
                                    ),*/
                                  Visibility(
                                    visible: expenseCatShow,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => _showUploadOptions(context),
                                          child: Text('Add Document'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (uploadedFile != null) // Show the uploaded document
                                    Card(
                                      child: ListTile(
                                        leading: Icon(Icons.insert_drive_file),
                                        title: Text(uploadedFile!.path.split('/').last),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              uploadedFile = null;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  /*ElevatedButton(
                                      onPressed: _uploadDocumentToServer,
                                      child: Text('Upload Document'),
                                    ),*/



                                  /*Row(
                                      children: [
                                        Expanded(
                            child: SizedBox(
                              height: files.length == 0 ? 0 : 440,
                              child: ListView.builder(
                                itemCount: files.length,
                                itemBuilder: (context, index) {
                                  final file = files[index];
                                  return Card(
                                    margin: EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: file['type'] == 'image'
                                          ? Image.file(
                                        File(file['path']),
                                        width: 50,
                                        filterQuality: FilterQuality.low,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                          : Icon(
                                        _getFileIcon(file['type']),
                                        size: 40,
                                        color: Colors.blue,
                                      ),
                                      title: Text(
                                        file['name'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      subtitle: Text('${file['size']} - ${file['status']}'),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _deleteFile(index),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                                      ],
                                    )*/
                                ]
                            ),
                            Visibility(
                              visible: expenseCatShow,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ButtonBar(
                                          alignment: MainAxisAlignment.center,
                                          //buttonPadding: Vx.mOnly(right: 16),
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                //draftInductionData(context);
                                                finalRaiseClaimRequest(
                                                  sessionId!,
                                                  empId!,
                                                  _claimAmtController.text,
                                                  claimIdCheck = claimIdCheck,
                                                  claimRaiseId = "0",
                                                  claimReqId = "0",
                                                  _odometerEndController.text,
                                                  expCategoryId,
                                                  _merchantController.text,
                                                  selectedDate!,
                                                  odometer = true,
                                                  _kmController.text,
                                                  reimbursementId,
                                                  _remarksController.text,
                                                  _dateController.text,
                                                  _odometerStartController.text,
                                                  subExpCategoryId,
                                                  subSubExpCategoryId,
                                                  _fromPlaceController.text,
                                                  _toPlaceController.text,
                                                  status = "DRAFT",
                                                  uploadedFile == null ? "" : uploadedFile!.path,
                                                );
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                MaterialStateProperty.all(Mythemes.alertColor),
                                              ),
                                              child: "Draft".text.make(),
                                            ).wh(120, 40).py12(),



                                            ElevatedButton(
                                              onPressed: () {
                                                /*if (uploadedFile == null) {
                                                  Fluttertoast.showToast(
                                                      msg: "Please select document.",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.black,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                  print("No document selected.");
                                                  return;
                                                }*/
                                                finalRaiseClaimRequest(
                                                  sessionId!,
                                                  empId!,
                                                  _claimAmtController.text,
                                                  claimIdCheck = claimIdCheck,
                                                  claimRaiseId = "0",
                                                  claimReqId = "0",
                                                  _odometerEndController.text,
                                                  expCategoryId,
                                                  _merchantController.text,
                                                  selectedDate!,
                                                  odometer = true,
                                                  _kmController.text,
                                                  reimbursementId,
                                                  _remarksController.text,
                                                  _dateController.text,
                                                  _odometerStartController.text,
                                                  subExpCategoryId,
                                                  subSubExpCategoryId,
                                                  _fromPlaceController.text,
                                                  _toPlaceController.text,
                                                  status = "PENDING",
                                                  uploadedFile == null ? "" : uploadedFile!.path,
                                                );

                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                MaterialStateProperty.all(Mythemes.successColor),
                                              ),
                                              child: "Save".text.make(),
                                            ).wh(120, 40).py12()
                                          ]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]
                      ));
                }
            )
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
              Navigator.pushNamed(context, MyRoutings.claimItemsListRoute);
              print('Claim Items');
            }
            if(index==3){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EssAdminDashboardHead(EssDashboarrdModel()))
              );
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
              icon: Icon(Icons.monetization_on_outlined),
              label: 'Claims',
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

      ),
    );
  }


  Future<void> finalRaiseClaimRequest(
      String sessionId,
      dynamic empId,
      String claimAmt,
      String claimId,
      String claimRaiseId,
      String claimReqId,
      String endReading,
      String expCategory,
      String merchant,
      String month,
      bool odometer,
      String perkms,
      String policyId,
      String remarks,
      String startDating,
      String startReading,
      String subExpCategory,
      String subSubExpCategory,
      String travelFrom,
      String travelTo,
      String status,
      String document,
      ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.finalRaiseClaimApi;
    CommonNotificationPage.showLoaderDialog(context);
    var urlapi = Uri.parse("$conn$apiUrl");
    var request = new http.MultipartRequest("Post", urlapi);
    request.fields['sessionId'] = sessionId!;
    request.fields['empId'] = empId!.toString();
    request.fields['claimAmt'] = claimAmt;
    request.fields['claimId'] = claimId;
    request.fields['claimRaiseId'] = claimRaiseId;
    request.fields['claimReqId'] = claimReqId;
    request.fields['endReading'] = endReading;
    request.fields['expCategory'] = expCategory;
    request.fields['merchant'] = merchant;
    request.fields['month'] = month;
    request.fields['odomoter'] = odometer.toString();
    request.fields['perkms'] = perkms;
    request.fields['policyId'] = policyId;
    request.fields['remarks'] = remarks;
    request.fields['startDating'] = startDating;
    request.fields['startReading'] = startReading;
    request.fields['subExpCategory'] = subExpCategory;
    request.fields['subSubExpCategory'] = subSubExpCategory;
    request.fields['travelFrom'] = travelFrom;
    request.fields['travelTo'] = travelTo;
    request.fields['status'] = status;
    // Add file
    uploadedFile == null ? request.fields['document'] = "" :
    request.files.add(await http.MultipartFile.fromPath('document', document));
    // Construct API URL with parameters
    String apiWithParams = urlapi.toString() + '?' + request.fields.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');

// Print the full API URL with parameters
    print('API URL with Parameters: $apiWithParams');
    //final response = await http.post(urlapi);
    http.Response response = await http.Response.fromStream(await request.send());
    result = json.decode(response.body.toString());

    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      Navigator.of(context, rootNavigator: true).pop();
      mapResponse = json.decode(response.body);
      String reason = mapResponse['reason'];
      String result = mapResponse['result'];
      print('reason both $reason $result');
      print('reason${reason}');
      if(result.compareToIgnoringCase("Success")==0){
        showDialgSucess(context,reason.upperCamelCase+" ","Success");
      }else if(result.compareToIgnoringCase("Error")==0){
        showDialgSucess(context,reason.upperCamelCase, " Error ");
      }

    }
  }

  static showDialgSucess(BuildContext buildContext, String result, String alert) {
    if (buildContext == null) {
      print("⚠️ Warning: buildContext is null, cannot show dialog.");
      return;
    }

    showDialog(
      context: buildContext,
      barrierDismissible: false, // Prevents accidental dismiss
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Row(
            children: [
              Expanded(child: Text(alert)),
            ],
          ),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // close the result dialog

                // ✅ Pop 2 screens back using `buildContext`
                Future.delayed(Duration(milliseconds: 100), () {
                  int count = 0;
                  Navigator.of(buildContext).popUntil((route) {
                    return count++ == 1;
                  });
                });
              },
              child: Text("OK"),
            ),
          ],
          elevation: 24.0,
        );
      },
    );
  }
}

class CardData {
  TextEditingController fromPlaceController;
  TextEditingController toPlaceController;
  TextEditingController odometerStartController;
  TextEditingController odometerEndController;
  TextEditingController merchantController;
  TextEditingController kilometerController;
  TextEditingController monthController;
  TextEditingController dateController;
  TextEditingController claimedAmtController;
  TextEditingController remarksController;
  String dropdownValue;
  String catDropType;
  String subCatDropType;
  String subSubCatDropType;

  CardData({
    required this.fromPlaceController,
    required this.toPlaceController,
    required this.odometerStartController,
    required this.odometerEndController,
    required this.merchantController,
    required this.kilometerController,
    required this.monthController,
    required this.dateController,
    required this.claimedAmtController,
    required this.remarksController,
    required this.dropdownValue,
    required this.catDropType,
    required this.subCatDropType,
    required this.subSubCatDropType,
  });
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({Key? key, required this.child}) : super(key: key);

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