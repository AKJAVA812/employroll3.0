import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../commanScreen/allAPIList.dart';
import '../../../commanScreen/commanNotificationPage.dart';
import '../../../sharedPrefancePage/ShardPre.dart';
import '../../../themes/empThemes.dart';
import '../modalClass/departmentListModal.dart';
import '../modalClass/queryTypeListModal.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import '../modalClass/raisedQueryListModal.dart';
import '../modalClass/subQueryTypeListModal.dart';

class HelpDeskItems extends StatefulWidget {
  const HelpDeskItems({Key? key}) : super(key: key);

  @override
  State<HelpDeskItems> createState() => _HelpDeskItemsState();
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
Map<String, dynamic> mapResponseQuery = {};
Map<String, dynamic> mapResponseSubQuery = {};
Map<String, dynamic> mapResponseRaised = {};
SessionManager shared = SessionManager();
String? sessionId;

late List<String?> deptList = [];
late List<String?> queryTypeList = [];
late List<String?> subQueryTypeList = [];

class _HelpDeskItemsState extends State<HelpDeskItems> {
  bool raiseTicketShow = true;
  bool requestedTicketShow = false;
  bool ticketDashboardShow = false;

  DepartmentListModal? departmentListModal;
  QueryTypeListModal? queryTypeListModal;
  SubQueryTypeListModal? subQueryTypeListModal;
  List<DataList>? allUsernew = [];
  List<DataList>? foundDataNew = [];
  RaisedQueryListModal? raisedQueryListGlobal;
  RaisedQueryListModal? raisedQueryListGlobaled;
  var deptId;
  var subject = "";
  var queryTypeId;
  var subQueryTypeId;
  var draftid = "0";

  String valuenew = "listText";
  String valuenewSub = "listText";

  //var filePath= "Document";

  @override
  void initState() {
    getSharedPrfanceList();
    //requestStoragePermission();
    _fileFromImageUrl();
    setState(() {});
    // TODO: implement initState
    super.initState();
  }

  var empIdCheck;
  TextEditingController queryDesc = TextEditingController();
  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    empIdCheck = await shared.getEmpId();
    print("EMPID - $empIdCheck");
    //empId=await shared!.getEmpId();
    // await Future.delayed(Duration(seconds: 5));
    Future<DepartmentListModal> getEmployeeList13 = getDepartmentList(
      sessionId!,
    );
    getEmployeeList13.then((value) {
      setState(() {
        departmentListModal = value;
      });

      //print('employeeList00${inductionListLabel!.data!.length}');
    });
    Future<RaisedQueryListModal> getEmployeeList11 = getRaisedList(sessionId!);
    getEmployeeList11.then((value) {
      setState(() {
        foundDataNew = allUsernew;
        raisedQueryListGlobal = value;
        raisedQueryListGlobaled = raisedQueryListGlobal;
      });
      print('employeeList00${raisedQueryListGlobal!.dataList!.length}');
    });
  }

