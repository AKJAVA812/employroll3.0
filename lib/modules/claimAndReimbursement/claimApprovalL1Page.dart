/*
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/commanNotificationPage.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../../../../themes/empThemes.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../commanScreen/punchInOutScreen.dart';
import '../../../main.dart';

class ClaimApprovalL1Page extends StatefulWidget {
  var totalClaimedAmt;
  var empId;


  ClaimApprovalL1Page(this.totalClaimedAmt,this.empId);

  @override
  State<ClaimApprovalL1Page> createState() => _ClaimApprovalL1PageState(totalClaimedAmt,empId);
}
String? setPath;
File? file;
var imageValue;
Future<File> _fileFromImageUrl() async {
  final response = await http.get(Uri.parse('https://s3.ap-south-1.amazonaws.com/employroll.com/images/1707640420694.png'));
  //final responseNew = await http.get(Uri.parse('https://s3.ap-south-1.amazonaws.com/employroll.com/images/1707640420694.png'));

  final documentDirectory = await getApplicationDocumentsDirectory();
  file = File(join(documentDirectory.path, 'imagetest.png'));

  file!.writeAsBytes(response.bodyBytes);
  //imageValue!.writeAsBytes(responseNew.bodyBytes);

  return file!;
}

List<DataApproval>? allUsernew=[];
List<DataApproval>? foundDataNew=[];
ClaimApprovalPageListModal? expenseListLabel;
ClaimApprovalPageListModal? expenseListLabeled;

Map<String, dynamic> mapResponse = {};
Map<String, dynamic> catMapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;
late List<String?> list = [];
late List<String?> expList = [];
late List<String?> subExpList = [];
late List<String?> catList = [];
late List<int?> policyList=[];
late List<String?> newList = [];
String valuenew="listText";
class _ClaimApprovalL1PageState extends State<ClaimApprovalL1Page> {
  var totalClaimedAmt;
  var empId;

  _ClaimApprovalL1PageState(this.totalClaimedAmt, this.empId);

  var titleName = "Claim Approval L1";

  final TextEditingController reimbName = TextEditingController();
  final TextEditingController catName = TextEditingController();
  final TextEditingController subCatName = TextEditingController();
  final TextEditingController subSubCatName = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _fromPlaceController = TextEditingController();
  final TextEditingController _toPlaceController = TextEditingController();
  final TextEditingController _odometerStartController = TextEditingController();
  final TextEditingController _odometerEndController = TextEditingController();
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController approverRemarks = TextEditingController();
  final TextEditingController approverAmount = TextEditingController();
  int? claimIdCheck;
  int? policyIdCheck;
  var dropdownvalue;
  var dropdownvalueType;
  var subExpDropType;
  var catDropType;
  var subCatDropType;
  var dropdownNewvalue;
  var expName;
  var expId;
  var expIdNew;
  var subExpName;
  var catId;
  var subExpId;
  var catSubExpId;
  var billShow = false;
  var billAllow = false;
  var documentName;
  var claimId;
  var permissionCode;
  final _formKey = GlobalKey<FormState>();

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    permissionCode = await shared!.getClaimLevelOnePerm();
    print("Permission Code - $permissionCode");
    print("EMP ID - $empId");
    // await Future.delayed(Duration(seconds: 5));
    Future<ClaimApprovalPageListModal> getAppReq12 = getApprovalList(
        sessionId!);
    //Future<AddExpensesDrops> getAppReq12 = getExpTypeList(sessionId!);
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );


    getAppReq12.then((value) {
      setState(() {
        expenseListLabel = value;
      });
      //print('employeeList00${advanceRequestedListLabel!.data!.length}');
    });

    getAppReq12.then((value) {
      setState(() {
        foundDataNew = allUsernew;
        expenseListLabel = value;
        expenseListLabeled = expenseListLabel;
      });
      //print('employeeList00${advanceRequestedListLabel!.data!.length}');
    });

    getAppReq12.then((value) {
      setState(() {
        addExpensesDropsLabel = value;
      });
      //print('employeeList00${advanceRequestedListLabel!.data!.length}');
    });
  }

  @override
  void initState() {
    int i = 0;
    _fileFromImageUrl();
    print("Total Claimed - $totalClaimedAmt");
    //claimId = addExpDropPolicyLabel?.claimDataList![i].claimId;
    //policyId = addExpDropPolicyLabel?.claimDataList![i].policyId;
    // TODO: implement initState
    super.initState();
    _initializeNotifications();
    getSharedPrfanceList();
    //getAllCategory(sessionId!);
  }

  showNodata(BuildContext buildContext, result, reason) {
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
            Navigator.pop(buildContext);
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
        context: buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  Future<ClaimApprovalPageListModal> getApprovalList(String SessionId) async {
    String conn = ApiDetails.serverTwo;
    String apiUrl = ApiDetails.claimApprovalListDataApi;
    print('employeeList11: ${SessionId}');
    ClaimApprovalPageListModal claimApprovalPageListModal;
    var urlapi = Uri.parse("$conn$apiUrl"
        "sessionId=$SessionId&"
        "status=LEVEL_ONE_PENDING&"
        "empId=$empId"
    );
    final response = await http.post(urlapi);

    print('responseemployeeList ${response.body}');
    print('API -  ${response.request}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');

    if (getData!.length == 0) {
      print("getData111 $getData");
      showNodata(this.context, "Alert", "There is no data available.");
    }
    claimApprovalPageListModal =
        ClaimApprovalPageListModal.fromJson(mapResponse);
    allUsernew = claimApprovalPageListModal.data;

    for (int i = 0; i < claimApprovalPageListModal!.data!.length; i++) {
      mapResponse['data'][i]['reimburName'] == null ? "".text.make() : reimbName
          .text = mapResponse['data'][i]['reimburName'];
      mapResponse['data'][i]['expName'] == null ? "".text.make() : catName
          .text = mapResponse['data'][i]['expName'];
      mapResponse['data'][i]['subExpname'] == null ? "".text.make() : subCatName
          .text = mapResponse['data'][i]['subExpname'];
      mapResponse['data'][i]['categoryName'] == null
          ? "".text.make()
          : subSubCatName.text = mapResponse['data'][i]['categoryName'];
      mapResponse['data'][i]['reimburName'] == null
          ? "".text.make()
          : _fromPlaceController.text = mapResponse['data'][i]['reimburName'];
      mapResponse['data'][i]['reimburName'] == null
          ? "".text.make()
          : _toPlaceController.text = mapResponse['data'][i]['reimburName'];
      mapResponse['data'][i]['startReading'] == null
          ? "".text.make()
          : _odometerStartController.text =
      mapResponse['data'][i]['startReading'];
      mapResponse['data'][i]['endReading'] == null
          ? "".text.make()
          : _odometerEndController.text = mapResponse['data'][i]['endReading'];
      mapResponse['data'][i]['reimburName'] == null
          ? "".text.make()
          : _merchantController.text = mapResponse['data'][i]['reimburName'];
      mapResponse['data'][i]['kilometer'] == null
          ? "".text.make()
          : _kmController.text = mapResponse['data'][i]['kilometer'];
      mapResponse['data'][i]['reimburName'] == null
          ? "".text.make()
          : _dateController.text = mapResponse['data'][i]['reimburName'];
      mapResponse['data'][i]['reimburName'] == null
          ? "".text.make()
          : _fromDateController.text = mapResponse['data'][i]['reimburName'];
      mapResponse['data'][i]['claimAMount'] == null
          ? "".text.make()
          : _amountController.text =
          mapResponse['data'][i]['claimAMount'].toString();
      mapResponse['data'][i]['remarks'] == null
          ? "".text.make()
          : _remarksController.text = mapResponse['data'][i]['remarks'];
      print("Reimbursement Names - ${reimbName.text}");
      print("Category - ${catName.text}");
      print("Sub Category - ${subCatName.text}");
      print("Sub Sub Category - ${subSubCatName.text}");
      print("From Place - ${_fromPlaceController.text}");
      print("To Place - ${_toPlaceController.text}");
      print("Odometer Start - ${_odometerStartController.text}");
      print("Odometer End - ${_odometerEndController.text}");
      print("Merchant - ${_merchantController.text}");
      print("Kilometers - ${_kmController.text}");
      print("Month - ${_dateController.text}");
      print("Raised On - ${_fromDateController.text}");
      print("Claimed Amount - ${_amountController.text}");
      print("Remarks - ${_remarksController.text}");
    }
    return claimApprovalPageListModal;
  }

  List categoryItemlist = [];

  Future getAllCategory(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.addExpDropPolicy;
    var baseUrl = Uri.parse("$conn$apiUrl?sessionId=$SessionId");

    final response = await http.post(baseUrl);
    print('responseemployeeList ${response.body}');
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryItemlist = jsonData;
      });
    }
  }

  final ImagePicker _picker = ImagePicker();
  TextEditingController filePath = TextEditingController();
  String singleDateString = "";
  final TextEditingController _dateController = TextEditingController();
  String? selectedDate;

  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<DataApproval>? results = [];

    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      //results = _allUsers;
      setState(() {
        results = allUsernew;
      });
    } else {
      results = allUsernew.where((user) =>
          user!.data!.contains(enteredKeyword.toLowerCase()))
          .toList();


      results = allUsernew?.where((element) =>
          element.expName!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      for (int i = 0; i < inductionListLabel!.data!.length; i++) {
        if (inductionListLabel!.data![i].empName!.toLowerCase().contains(
            enteredKeyword.toLowerCase())) {
          // Refresh the UI
          setState(() {
            inductionListLabeldd = inductionResult;
          });
        }
      }
      // we use the toLowerCase() method to make it case-insensitive
      setState(() {
        foundDataNew = results;
      });
    }
  }

    TextEditingController searchType = TextEditingController();

    var docImage;

    void _showNotification(String filePath, String fileName) async {
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        icon: '@mipmap/ic_launcher', // Specify the correct icon resource here
      );
      const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );
      await flutterLocalNotificationsPlugin.show(
        0,
        'Download Completed',
        fileName,
        platformChannelSpecifics,
        payload: filePath,
      );
    }

    void _onNotificationTap(String payload) async {
      await OpenFile.open(payload);
    }

    Future<void> _initializeNotifications() async {
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
          '@mipmap/ic_launcher');
      const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (
            NotificationResponse notificationResponse) async {
          if (notificationResponse.payload != null) {
            _onNotificationTap(notificationResponse.payload!);
          }
        },
      );
    }

    Future<String> getDownloadDirectory() async {
      final directory = await getApplicationDocumentsDirectory();
      // You can also use getApplicationDocumentsDirectory() for the app's documents directory
      return directory!.path;
    }

    void findAndroidDataPath() async {
      final externalStorageDir = await getExternalStorageDirectory();
      final androidDataPath = '${externalStorageDir!.path}/Android/data/';

      print('Android Data Path: $androidDataPath');
    }

    @override
    Widget build(BuildContext context) {
      bool isExpanded = false;
      void expandTile() {
        setState(() {
          isExpanded = true;
          // keyTile = UniqueKey();
        });
      }

      void shrinkTile() {
        setState(() {
          isExpanded = false;
          // keyTile = UniqueKey();
        });
      }


      Future<void> pickFile() async {
        //PermissionStatus status = await Permission.manageExternalStorage.status;

        try {
          final result = await FilePicker.platform.pickFiles(
              allowMultiple: true);
          if (result == null) return;

          final file = result.files.first;
          setState(() {
            filePath.text = file.name;
            //print('Bytes: ${file.bytes}');
            print('Name: ${file.name}');
          });


          //print('Size: ${file.size}');
          //print('Size: ${file.extension}');
          //print('Path: ${file.path}');

          final newFile = await saveFilePermanently(file);
          //openFiles(result.files);
          final kb = file.size / 1024;
          final mb = kb / 1024;
          final fileSize = mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb
              .toStringAsFixed(2)} KB';
          final extension = file.extension ?? 'none';
          setState(() {
            //filePath.text=file.name;
            //print('File Object: $file');
          });
        } catch (e) {
          print('Error picking file: $e');
        }

        if (status.isGranted) {


        } else {
          print("Permission denied by the user");
        }
      }

      dateSelection() async {
        DateTime? date = DateTime.now();
        FocusScope.of(context).requestFocus(new FocusNode());

        date = await showMonthPicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(1947),
            lastDate: DateTime.now().add(Duration(days: 0)));
        setState(() {
          // singleDateString = DateFormat('dd-MM-yyyy').format(date!);
          _dateController.text = DateFormat("MMMM-yy").format(date!);
          selectedDate = _dateController.text;

          print('MonthPicker $selectedDate');
          getSharedPrfanceList();


          //  DateFormat.yMd().format(date!).toString();
        });
        print(date);
      }

      int pageIndex = 0;
      int currentIndex = 2;

      double height = MediaQuery
          .of(context)
          .size
          .height;
      return DismissKeyboard(
        child: Scaffold(
          appBar: AppBar(
            title: titleName.text.size(15).make(),
            actions: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "₹${totalClaimedAmt} - Total CA".text
                      .size(13)
                      .bold
                      .color(Mythemes.successColor)
                      .make(),
                ],
              ).py8().px8(),
            ],
          ),

          body: Container(
            height: height,
            color: Mythemes.whitish,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: foundDataNew!.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      documentName = foundDataNew![index].image;
                      String documentUrl = foundDataNew![index].image;
                      String extension = documentUrl
                          .split('.')
                          .last;
                      print("File extension: $extension");
                      print("Document Name -  $documentName");
                      print('newList: $newList');
                      if (extension == 'xlsx') {
                        docImage = Icon(Icons.file_copy);
                      } else if (extension == 'pdf') {
                        docImage = Icon(Icons.picture_as_pdf);
                      } else if (extension == 'jpeg') {
                        docImage = Icon(Icons.image);
                      } else if (extension == 'jpg') {
                        docImage = Icon(Icons.image);
                      } else if (extension == 'png') {
                        docImage = Icon(Icons.image);
                      } else if (extension == 'docx') {
                        docImage = Icon(Icons.file_copy);
                      }
                      void _downloadFile() async {
                        String fileName = '$selectedDate' + "-" +
                            "$timeString" + '.$extension';

                        if (Platform.isAndroid) {
                          print("I am Android");
                          var storagePath = "/storage/emulated/0/Download/$fileName";
                          var file = File(storagePath);

                          if (documentName != null && documentName.isNotEmpty &&
                              Uri
                                  .parse(documentName)
                                  .isAbsolute) {
                            var res = await http.get(Uri.parse(documentName));
                            file.writeAsBytes(res.bodyBytes);
                            Fluttertoast.showToast(
                              msg: "Download Completed - $fileName",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            _showNotification(storagePath, fileName);
                          } else {
                            Fluttertoast.showToast(
                              msg: "Invalid file URL.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        }
                        else if (Platform.isIOS) {
                          print("I am IOS");
                          final status = await Permission.storage.request();
                          if (status.isGranted) {
                            final downloadDir = await getDownloadDirectory();
                            final filePath = '$downloadDir/$fileName';
                            var file = File(filePath);

                            if (documentName != null &&
                                documentName.isNotEmpty && Uri
                                .parse(documentName)
                                .isAbsolute) {
                              var res = await http.get(Uri.parse(documentName));
                              await file.writeAsBytes(res.bodyBytes);
                              Fluttertoast.showToast(
                                msg: "Download Completed - $fileName",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              _showNotification(filePath, fileName);
                            } else {
                              Fluttertoast.showToast(
                                msg: "Invalid file URL.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          } else {
                            print('no permission');
                          }
                        }
                      }
                      print("LIST DATA - ${foundDataNew!.length}");
                      return Card(
                        elevation: 2,
                        child: ExpansionTile(
                          onExpansionChanged: (value) {
                            approverRemarks.text = "";
                            approverAmount.text = "";
                          },
                          initiallyExpanded: isExpanded,
                          title: "Claim ${index + 1}"
                              .text
                              .make(),
                          trailing: "₹${foundDataNew![index].claimAMount
                              .toString()}".text.bold.color(
                              Mythemes.successColor).make(),
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    "Approve Claim".text.bold.size(16).make()
                                  ],
                                ),


                                Visibility(
                                  visible: foundDataNew![index].image != "",
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          style: ListTileStyle.drawer,
                                          isThreeLine: true,

                                          contentPadding: EdgeInsets.all(12.0),
                                          leading: CircleAvatar(
                                            child: docImage,
                                            backgroundColor: Mythemes
                                                .greyishade,
                                            radius: 30,
                                          ),
                                          title: "${extension}"
                                              .toString()
                                              .text
                                              .bold
                                              .make()
                                              .py8(),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: foundDataNew![index]
                                                          .image
                                                          .toString()
                                                          .text
                                                          .overflow(TextOverflow
                                                          .ellipsis)
                                                          .maxLines(2)
                                                          .make()
                                                          .py4()),

                                                ],
                                              ),
                                            ],
                                          ),
                                          trailing: InkWell(
                                              onTap: () {
                                                _downloadFile();
                                              },
                                              child: Icon(
                                                  Icons.remove_red_eye_rounded,
                                                  color: Mythemes
                                                      .lightBluishColor)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: foundDataNew![index]
                                                .reimburName),
                                        enabled: false,
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                        // initialValue: "Head Office",
                                        //maxLines: 3,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              Icons.text_snippet_outlined
                                          ),
                                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade),
                                          ),
                                          //labelText: "Select Department",
                                          hintText: "Reimbursement Type",
                                          labelText: "Reimbursement Type",
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(8))),

                                          // labelText: "Location",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Mythemes.blackish),
                                        ),
                                      ).p8(),

                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: foundDataNew![index].expName),
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                        enabled: false,
                                        // initialValue: "Head Office",
                                        //maxLines: 3,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              Icons.textsms_outlined
                                          ),
                                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade),
                                          ),
                                          //labelText: "Select Department",
                                          hintText: "Category",
                                          labelText: "Category",
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(8))),

                                          // labelText: "Location",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Mythemes.blackish),
                                        ),
                                      ).p8(),

                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: foundDataNew![index]
                                                .subExpname),
                                        enabled: false,
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                        // initialValue: "Head Office",
                                        //maxLines: 3,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              Icons.textsms_outlined
                                          ),
                                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade),
                                          ),
                                          //labelText: "Select Department",
                                          hintText: "Sub Category",
                                          labelText: "Sub Category",
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(8))),

                                          // labelText: "Location",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Mythemes.blackish),
                                        ),
                                      ).p8(),

                                    ),

                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: foundDataNew![index]
                                                .categoryName),
                                        enabled: false,
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                        // initialValue: "Head Office",
                                        //maxLines: 3,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              Icons.textsms_outlined
                                          ),
                                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade),
                                          ),
                                          //labelText: "Select Department",
                                          hintText: "Sub Sub Category",
                                          labelText: "Sub Sub Category",
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(8))),

                                          // labelText: "Location",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Mythemes.blackish),
                                        ),
                                      ).p8(),

                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: foundDataNew![index]
                                                .fromPlace),
                                        enabled: false,
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                        // initialValue: "Head Office",
                                        //maxLines: 3,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              Icons.airplanemode_active
                                          ),
                                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade),
                                          ),
                                          //labelText: "Select Department",
                                          hintText: "Travel From",
                                          labelText: "Travel From",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(8))),

                                          // labelText: "Location",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Mythemes.blackish),
                                        ),
                                      ).p8(),

                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: foundDataNew![index].toPlace),
                                        enabled: false,
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                        // initialValue: "Head Office",
                                        //maxLines: 3,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              Icons.airplanemode_active
                                          ),
                                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade),
                                          ),
                                          //labelText: "Select Department",
                                          hintText: "Travel To",
                                          labelText: "Travel To",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(8))),

                                          // labelText: "Location",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Mythemes.blackish),
                                        ),
                                      ).p8(),

                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: foundDataNew![index]
                                                .startReading),
                                        enabled: false,
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                        // initialValue: "Head Office",
                                        //maxLines: 3,
                                        //onChanged  : changeBillBolean(),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              Icons.electric_meter
                                          ),
                                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade),
                                          ),
                                          //labelText: "Select Department",
                                          hintText: "Odometer Start",
                                          labelText: "Odometer Start",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(8))),

                                          // labelText: "Location",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Mythemes.blackish),
                                        ),
                                      ).p8(),

                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: foundDataNew![index]
                                                .endReading),
                                        enabled: false,
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                        // initialValue: "Head Office",
                                        //maxLines: 3,
                                        //onChanged: changeBillBolean(),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              Icons.electric_meter
                                          ),
                                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade),
                                          ),
                                          //labelText: "Select Department",
                                          hintText: "Odometer End",
                                          labelText: "Odometer End",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(8))),

                                          // labelText: "Location",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Mythemes.blackish),
                                        ),
                                      ).p8(),

                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: foundDataNew![index]
                                                .merchant),
                                        enabled: false,
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                        // initialValue: "Head Office",
                                        //maxLines: 3,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              Icons.business_center
                                          ),
                                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade),
                                          ),
                                          //labelText: "Select Department",
                                          hintText: "Merchant",
                                          labelText: "Merchant",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(8))),

                                          // labelText: "Location",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Mythemes.blackish),
                                        ),
                                      ).p8(),

                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: foundDataNew![index]
                                                .kilometer),
                                        enabled: false,
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                        // initialValue: "Head Office",
                                        //maxLines: 3,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              Icons.radar_sharp
                                          ),
                                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade),
                                          ),
                                          //labelText: "Select Department",
                                          hintText: "Kilometers",
                                          labelText: "Kilometers",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(8))),

                                          // labelText: "Location",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Mythemes.blackish),
                                        ),
                                      ).p8(),

                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        onTap: () async {
                                          DateTime? toDate = DateTime.now();
                                          FocusScope.of(context).requestFocus(
                                              new FocusNode());

                                          toDate = await showDatePicker(
                                              context: context,
                                              initialDate: toDate,
                                              firstDate: DateTime(1947),
                                              lastDate: DateTime.now().add(
                                                  Duration(days: 0)));
                                          setState(() {
                                            //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
                                            _toDateController.text =
                                                DateFormat("dd-MM-yyyy").format(
                                                    toDate!);
                                          });

                                          print(toDate);

                                          dateSelection();
                                        },
                                        readOnly: true,
                                        enabled: false,
                                        controller: TextEditingController(
                                            text: foundDataNew![index].month),
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                        // initialValue: "Head Office",
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.calendar_month,),
                                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade),
                                          ),
                                          labelText: "Month",
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(8))),

                                          // labelText: "Location",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Mythemes.blackish),
                                        ),
                                      ).p8(),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        onTap: () async {

                                        },
                                        readOnly: true,
                                        enabled: false,
                                        controller: TextEditingController(
                                            text: foundDataNew![index]
                                                .raisedOn),
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                        // initialValue: "Head Office",
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.date_range,),
                                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade),
                                          ),
                                          labelText: "Date",
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(8))),

                                          // labelText: "Location",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Mythemes.blackish),
                                        ),
                                      ).p8(),
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: TextEditingController(
                                            text: foundDataNew![index]
                                                .claimAMount.toString()),
                                        enabled: false,
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                        // initialValue: "Head Office",
                                        //maxLines: 3,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              Icons.currency_rupee),
                                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade),
                                          ),
                                          //labelText: "Select Department",
                                          hintText: "Claimed Amount",
                                          labelText: "Claimed Amount",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(8))),

                                          // labelText: "Location",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Mythemes.blackish),
                                        ),
                                      ).p8(),

                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: foundDataNew![index].remarks),
                                        enabled: false,
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                        // initialValue: "Head Office",
                                        //maxLines: 3,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              Icons.notes_outlined),
                                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade),
                                          ),
                                          //labelText: "Select Department",
                                          hintText: "Enter Remarks",
                                          labelText: "Remarks",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(8))),

                                          // labelText: "Location",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Mythemes.blackish),
                                        ),
                                      ).p8(),

                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value != null && value.isEmpty) {
                                            return "Please Add Remarks";
                                          } else if (value!.length < 7) {
                                            return "Remarks should be atleast of 7 characters";
                                          }

                                          return null;
                                        },
                                        controller: approverRemarks,
                                        enabled: true,
                                        onTap: () {
                                          claimId =
                                              foundDataNew![index].claimId;
                                          print("Claim Raise Id - $claimId");
                                        },
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                        // initialValue: "Head Office",
                                        //maxLines: 3,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              Icons.notes_outlined),
                                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade),
                                          ),
                                          //labelText: "Select Department",
                                          hintText: "Enter Remarks",
                                          labelText: "Approver Remarks",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(8))),

                                          // labelText: "Location",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Mythemes.blackish),
                                        ),
                                      ).p8(),

                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value != null && value.isEmpty) {
                                            return "Please Add Amount";
                                          } else if (value!.length < 7) {
                                            return "Remarks should be atleast of 7 characters";
                                          }

                                          return null;
                                        },
                                        controller: approverAmount,
                                        enabled: true,
                                        onTap: () {
                                          claimId =
                                              foundDataNew![index].claimId;
                                          print("Claim Raise Id - $claimId");
                                        },
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                        // initialValue: "Head Office",
                                        //maxLines: 3,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              Icons.currency_rupee),
                                          enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Mythemes.blackishade),
                                          ),
                                          //labelText: "Select Department",
                                          hintText: "Enter Amount",
                                          labelText: "Approver Amount",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(8))),

                                          // labelText: "Location",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Mythemes.blackish),
                                        ),
                                      ).p8(),

                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        pickFile();

                                        setState(() {
                                          filePath.text;
                                          print(filePath.text);
                                        });
                                      },
                                      child: Icon(
                                        Icons.picture_as_pdf, size: 50,
                                        color: Mythemes.lightBluishColor,),
                                    ),
                                    "${filePath.text == ""
                                        ? "Upload File"
                                        : filePath.text}".text.size(18).make()

                                  ],
                                ).py20(),


                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ButtonBar(
                                        alignment: MainAxisAlignment
                                            .spaceBetween,
                                        //buttonPadding: Vx.mOnly(right: 16),
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              if (approverRemarks.text!
                                                  .compareToIgnoringCase("") ==
                                                  0) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      " Please Enter Remarks"),
                                                ));
                                              } else if (approverAmount.text!
                                                  .compareToIgnoringCase("") ==
                                                  0) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      " Please Enter Approved Amount"),
                                                ));
                                              } else {
                                                disApproveClaimRequest(
                                                    sessionId!,
                                                    permissionCode,
                                                    approverRemarks.text,
                                                    approverAmount.text,
                                                    claimId
                                                );
                                              }
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                              MaterialStateProperty.all(
                                                  Mythemes.dangerColor),
                                            ),
                                            child: "Disapprove".text.make(),
                                          ).wh(150, 40).py12(),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (approverRemarks.text!
                                                  .compareToIgnoringCase("") ==
                                                  0) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      " Please Enter Remarks"),
                                                ));
                                              } else if (approverAmount.text!
                                                  .compareToIgnoringCase("") ==
                                                  0) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      " Please Enter Approved Amount"),
                                                ));
                                              } else {
                                                approveClaimRequest(
                                                    sessionId!,
                                                    permissionCode,
                                                    approverRemarks.text,
                                                    approverAmount.text,
                                                    claimId

                                                );
                                              }
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                              MaterialStateProperty.all(
                                                  Mythemes.successColor),
                                            ),
                                            child: "Approve".text.make(),
                                          ).wh(150, 40).py12(),

                                        ]),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ).p12();
                    }
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 5.0,
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: 60,
              child: BottomNavigationBar(
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                currentIndex: currentIndex,
                selectedItemColor: Mythemes.lightBluishColor,
                unselectedItemColor: Mythemes.greyish,
                onTap: (index) {
                  if (index == 0) {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => PunchInOUtActivity()));
                    //Navigator.pop(context);
                    print('home tab');
                  }
                  if (index == 1) {
                    //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
                    print('Attendance');
                  }
                  if (index == 2) {
                    //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
                    print('Dashboard');
                  }
                  if (index == 3) {
                    //Navigator.pushNamed(context, MyRoutings.onDutyTypes);
                    print('out duty');
                  }
                  setState(() {
                    currentIndex = index;
                  });
                },
                items: const [

                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_pin_circle_rounded),
                    label: 'MSS',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.checklist_rtl_outlined),
                    label: 'Approval',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_outlined),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),

         */
/* bottomNavigationBar: Container(
            height: 80,
            color: context.cardColor,
            child: ButtonBar(
                alignment: MainAxisAlignment.center,
                buttonPadding: Vx.mOnly(right: 16),
                children: [
                  ElevatedButton(
                    onPressed: () {
                      file == null ? 0 : file;
                      print(_fromDateController.text);
                      print(_toDateController.text);
                      print(_fromPlaceController.text);
                      print(_toPlaceController.text);
                      print(_merchantController.text);
                      print(claimIdCheck);
                      print(policyIdCheck);
                      print(catId);
                      print(subExpId);
                      print(expIdNew);
                      print(_remarksController.text);
                      print(_amountController.text);
                      print(billAllow);
                      print(_distanceController.text);
                      print(file);
                      saveExpense(
                        sessionId!,
                        _fromDateController.text,
                        _toDateController.text,
                        _fromPlaceController.text,
                        _toPlaceController.text,
                        _merchantController.text,
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
                      backgroundColor:
                      MaterialStateProperty.all(Mythemes.dangerColor),
                    ),
                    child: "Disapprove".text.make(),
                  ).wh(150, 40).py12(),
                  ElevatedButton(
                    onPressed: () {
                      file == null ? 0 : file;
                      print(_fromDateController.text);
                      print(_toDateController.text);
                      print(_fromPlaceController.text);
                      print(_toPlaceController.text);
                      print(_merchantController.text);
                      print(claimIdCheck);
                      print(policyIdCheck);
                      print(catId);
                      print(subExpId);
                      print(expIdNew);
                      print(_remarksController.text);
                      print(_amountController.text);
                      print(billAllow);
                      print(_distanceController.text);
                      print(file);
                      saveExpense(
                        sessionId!,
                        _fromDateController.text,
                        _toDateController.text,
                        _fromPlaceController.text,
                        _toPlaceController.text,
                        _merchantController.text,
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
                      backgroundColor:
                      MaterialStateProperty.all(Mythemes.successColor),
                    ),
                    child: "Approve".text.make(),
                  ).wh(150, 40).py12(),

                ]),
          ),*//*


        ),
      );
    }

    Future <void> approveClaimRequest(String SessionId, String permissionCode,
        String approverRemarks, String approverAmount,
        int claimRaisedId) async {
      String conn = ApiDetails.serverTwo;
      String apiUrl = ApiDetails.claimApproveApi;
      print('employeeList11: ${SessionId}');
      print('TagId: ${claimRaisedId}');


      CommonNotificationPage.showLoaderDialog(this.context);
      var urlapi = Uri.parse("$conn$apiUrl?"
          "sessionId=$SessionId&"
          "permissionCode=$permissionCode&"
          "remarks=$approverRemarks&"
          "amount=$approverAmount&"
          "claimRaiseId=$claimId"
      );

      final response = await http.post(urlapi);
      print(response.request);
      var responseResult = response.body;
      print('success $responseResult');
      //Navigator.pop(context);
      mapResponse = json.decode(response.body);
      print("My Data-   $mapResponse");

      if (response.statusCode == 200) {
        var responseResult = response.body;
        print('success $responseResult');
        //Navigator.pop(context);
        mapResponse = json.decode(response.body);
        String status = mapResponse['status'];
        String reason = mapResponse['reason'];
        //var found = mapResponse['found'];
        //print('result both $showTryTag $reason');
        print('result ${status}');
        if (status.compareToIgnoringCase("success") == 0) {
          CommonNotificationPage.showDialgSucess(
              this.context, reason.upperCamelCase + " ", "Success");
        } else if (status.compareToIgnoringCase("error") == 0) {
          CommonNotificationPage.showDialgSucess(
              this.context, reason.upperCamelCase, " Error ");
        }
      }

      setState(() {

      });
    }

    Future <void> disApproveClaimRequest(String SessionId,
        String permissionCode, String approverRemarks, String approverAmount,
        int claimRaisedId,) async {
      String conn = ApiDetails.serverTwo;
      String apiUrl = ApiDetails.claimDisapproveApi;
      print('employeeList11: ${SessionId}');
      print('TagId: ${claimRaisedId}');


      CommonNotificationPage.showLoaderDialog(this.context);
      var urlapi = Uri.parse("$conn$apiUrl?"
          "sessionId=$SessionId&"
          "permissionCode=$permissionCode&"
          "remarks=$approverRemarks&"
          "amount=$approverAmount&"
          "claimRaiseId=$claimId"
      );

      final response = await http.post(urlapi);
      print(response.request);
      var responseResult = response.body;
      print('success $responseResult');
      //Navigator.pop(context);
      mapResponse = json.decode(response.body);
      print("My Data-   $mapResponse");

      if (response.statusCode == 200) {
        var responseResult = response.body;
        print('success $responseResult');
        //Navigator.pop(context);
        mapResponse = json.decode(response.body);
        String status = mapResponse['status'];
        String reason = mapResponse['reason'];
        //var found = mapResponse['found'];
        //print('result both $showTryTag $reason');
        print('result ${status}');
        if (status.compareToIgnoringCase("success") == 0) {
          CommonNotificationPage.showDialgSucess(
              this.context, reason.upperCamelCase + " ", "Success");
        } else if (status.compareToIgnoringCase("error") == 0) {
          CommonNotificationPage.showDialgSucess(
              this.context, reason.upperCamelCase, " Error ");
        }
      }

      setState(() {

      });
    }

    Future<File> saveFilePermanently(PlatformFile file) async {
      final appStorage = await getApplicationDocumentsDirectory();
      final newFile = File('${appStorage.path}/${file.name}');
      return File(file.path!).copy(newFile.path);
    }

    Future<void> saveExpense(String sessionId,
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
        File document) async {
      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.saveExpenses;
      CommonNotificationPage.showLoaderDialog(this.context);

      var urlapi = Uri.parse("$conn$apiUrl?"
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
      );

      var uri = Uri.parse(
          "http://www.employroll.com/restful/service/claim/requisition/form/details/save");
      var request = new http.MultipartRequest("Post", uri);
      request.fields['sessionId'] = sessionId!;
      request.fields['fromDate'] = _fromDateController.text;
      request.fields['toDate'] = _toDateController.text;
      request.fields['fromPlace'] = _fromPlaceController.text;
      request.fields['toPlace'] = _toPlaceController.text;
      request.fields['purpose'] = _merchantController.text;
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
      print('URL $uri');

      String jsonString = createJsonWithImage(imageValue);

      // Make an HTTP post request with the JSON string
      final response = await http.post(
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
      }


      var stream = http.ByteStream(file!.openRead());
      stream.cast();
      var length = await file!.length();
      print('Response status: ${length}');
      print('Response body: ${stream}');
      print('Response body: ${file}');
      print("$stream");

      var multipart = new http.MultipartFile('document', stream, length,
          filename: basename('image.jpg'));
      request.files.add(multipart);

      request.files.add(new http.MultipartFile.fromBytes('file',
          await File.fromUri(imageValue!.path).readAsBytes(),
          contentType: new MediaType('image', 'jpeg')));


      request.send().then((response) {
        if (response.statusCode == 200) print("Uploaded!");
      });


      if (value!.length() != 0) {

      }


      // Send the request
      //var response = await request.send();

      http.Response response = await http.Response.fromStream(
          await request.send());

      //final response = await http.post(urlapi);
      print('URL ${response.request}');
      if (response.statusCode == 200) {
        var responseResult = response.body;
        print('success $responseResult');
        Navigator.pop(this.context);
        mapResponse = json.decode(response.body);
        //String reason = mapResponse['reason'];
        //String status = mapResponse['status'];
        String result = mapResponse['result'];
        //print('reason both $reason $status');
        //print('reason${reason}');
        if (result.compareToIgnoringCase("success") == 0) {
          CommonNotificationPage.showDialgSucess(
              this.context, result.upperCamelCase + " ", "Success");
        } else if (result.compareToIgnoringCase("error") == 0) {
          CommonNotificationPage.showDialgSucess(
              this.context, result.upperCamelCase, " Error ");
        }
      }
    }
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
}*/