  Future<DepartmentListModal> getDepartmentList(String sessionId) async {
    deptList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.departmentListApi;

    //print('employeeList11: ${SessionId}');
    DepartmentListModal departmentListModal;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    //print("Status $status");
    //print(inductionListLabel!.data!.length);
    print('LOcations ${response.request}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['data'];
    print('responseemployeeList $getData');
    departmentListModal = DepartmentListModal.fromJson(mapResponse);

    for (int i = 0; i < mapResponse['data'].length; i++) {
      deptList.add(mapResponse['data'][i]['deptName']);
      deptId = mapResponse['data'][i]['branchDeptId'];

      print('ID -  $deptId');
      //print("HalfDayShow $halfDayRadioShow");
    }

    return departmentListModal;
  }

  Future<QueryTypeListModal> getQueryTypeList(String sessionId) async {
    queryTypeList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.queryTypeListApi;

    //print('employeeList11: ${SessionId}');
    QueryTypeListModal queryTypeListModal;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "dept=$deptId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    //print("Status $status");
    //print(inductionListLabel!.data!.length);
    print('LOcations ${response.request}');

    mapResponseQuery = json.decode(response.body);
    var getData = mapResponseQuery['statusdata'];
    print('responseemployeeList $getData');
    queryTypeListModal = QueryTypeListModal.fromJson(mapResponseQuery);

    for (int i = 0; i < mapResponseQuery['statusdata'].length; i++) {
      queryTypeList.add(mapResponseQuery['statusdata'][i]['name']);
      queryTypeId = mapResponseQuery['statusdata'][i]['id'];

      print('ID -  $queryTypeId');
      //print("HalfDayShow $halfDayRadioShow");
    }
    return queryTypeListModal;
  }

  Future<SubQueryTypeListModal> getSubQueryTypeList(String sessionId) async {
    subQueryTypeList = [];
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.subQueryTypeListApi;

    //print('employeeList11: ${SessionId}');
    SubQueryTypeListModal subQueryTypeListModal;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$sessionId&"
      "dept=$deptId&"
      "queryId=$queryTypeId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    //print("Status $status");
    //print(inductionListLabel!.data!.length);
    print('LOcations ${response.request}');

    mapResponseSubQuery = json.decode(response.body);
    var getData = mapResponseSubQuery['statusdata'];
    print('responseemployeeList $getData');
    subQueryTypeListModal = SubQueryTypeListModal.fromJson(mapResponseQuery);

    for (int i = 0; i < mapResponseSubQuery['statusdata'].length; i++) {
      subQueryTypeList.add(
        mapResponseSubQuery['statusdata'][i]['subQueryname'],
      );
      subQueryTypeId = mapResponseSubQuery['statusdata'][i]['id'];

      print('ID -  $subQueryTypeId');
      //print("HalfDayShow $halfDayRadioShow");
    }
    return subQueryTypeListModal;
  }

  Future<RaisedQueryListModal> getRaisedList(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.queryRaisedList;
    print('employeeList11: ${SessionId}');
    RaisedQueryListModal raisedQueryListModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await MobileHttpClient.instance.post(urlapi);
    print('Query List - ${response.request}');

    print('responseemployeeList ${response.body}');

    mapResponseRaised = json.decode(response.body);
    var getData = mapResponseRaised['data'];
    print('responseemployeeList $getData');
    raisedQueryListModal = RaisedQueryListModal.fromJson(mapResponseRaised);
    allUsernew = raisedQueryListModal.dataList;

    return raisedQueryListModal;
  }

  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<DataList>? results = [];

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

      results =
          allUsernew
              ?.where(
                (element) => element.ticketNo!.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
              )
              .toList();
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
      foundDataNew = results;
    });
  }

  /*Future<void> requestStoragePermission() async {
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      // Permission granted, you can now access external storage.
      // Perform your operations here.
    } else if (status.isDenied) {
      // Permission denied.
      // You might want to display a dialog or message to the user.
      print('Permission denied by the user.');
    } else if (status.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this app.
      // You can ask the user to go to settings and manually enable the permission.
      //openAppSettings();
    }
  }*/
  String imageToBase64(String imagePath) {
    // Read the image file
    List<int> imageBytes = File(imagePath).readAsBytesSync();

    // Encode the image bytes as base64
    String base64Image = base64Encode(Uint8List.fromList(imageBytes));
    return base64Image;
  }

  String createJsonWithImage(String imagePath) {
    String base64Image = imageToBase64(imagePath);

    // Create a JSON object with the base64-encoded image
    Map<String, dynamic> jsonBody = {
      'image': base64Image,
      'otherData': 'some other data', // Add other data if needed
    };

    // Convert the JSON object to a string
    String jsonString = jsonEncode(jsonBody);
    return jsonString;
  }

  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    var ticketNo = "1AB4124";

    var dropdownNewvalue;
    var dropdownNewvalueNew;
    var dropDownSubLocation;

    void openFile(PlatformFile file) {
      OpenFile.open(file.path!);
      print('Bytes: ${file.name}');
      print('Size: ${file.size}');
      print('Size: ${file.extension}');
      print('Path: ${file.path}');
    }

    Future<File> saveFilePermanently(PlatformFile file) async {
      final appStorage = await getApplicationDocumentsDirectory();
      final newFile = File('${appStorage.path}/${file.name}');
      return File(file.path!).copy(newFile.path);
    }

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
                ButtonBar(
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
                          print(
                            "Heloo ji "
                            "$imageValue",
                          );
                          setState(() {
                            final imagePath = File(imageValue!.path);
                            //this._workDoneImage=imagePath;
                            file = File(imageValue!.path);
                          });
                          imageValue = null;
                          //imageCache.clear();
                        } on Exception catch (e) {
                          print('failed to upload: $e');
                        }
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: "Camera".text.make(),
                    ).px8(),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          //ImagePicker picker = ImagePicker();
                          imageValue = await _picker.pickImage(
                            source: ImageSource.gallery,
                          );

                          //picker.dispose();
                          if (imageValue == null) return;
                          print(
                            "Heloo ji "
                            "$imageValue",
                          );
                          setState(() {
                            final imagePath = File(imageValue!.path);
                            //this._workDoneImage=imagePath;
                            file = File(imageValue!.path);
                          });
                          imageValue = null;
                          //imageCache.clear();
                        } on Exception catch (e) {
                          print('failed to upload: $e');
                        }
                        Navigator.of(context, rootNavigator: true).pop();
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

    var titleName = "Helpdesk";
    TextEditingController searchType = TextEditingController();
    TextEditingController filePath = TextEditingController();
    Future<void> pickFile() async {
      //PermissionStatus status = await Permission.manageExternalStorage.status;

      try {
        final result = await FilePicker.platform.pickFiles(allowMultiple: true);
        if (result == null) return;

        final file = result.files.first;
        filePath.text = file.name;
        //print('Bytes: ${file.bytes}');
        print('Name: ${file.name}');

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
        print('Error picking file: $e');
      }

      /* if (status.isGranted) {


      } else {

        print("Permission denied by the user");
      }*/
    }

    return Material(
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: Mythemes.whitish,
          appBar:
              requestedTicketShow == true
                  ? PreferredSize(
                    preferredSize: Size(double.infinity, 100),
                    child: SafeArea(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(top: BorderSide.none),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 0.5,
                              spreadRadius: 0,
                              offset: Offset(0, 0.2),
                            ),
                          ],
                        ),
                        child: AnimationSearchBar(
                          searchFieldDecoration: BoxDecoration(
                            color: Mythemes.greyishade,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backIcon: Icons.arrow_back_ios,
                          backIconColor: Mythemes.black,
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
                            color: Mythemes.black,
                          ),
                          searchTextEditingController: searchType,
                        ),
                      ),
                    ),
                  )
                  : AppBar(elevation: 0.5, title: "Helpdesk".text.make()),
          body: Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                crossAxisCount: 3,
                children: <Widget>[
                  Card(
                    color: Mythemes.whitish,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          raiseTicketShow = true;
                          requestedTicketShow = false;
                          ticketDashboardShow = false;
                        });
                        print(
                          "m innocent"
                          "$raiseTicketShow",
                        );
                        //Navigator.pushNamed(context, MyRoutings.helpDeskItemsRoute);
                      },
                      child: Stack(
                        children: <Widget>[
                          Center(
                            //heightFactor: 2,
                            child: Icon(
                              CupertinoIcons.doc_text,
                              size: 50,
                              color: Mythemes.greyish,
                            ),
                            /*Image(
                    image: AssetImage('images/applications.png'),width: 100,height: 100,
                  ),*/
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 70, left: 10),
                              padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                              child: Text(
                                'New Request',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Mythemes.blackish,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Mythemes.whitish,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          raiseTicketShow = false;
                          requestedTicketShow = true;
                          ticketDashboardShow = false;
                        });
                        //Navigator.pushNamed(context, MyRoutings.helpDeskItemsRoute);
                      },
                      child: Stack(
                        children: <Widget>[
                          Center(
                            //heightFactor: 2,
                            child: Icon(
                              CupertinoIcons.list_bullet_below_rectangle,
                              size: 45,
                              color: Mythemes.greyish,
                            ),
                            /*Image(
                    image: AssetImage('images/applications.png'),width: 100,height: 100,
                  ),*/
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 70, left: 10),
                              padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                              child: Text(
                                'Requested',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Mythemes.blackish,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Mythemes.whitish,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          raiseTicketShow = false;
                          requestedTicketShow = false;
                          ticketDashboardShow = true;
                        });
                        //Navigator.pushNamed(context, MyRoutings.helpDeskItemsRoute);
                      },
                      child: Stack(
                        children: <Widget>[
                          Center(
                            //heightFactor: 2,
                            child: Icon(
                              Icons.dashboard_customize,
                              size: 45,
                              color: Mythemes.greyish,
                            ),
                            /*Image(
                    image: AssetImage('images/applications.png'),width: 100,height: 100,
                  ),*/
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 70, left: 10),
                              padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                              child: Text(
                                'Dashboard',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Mythemes.blackish,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: raiseTicketShow,
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Image Upload
                          /* file != null ?
                                
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width/2,
                              height: MediaQuery.of(context).size.width/2,
                              decoration: BoxDecoration(
                                border: Border.all(color: Mythemes.greyishade, width: 3),
                                shape: BoxShape.circle,
                                color: Mythemes.whitish,
                                image: DecorationImage(
                                  fit: BoxFit.scaleDown,
                                  image:  FileImage(file!),
                                  */
                          /*FileImage(file!)*/
                          /*
                                ),
                              ),

                            )
                                :
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width/2,
                              height: MediaQuery.of(context).size.width/2,
                              decoration: BoxDecoration(
                                border: Border.all(color: Mythemes.greyishade, width: 3),
                                shape: BoxShape.circle,
                                color: Mythemes.whitish,
                                image: DecorationImage(
                                  fit: BoxFit.scaleDown,
                                  image:  NetworkImage("https://s3.ap-south-1.amazonaws.com/employroll.com/images/1707640420694.png"),
                                  */
                          /*FileImage(file!)*/
                          /*
                                ),
                              ),

                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: "Attachments".text.make(),
                                ),
                              ],
                            ),
                            Row(
                              */
                          /*crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,*/
                          /*
                              children: [
                                Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            tooltip: 'Attach Image',
                                            onPressed: () async {
                                              imagePickerModal(context,
                                                  onCameraTap: () {}, onGalleryTap: () {});
                                            },
                                            icon: Icon(
                                              Icons.add, color: Mythemes.lightBluishColor,
                                            )
                                        )

                                      ],
                                    )
                                ),
                              ],
                            ),*/
                          Row(
                            children: [
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
                                        labelText: "Department",
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
                                      items:
                                          deptList.map<
                                            DropdownMenuItem<String>
                                          >((String? value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value!,
                                                style: TextStyle(fontSize: 9),
                                                maxLines: 2,
                                              ),
                                            );
                                          }).toList(),
                                      onChanged: (newVal) {
                                        valuenew = newVal.toString();
                                        //int i =workTypeList.indexOf(valuenew);
                                        for (
                                          int i = 0;
                                          i < mapResponse['data'].length;
                                          i++
                                        ) {
                                          if (mapResponse['data'][i]['deptName']
                                                  .toString()
                                                  .compareToIgnoringCase(
                                                    newVal.toString(),
                                                  ) ==
                                              0) {
                                            deptId =
                                                mapResponse['data'][i]['branchDeptId'];
                                            subject =
                                                mapResponse['data'][i]['deptName'];
                                            print("workTypeId $deptId");
                                            print("workTypeId $subject");
                                          }
                                        }
                                        setState(() {
                                          dropdownNewvalueNew = newVal;
                                          Future<QueryTypeListModal>
                                          getSubLocation = getQueryTypeList(
                                            sessionId!,
                                          );
                                          getSubLocation.then((value) {
                                            setState(() {
                                              queryTypeListModal = value;
                                            });

                                            //print('employeeList00${inductionListLabel!.data!.length}');
                                          });
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
                                        labelText: "Query Type",
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
                                      items:
                                          queryTypeList.map<
                                            DropdownMenuItem<String>
                                          >((String? value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value!,
                                                style: TextStyle(fontSize: 9),
                                                maxLines: 2,
                                              ),
                                            );
                                          }).toList(),
                                      onChanged: (newVal) {
                                        valuenew = newVal.toString();
                                        //int i =workTypeList.indexOf(valuenew);
                                        for (
                                          int i = 0;
                                          i <
                                              mapResponseQuery['statusdata']
                                                  .length;
                                          i++
                                        ) {
                                          if (mapResponseQuery['statusdata'][i]['description']
                                                  .toString()
                                                  .compareToIgnoringCase(
                                                    newVal.toString(),
                                                  ) ==
                                              0) {
                                            queryTypeId =
                                                mapResponseQuery['statusdata'][i]['id'];
                                            print("subLocation $queryTypeId");
                                          }
                                        }
                                        setState(() {
                                          dropDownSubLocation = newVal;
                                          Future<SubQueryTypeListModal>
                                          getSubQuery = getSubQueryTypeList(
                                            sessionId!,
                                          );
                                          getSubQuery.then((value) {
                                            setState(() {
                                              subQueryTypeListModal = value;
                                            });

                                            //print('employeeList00${inductionListLabel!.data!.length}');
                                          });
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
                                        labelText: "Sub Query Type",
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
                                      items:
                                          subQueryTypeList.map<
                                            DropdownMenuItem<String>
                                          >((String? value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value!,
                                                style: TextStyle(fontSize: 9),
                                                maxLines: 2,
                                              ),
                                            );
                                          }).toList(),
                                      onChanged: (newVal) {
                                        valuenew = newVal.toString();
                                        //int i =workTypeList.indexOf(valuenew);
                                        for (
                                          int i = 0;
                                          i <
                                              mapResponseSubQuery['statusdata']
                                                  .length;
                                          i++
                                        ) {
                                          if (mapResponseSubQuery['statusdata'][i]['description']
                                                  .toString()
                                                  .compareToIgnoringCase(
                                                    newVal.toString(),
                                                  ) ==
                                              0) {
                                            subQueryTypeId =
                                                mapResponseSubQuery['statusdata'][i]['id'];
                                            print("Id -  $subQueryTypeId");
                                          }
                                        }
                                        setState(() {
                                          dropDownSubLocation = newVal;
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
                                    TextFormField(
                                      style: TextStyle(fontSize: 13),
                                      controller: queryDesc,
                                      enabled: true,
                                      // initialValue: "Head Office",
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          //<-- SEE HERE
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Mythemes.blackishade,
                                          ),
                                        ),
                                        //labelText: "Select Department",
                                        hintText: "Add Description",
                                        labelText: "Description",
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
                                      controller: filePath,
                                      onTap: () => pickFile(),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonBar(
                                alignment: MainAxisAlignment.center,
                                buttonPadding: Vx.mOnly(right: 16),
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      file == "null" ? 0 : file;
                                      queryRaise(
                                        sessionId!,
                                        file!,
                                        queryTypeId,
                                        draftid,
                                        deptId,
                                        subject,
                                        queryDesc.text,
                                        "SAVE",
                                        subQueryTypeId,
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                            Mythemes.lightBluishColor,
                                          ),
                                    ),
                                    child: "Send".text.make(),
                                  ).wh(150, 40).py12(),
                                ],
                              ),
                            ],
                          ).py32(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: requestedTicketShow,
                child: Expanded(
                  child:
                      raisedQueryListGlobaled == null
                          ? Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(bottom: 14),
                                    height: 640,
                                    child: ListView.builder(
                                      itemCount: foundDataNew!.length,
                                      itemBuilder: (context, i) {
                                        return InkWell(
                                          onTap: () {
                                            //Navigator.pushNamed(context, MyRoutings.hdRaisedTicketReplyRoute);
                                          },
                                          child: Card(
                                            elevation: 2,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      "Ticket No :".text
                                                          .make()
                                                          .px8()
                                                          .py4(),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            foundDataNew![i]
                                                                .ticketNo
                                                                .toString()
                                                                .text
                                                                .textStyle(
                                                                  context
                                                                      .captionStyle,
                                                                )
                                                                .size(12)
                                                                .make()
                                                                .px4(),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            foundDataNew![i]
                                                                .queryStatusName
                                                                .toString()
                                                                .text
                                                                .color(
                                                                  Mythemes
                                                                      .lightBluishColor,
                                                                )
                                                                .sm
                                                                .make()
                                                                .px8(),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            foundDataNew![i]
                                                                .subject
                                                                .toString()
                                                                .text
                                                                .size(13)
                                                                .maxLines(2)
                                                                .ellipsis
                                                                .make()
                                                                .px8(),
                                                      ),

                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            foundDataNew![i]
                                                                .timeAgo
                                                                .toString()
                                                                .text
                                                                .textStyle(
                                                                  context
                                                                      .captionStyle,
                                                                )
                                                                .make()
                                                                .px8(),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ).py2(),
                                                  Row(
                                                    children: [
                                                      foundDataNew![i]
                                                          .creationDate
                                                          .toString()
                                                          .text
                                                          .make()
                                                          .px8(),
                                                    ],
                                                  ).py2(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                ),
              ),
              Visibility(
                visible: ticketDashboardShow,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    MyRoutings.hdOpenTicketRoute,
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Mythemes.whitish,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    //margin: EdgeInsets.only(right: 10.0),
                                    height: 88,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    //color: Mythemes.purplish,
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                "Open".text.bold
                                                    .overflow(
                                                      TextOverflow.ellipsis,
                                                    )
                                                    .maxLines(1)
                                                    .size(16)
                                                    .color(
                                                      Mythemes.lightBluishColor,
                                                    )
                                                    .make()
                                                    .py12()
                                                    .px8(),
                                                Container(
                                                  child:
                                                      "120".text.xl2.bold
                                                          .color(
                                                            Mythemes
                                                                .lightBluishColor,
                                                          )
                                                          .make(),
                                                ).px8(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                LinearPercentIndicator(
                                                  width: 155.0,
                                                  lineHeight: 5.0,
                                                  percent: 0.75,
                                                  backgroundColor:
                                                      Mythemes.greyishade,
                                                  progressColor:
                                                      Mythemes.lightBluishColor,
                                                ),
                                              ],
                                            ).py16(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    MyRoutings.hdOverdueTicketRoute,
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Mythemes.whitish,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    //margin: EdgeInsets.only(right: 10.0),
                                    height: 88,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    //color: Mythemes.purplish,
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                "Overdue".text.bold
                                                    .overflow(
                                                      TextOverflow.ellipsis,
                                                    )
                                                    .maxLines(1)
                                                    .size(16)
                                                    .color(
                                                      Mythemes.dangerColorOne,
                                                    )
                                                    .make()
                                                    .py12()
                                                    .px8(),
                                                Container(
                                                  child:
                                                      "101".text.xl2.bold
                                                          .color(
                                                            Mythemes
                                                                .dangerColorOne,
                                                          )
                                                          .make(),
                                                ).px8(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                LinearPercentIndicator(
                                                  width: 155.0,
                                                  lineHeight: 5.0,
                                                  percent: 0.45,
                                                  backgroundColor:
                                                      Mythemes.greyishade,
                                                  progressColor:
                                                      Mythemes.dangerColor,
                                                ),
                                              ],
                                            ).py16(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    MyRoutings.hdDueTodayTicketRoute,
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Mythemes.whitish,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    //margin: EdgeInsets.only(right: 10.0),
                                    height: 88,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    //color: Mythemes.purplish,
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                "Due Today".text.bold
                                                    .overflow(
                                                      TextOverflow.ellipsis,
                                                    )
                                                    .maxLines(1)
                                                    .size(16)
                                                    .color(Mythemes.alertColor)
                                                    .make()
                                                    .py12()
                                                    .px8(),
                                                Container(
                                                  child:
                                                      "26".text.xl2.bold
                                                          .color(
                                                            Mythemes.alertColor,
                                                          )
                                                          .make(),
                                                ).px8(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                LinearPercentIndicator(
                                                  width: 155.0,
                                                  lineHeight: 5.0,
                                                  percent: 0.18,
                                                  backgroundColor:
                                                      Mythemes.greyishade,
                                                  progressColor:
                                                      Mythemes.alertColor,
                                                ),
                                              ],
                                            ).py16(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    MyRoutings.hdOnHoldTicketRoute,
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Mythemes.whitish,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    //margin: EdgeInsets.only(right: 10.0),
                                    height: 88,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    //color: Mythemes.purplish,
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                "On Hold".text.bold
                                                    .overflow(
                                                      TextOverflow.ellipsis,
                                                    )
                                                    .maxLines(1)
                                                    .size(16)
                                                    .color(
                                                      Mythemes.warningColor,
                                                    )
                                                    .make()
                                                    .py12()
                                                    .px8(),
                                                Container(
                                                  child:
                                                      "210".text.xl2.bold
                                                          .color(
                                                            Mythemes
                                                                .warningColor,
                                                          )
                                                          .make(),
                                                ).px8(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                LinearPercentIndicator(
                                                  width: 155.0,
                                                  lineHeight: 5.0,
                                                  percent: 0.55,
                                                  backgroundColor:
                                                      Mythemes.greyishade,
                                                  progressColor:
                                                      Mythemes.warningColor,
                                                ),
                                              ],
                                            ).py16(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    MyRoutings.hdNewTicketRoute,
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Mythemes.whitish,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    //margin: EdgeInsets.only(right: 10.0),
                                    height: 88,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    //color: Mythemes.purplish,
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                "New Ticket".text.bold
                                                    .overflow(
                                                      TextOverflow.ellipsis,
                                                    )
                                                    .maxLines(1)
                                                    .size(16)
                                                    .color(Mythemes.alertColor)
                                                    .make()
                                                    .py12()
                                                    .px8(),
                                                Container(
                                                  child:
                                                      "126".text.xl2.bold
                                                          .color(
                                                            Mythemes.alertColor,
                                                          )
                                                          .make(),
                                                ).px8(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                LinearPercentIndicator(
                                                  width: 155.0,
                                                  lineHeight: 5.0,
                                                  percent: 0.80,
                                                  backgroundColor:
                                                      Mythemes.greyishade,
                                                  progressColor:
                                                      Mythemes.alertColor,
                                                ),
                                              ],
                                            ).py16(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    MyRoutings.hdReOpenTicketRoute,
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Mythemes.whitish,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    //margin: EdgeInsets.only(right: 10.0),
                                    height: 88,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    //color: Mythemes.purplish,
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                "Re-open".text.bold
                                                    .overflow(
                                                      TextOverflow.ellipsis,
                                                    )
                                                    .maxLines(1)
                                                    .size(16)
                                                    .color(
                                                      Mythemes.lightBluishColor,
                                                    )
                                                    .make()
                                                    .py12()
                                                    .px8(),
                                                Container(
                                                  child:
                                                      "40".text.xl2.bold
                                                          .color(
                                                            Mythemes
                                                                .lightBluishColor,
                                                          )
                                                          .make(),
                                                ).px8(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                LinearPercentIndicator(
                                                  width: 155.0,
                                                  lineHeight: 5.0,
                                                  percent: 0.40,
                                                  backgroundColor:
                                                      Mythemes.greyishade,
                                                  progressColor:
                                                      Mythemes.lightBluishColor,
                                                ),
                                              ],
                                            ).py16(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    MyRoutings.hdResolvedTicketRoute,
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Mythemes.whitish,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    //margin: EdgeInsets.only(right: 10.0),
                                    height: 88,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    //color: Mythemes.purplish,
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                "Resolved".text.bold
                                                    .overflow(
                                                      TextOverflow.ellipsis,
                                                    )
                                                    .maxLines(1)
                                                    .size(16)
                                                    .color(
                                                      Mythemes.successColor,
                                                    )
                                                    .make()
                                                    .py12()
                                                    .px8(),
                                                Container(
                                                  child:
                                                      "86".text.xl2.bold
                                                          .color(
                                                            Mythemes
                                                                .successColor,
                                                          )
                                                          .make(),
                                                ).px8(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                LinearPercentIndicator(
                                                  width: 155.0,
                                                  lineHeight: 5.0,
                                                  percent: 0.45,
                                                  backgroundColor:
                                                      Mythemes.greyishade,
                                                  progressColor:
                                                      Mythemes.successColor,
                                                ),
                                              ],
                                            ).py16(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    MyRoutings.hdCancelledTicketRoute,
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Mythemes.whitish,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    //margin: EdgeInsets.only(right: 10.0),
                                    height: 88,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    //color: Mythemes.purplish,
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                "Cancelled".text.bold
                                                    .overflow(
                                                      TextOverflow.ellipsis,
                                                    )
                                                    .maxLines(1)
                                                    .size(16)
                                                    .color(Mythemes.dangerColor)
                                                    .make()
                                                    .py12()
                                                    .px8(),
                                                Container(
                                                  child:
                                                      "210".text.xl2.bold
                                                          .color(
                                                            Mythemes
                                                                .dangerColor,
                                                          )
                                                          .make(),
                                                ).px8(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                LinearPercentIndicator(
                                                  width: 155.0,
                                                  lineHeight: 5.0,
                                                  percent: 0.2,
                                                  backgroundColor:
                                                      Mythemes.greyishade,
                                                  progressColor:
                                                      Mythemes.dangerColor,
                                                ),
                                              ],
                                            ).py16(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> queryRaise(
    String sessionId,
    File image,
    int queryType,
    String draftid,
    int dept,
    String subject,
    String description,
    String status,
    int subqueryObj,
  ) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.querySendApi;
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
      "http://super.employroll.com:8081/employroll/api/third/party/org/raised/query/details/saved/mobile",
    );
    var request = http.MultipartRequest("Post", uri);
    request.fields['sessionId'] = sessionId;
    request.fields['queryType'] = "$queryTypeId";
    request.fields['draftid'] = "0";
    request.fields['dept'] = "$deptId";
    request.fields['subject'] = queryDesc.text;
    request.fields['description'] = description;
    request.fields['status'] = "SAVE";
    request.fields['subqueryObj'] = "$subQueryTypeId";
    print('URL $uri');

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

    var stream = http.ByteStream(file!.openRead());
    stream.cast();
    var length = await file!.length();
    print('Response status: ${length}');
    print('Response body: ${stream}');
    print('Response body: ${file}');
    print("$stream");

    var multipart = http.MultipartFile(
      'image',
      stream,
      length,
      filename: basename('image.jpg'),
    );
    request.files.add(multipart);
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
          this.context,
          result.upperCamelCase + " ",
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

  void openFiles(List<PlatformFile> files) {}

  //Image picker
  Future<String> pickImage({ImageSource? source}) async {
    final picker = ImagePicker();

    String path = '';

    try {
      final getImage = await picker.pickImage(source: source!);

      if (getImage != null) {
        path = getImage.path;
      } else {
        path = '';
      }
    } catch (e) {
      log(e.toString());
    }

    return path;
  }

  //Image crop
  Future<String> imageCropperView(String? path, BuildContext context) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path!,
      /* aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],*/
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Mythemes.lightBluishColor,
          toolbarWidgetColor: Mythemes.whitish,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Image'),
        WebUiSettings(context: context),
      ],
    );

    if (croppedFile != null) {
      log("Image cropped");
      return croppedFile.path;
    } else {
      log("Do nothing");
      return '';
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
}

/*class HelpdeskWidget extends StatelessWidget {
  const HelpdeskWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 3,
          child:
          ListTile(
            leading:  Icon(
              CupertinoIcons.doc_plaintext, size: 30,
            ),

            title: "Raise Query".text.make(),
            trailing:  Icon(
                CupertinoIcons.chevron_forward
            ),

          ),
        ),
        Card(
          elevation: 3,
          child:
          ListTile(
            leading:  Icon(
              Icons.more_time, size: 30,
            ),

            title: "Self Raised List".text.make(),
            trailing:  Icon(
                CupertinoIcons.chevron_forward
            ),

          ),
        ),
      ],
    );
  }
}*/
