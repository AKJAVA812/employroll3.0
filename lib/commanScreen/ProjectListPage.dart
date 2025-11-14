import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;
import '../main.dart';
import '../sharedPrefancePage/ShardPre.dart';
import '../singUP/model/loginModel.dart';
import '../widgets/drawer_file.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:er_flutter_project/main.dart';
import '../mss_profiles/global_profile.dart';
import 'allAPIList.dart';
class ProjectList extends StatefulWidget {
  const ProjectList({Key? key}) : super(key: key);

  @override
  State<ProjectList> createState() => _ProjectListState();
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
String? userType;
String? emailId;
String? userPanel;
String? profileName;
dynamic profileId;
dynamic empIdNew;
bool? setShowPayroll;
String? setPreOnboardShow;
String? setExitShow;
String? setMyTeamShow;
String? setMyTeamPageShow;
String? setExitResignationListShow = "false";
String? setExitResignationListView = "0";
int? orgId;
String? orgName;
int? empRoles;
int? roRoles;
int? adminRoles;
bool showHide = false;
bool showAdmin = false;
bool showRo = false;
String? claimLevelOneMO;
String? claimLevelTwoMO;
String? claimLevelThreeMO;
String? claimLevelOneMSS;
String? claimLevelTwoMSS;
String? claimLevelThreeMSS;
String? claimLevelOneUIS;
String? claimLevelTwoUIS;
String? claimLevelThreeUIS;
String pendingLoanRequestMoL1Permission = "0";
String pendingLoanRequestMoL2Permission = "0";
String pendingLoanRequestMoL3Permission = "0";
String pendingLoanRequestMSSL1Permission = "0";
String pendingLoanRequestMSSL2Permission = "0";
String pendingLoanRequestMSSL3Permission = "0";
String pendingLoanRequestUISL1Permission = "0";
String pendingLoanRequestUISL2Permission = "0";
String pendingLoanRequestUISL3Permission = "0";
String odPendingPermissionMSS = "0";
dynamic mobOdCount;
dynamic odReqCount;
dynamic tourReqCount;
dynamic attReqCount;
dynamic leaveReqCount;
class _ProjectListState extends State<ProjectList> with RouteAware{
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(this.context)!);
    //routeObserver.subscribe(this, ModalRoute.of(context)!);
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
  int currentIndex = 0;
  final ImagePicker _picker = ImagePicker();
  File? image;

  var attendaceReqCount;
  var leaveReqCount;
  var odReqCount;


  Future<LoginModel> monthAttendance(String emailId, String password) async {
    LoginModel loginModel;
    var urlapi = Uri.parse(
        "http://www.employroll.com/restful/service/login?userName=$emailId&password=$password");
    /*  final response= await http.get(urlapi,headers: {
      "email": emailId,
      "password": password
    });*/
    final response = await http.get(urlapi);
    //print('Response status: ${response.request}');
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');
    mapResponse = json.decode(response.body);
    loginModel = LoginModel.fromJson(mapResponse);
    return loginModel;

  }

  /*Future monthAttendancePost(String sessionId) async{
   // http://35.154.190.199/restful/service/employee/profile?sessionId=2438b3da66423f389e578692c69d333dc86b648e5df
    var urlapi=Uri.parse("http://www.employroll.com/restful/service/employee/profile");
     final response= await http.post(urlapi,body: {
      "sessionId": sessionId,
    });
    print('Response status: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if(response.statusCode==200){
      setState(() {
        //stringResponse= response.body;
        mapResponse=json.decode(response.body);
        print(stringResponse);
      });
    }
  }*/

  Future getSharedPrfanceList() async {

    sessionId = await shared.getSessionId();
    userType = await shared.getUserType();


    setState(() {

    });
    //print("User Type - $userType");
    setShowPayroll = await shared.getShowPayroll();
    orgId = await shared.getOrgId();
    emailId = await shared.getEmailId();
    empIdNew = await shared.getEmpId();
    orgName = await shared.getOrgName();
    empRoles= await shared.getEmpRoll();
    roRoles= await shared.getRoRole();
    adminRoles= await shared.getAdminRole();
    setPreOnboardShow= await shared.getPreOnboardShow();
    setExitShow= await shared.getExitShow();
    setMyTeamShow= await shared.getMyTeamShow();
    setExitResignationListShow= await shared.getExitResignationListShow();
    setExitResignationListView= await shared.getExitResignationListView();
    odPendingPermissionMSS= (await shared.getODPendingList())!;
    setState(() {

    });
    //print("Resignation View 1 $setExitResignationListShow");
    //print("Resignation View 2 $setExitResignationListView");
    //print("MY TEAM SHOW - $setMyTeamShow");
    userPanel= await shared.getUserPanel();
    //print("USER PANEL - $userPanel");
    claimLevelOneMSS = await shared.getClaimLevelOne();
    //print("CLAIM APPROVAL L1 - $claimLevelOneMSS");
    claimLevelTwoMSS = await shared.getClaimLevelTwo();
    claimLevelThreeMSS = await shared.getClaimLevelThree();
    claimLevelOneMO = await shared.getClaimLevelOneMO();
    claimLevelTwoMO = await shared.getClaimLevelTwoMO();
    claimLevelThreeMO = await shared.getClaimLevelThreeMO();
    claimLevelOneUIS = await shared.getClaimLevelOneUIS();
    claimLevelTwoUIS = await shared.getClaimLevelTwoUIS();
    claimLevelThreeUIS = await shared.getClaimLevelThreeUIS();
    pendingLoanRequestMoL1Permission = (await shared.getLoanApprovalL1MO())!;
    pendingLoanRequestMSSL1Permission= (await shared.getLoanApprovalL1MSS())!;
    pendingLoanRequestUISL1Permission= (await shared.getLoanApprovalL1UIS())!;
    pendingLoanRequestMoL2Permission = (await shared.getLoanApprovalL2MO())!;
    pendingLoanRequestMSSL2Permission= (await shared.getLoanApprovalL2MSS())!;
    pendingLoanRequestUISL2Permission= (await shared.getLoanApprovalL2UIS())!;
    pendingLoanRequestMoL3Permission = (await shared.getLoanApprovalL3MO())!;
    pendingLoanRequestMSSL3Permission= (await shared.getLoanApprovalL3MSS())!;
    pendingLoanRequestUISL3Permission= (await shared.getLoanApprovalL3UIS())!;
    setMyTeamPageShow= (await shared.getMyTeamPageShow())!;

    //print("MY TEAM SHOW NEW - $setMyTeamPageShow");
    //print("Pending Attendance Request MSS MO- $pendingLoanRequestMoL1Permission");
    //print("Pending Attendance Request MSS- $pendingLoanRequestMSSL1Permission");
    //print("Pending Attendance Request UIS- $pendingLoanRequestUISL1Permission");

    if(userPanel == "COMPANY_EMPLOYEE") {
      value = 0;
    } else {
      value = 1;
    }
    profileName= await shared.getDefaultProfileName();
    profileId= await shared.getDefaultProfileId();
    getRequisitionCounts(sessionId!);
    //print("Default Profile Name - $profileName");
    //print("Default Profile Id - $profileId");
    //print("User Panel - $userPanel");
    //print('Pre-Onboard $setPreOnboardShow');
    //print('Exit Show $setExitShow');
    //print('empRole $empRoles');
    //print('roRole $roRoles');
    //print('adminRole $adminRoles');
    //print('Response snapshot: ${sessionId}');
    //print('Show Payroll: ${setShowPayroll}');
    //print('OrgId -  ${orgId}');
    //print('OrgName - : ${orgName}');
    setState(() {

    });
    setState(() {
      if(empRoles==1){
        showHide=true;
        //print('Show Emp $showHide');
        setState(() {
        });
      }
      if(empRoles==0){
        showHide=false;
        //print('Show Emp $showHide');
        setState(() {
        });
      }
      if (adminRoles == 0) {
        showAdmin = false;
        //print("Show Admin $showAdmin");
      }
      if (adminRoles == 1) {
        showAdmin = true;
        //print("Show Admin $showAdmin");
      }
      if (roRoles == 0) {
        showRo = false;

        //print("Show Ro $showRo");
      }
      if (roRoles == 1) {
        showRo = true;
        //print("Show Ro $showRo");
      }
    });
  }

  Future getImage() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (photo != null) {
      image = File(photo.path);
      uploadImage();
      setState(() {});
    } else {
      //print('no image selected');
    }

    //_uploadFile(photo);
    //File file = File(photo!.path);
    //uploadImage1(file);
    // Pick an image
    //final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadImage() async {
    var stream = new http.ByteStream(image!.openRead());
    stream.cast();

    var length = await image!.length();
    //print('Response status: ${length}');
    //print('Response body: ${stream}');
    //print('Response body: ${image}');
    //var uri = Uri.parse("https://c264-2401-4900-1c68-cb6f-f5aa-6720-cdf2-749.ngrok.io/restful/service/attendance/via/mobile");
    var uri = Uri.parse(
        "http://www.employroll.com//restful/service/attendance/via/mobile");
    var request = new http.MultipartRequest("Post", uri);
    request.fields['sessionId'] = "53eb75da8f2f2eb7171c4dd55e343e3c405eda9d5e9";
    request.fields['currentDate'] = "2022-06-13 9:35:14";
    request.fields['address'] =
        "F-35/1,Okhla Industrial Area,NewDelhi,Delhi,110020";
    request.fields['clockingType'] = "in";
    request.fields['lat'] = "28.5367794";
    request.fields['lng'] = "77.2714404";

    var multipart = new http.MultipartFile('image', stream, length,
        filename: basename('image.jpg'));

/*    var multipart = new http.MultipartFile.fromBytes(
        'image', (await rootBundle.load('image')).buffer.asUint8List(),
        filename: 'image.jpg');*/

    request.files.add(multipart);
    var response = await request.send();

    var responseData = await response.stream.bytesToString();
    //print('Response body: ${request}');
    //print('Response body: ${response.toString()}');
    //print('Response body: ${responseData.toString()}');
    //print('Response body: ${response.statusCode}');
  }

  //============================== Image from gallery
  Future getGalleryImage() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
  }

  void _uploadFile(filePath) async {
    String filename = basename(filePath.path);
    //print("File base name $filename");
    try {
      FormData fromData = new FormData.fromMap({
        'sessionId': "1116a07f94bbd789c25280a8a480ced5d87a8811714",
        'currentDate': "2022-06-11 19:35:14",
        'address': "F-35/1,Okhla Industrial Area,NewDelhi,Delhi,110020",
        'clockingType': "in",
        'lat': "28.5367794",
        'lng': "77.2714404",
        //'file': await MultipartFile.fromFile('image.jpg', filename: filename),
        //'image': new UploadFileInfo(new File('image.jpg',filename)),
      });
      Response response = await Dio().post(
          "http://www.employroll.com/restful/service/attendance/via/mobile",
          data: fromData);

      //print('Response status: ${response.statusMessage}');
      //print('Response status: ${response.statusCode}');
      //print('Response body: ${response}');
    } catch (e) {
      //print('Response statuserror: ${e.toString()}');
    }
  }

  void uploadImage1(File _image) async {
    var stream = new http.ByteStream(_image.openRead());
    stream.cast();
    // get file length
    var length = await _image.length();

    // string to uri
    var uri = Uri.parse("enter here upload URL");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
    request.fields["user_id"] = "text";

    // multipart that takes file.. here this "image_file" is a key of the API request
    var multipartFile = new http.MultipartFile('image_file', stream, length,
        filename: basename(_image.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        //print(value);
        //print('Response status: ${response.stream}');
        //print('Response status: ${response.statusCode}');
        //print('Response body: ${response}');
      });
    }).catchError((e) {
      //print(e);
    });
  }

  Future<void> getRequisitionCounts(String sessionId) async {
    try {
      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.reqCountApi;

      var urlapi = Uri.parse("$conn$apiUrl?"
          "sessionId=$sessionId&"
          "profileId=$profileId&"
          "userPermission=$userPanel");

      final response = await http.post(urlapi);

      //print("Requisition Count API - ${response.request}");
      //print("Response Body - ${response.body}");

      Map<String, dynamic> mapResponse = json.decode(response.body);

      // After decoding response
      int attReqCount = mapResponse['attReqCount'] ?? 0;
      int leaveReqCount = mapResponse['leaveReqCount'] ?? 0;
      int mobOdCount = mapResponse['mobOdCount'] ?? 0;

// ✅ Update global notifiers
      attReqCountNotifier.value = attReqCount;
      leaveReqCountNotifier.value = leaveReqCount;
      odReqCountNotifier.value = mobOdCount;

// ✅ Also persist in SharedPreferences for app relaunch
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("attReqCount", attReqCount);
      await prefs.setInt("leaveReqCount", leaveReqCount);
      await prefs.setInt("mobOdCount", mobOdCount);

      // ✅ Assign values to variables
      mobOdCount = mapResponse['mobOdCount'] ?? 0;
      leaveReqCount = mapResponse['leaveReqCount'] ?? 0;
      odReqCount = mapResponse['odReqCount'] ?? 0;
      tourReqCount = mapResponse['tourReqCount'] ?? 0;
      attReqCount = mapResponse['attReqCount'] ?? 0;


      // ✅ Save all data into SharedPreferences
      //final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("mobOdCount", mobOdCount);
      await prefs.setInt("leaveReqCount", leaveReqCount);
      await prefs.setInt("odReqCount", odReqCount);
      await prefs.setInt("tourReqCount", tourReqCount);
      await prefs.setInt("attReqCount", attReqCount);

      //print("Saved Requisition Counts to SharedPreferences ✅");

    } catch (e) {
      //print("Error fetching requisition counts: $e");
    } finally {
      setState(() {
        //isLoading = false; // hide loader always
      });
    }
  }

  @override
  void initState() {
    getSharedPrfanceList();
    //monthAttendance("ankurraj812@gmail.com","8882758942");
    //monthAttendancePost("1116a07f94bbd789c25280a8a480ced5d87a8811714");
    super.initState();
  }

/*  final screens = [
    Center(
      child: Text(
        'Home',
        style: TextStyle(fontSize: 60),
      ),
    ),
    Center(
      child: Text(
        'Home 2',
        style: TextStyle(fontSize: 60),
      ),
    ),
    Center(
      child: Text(
        'Home 3',
        style: TextStyle(fontSize: 60),
      ),
    ),
    Center(
      child: Text(
        'Home 4',
        style: TextStyle(fontSize: 60),
      ),
    )
  ];*/
  var hideWidget = false;


  int value = 0;

  @override
  Widget build(BuildContext context) {

    // Get the screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // You can use these values to determine the size of your widget
    double widgetWidth = screenWidth * 0.03; // 80% of the screen width
    double widgetHeight = screenHeight * 0.5; // 50% of the screen height
    double boxText = widgetWidth;
    List<Widget> generateGridViewItems() {
      //print("CheckOrg - $orgId");
      List<Widget> items = [];

      //ESS Cards
      //My Requests
      if(value == 0) {
        items.add(
          Hero(
            tag: 'myAllRequests',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.myAllRequestRoute);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.playlist_add_rounded,
                        size: 50,
                        color: Mythemes.successColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'My Requests',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      //My Reports
      if(value == 0) {
        items.add(
          Hero(
            tag: 'myAllReports',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.myAllReportsRoute);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.data_exploration_outlined,
                        size: 50,
                        color: Mythemes.lightBluishColor,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'My Reports',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      if(value == 0) {
        items.add(
          Hero(
            tag: 'myReporting',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, MyRoutings.reportingOfficerPageRoute);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.manage_accounts_rounded,
                        size: 50,
                        color: Colors.purpleAccent,
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'My Managers',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      //HRIS Requisition
      if(userType != 'COMPANY_ADMIN' && value == 0 && value != 1) {
        items.add(
          Hero(
            tag: 'hrisReport',
            child: InkWell(
              onTap: () {
                /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                Navigator.pushNamed(context, MyRoutings.hrDetailsRoute);
              },
              child: Card(
                color: Mythemes.whitish,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.supervised_user_circle,
                        size: 50,
                        color: Colors.orange,
                      ),
                      /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'My Profile',
                            style:
                            TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      if(value == 1 || userPanel == "USER") {
          //Time & Attendance
          if(orgId != 144 && orgId != 138 || value == 1) {
            items.add(
              Hero(
                tag: 'reportAnimate',
                child: Card(
                  color: Mythemes.whitish,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, MyRoutings.timeAttRoute);
                    },
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.more_time_rounded,
                            size: 50,
                            color: Mythemes.lightBluishColor,
                          ),
                          /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 75, left: 10),
                            padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                                'Attendance',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style:
                                TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                            ),
                          ),
                        ),
                        // 🔹 Badge at top-right
                        Positioned(
                          top: 6,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.redAccent, // badge background color
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 24,
                              minHeight: 24,
                            ),
                            child: Center(
                              child: ValueListenableBuilder(
                                valueListenable: attReqCountNotifier,
                                builder: (context, value, _) {
                                  return Text(
                                    "$value", // your dynamic count variable
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

        //Leave Management

          items.add(
            Hero(
              tag: 'leaveReport',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, MyRoutings.leaveManageReportRoute);
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.calendar_month_rounded,
                          size: 50,
                          color: Mythemes.successColor,
                        ),
                        /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 75, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                              'Leave',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.redAccent, // badge background color
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                          ),
                          child: Center(
                            child: ValueListenableBuilder(
                              valueListenable: leaveReqCountNotifier,
                              builder: (context, value, _) {
                                return Text(
                                  "$value", // your dynamic count variable
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

          //OUT DUTY
          if(odPendingPermissionMSS == "1") {
            items.add(
              Hero(
                tag: 'odReport',
                child: Card(
                  color: Mythemes.whitish,
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, MyRoutings.onDutyTypes);
                      /*Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
                    },
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.business_center,
                            size: 50,
                            color: Colors.orange,
                          ),
                          /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 75, left: 10),
                            padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                                'OD',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style:
                                TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                            ),
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.redAccent, // badge background color
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 24,
                              minHeight: 24,
                            ),
                            child: Center(
                              child: ValueListenableBuilder(
                                valueListenable: odReqCountNotifier,
                                builder: (context, value, _) {
                                  return Text(
                                    "$value", // your dynamic count variable
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }




        //TRAVEL & EXPENSE
        if(claimLevelOneMSS == "1" || claimLevelTwoMSS == "1" || claimLevelThreeMSS == "1") {
          items.add(
            Hero(
              tag: 'claim',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, MyRoutings.claimItemsListRoute);
                    /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.currency_exchange,
                          size: 50,
                          color: Mythemes.warningColor,
                        ),
                        /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 75, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                              'Claim',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        //Advance
        if(orgId == 3 || orgId == 145 || orgId == 39) {
          items.add(
            Hero(
              tag: 'claimAdvance',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, MyRoutings.claimAdvanceRoute);
                    /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.payment,
                          size: 50,
                          color: Mythemes.successColor,
                        ),
                        /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 75, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                              'Advance',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        //Loan
          //MSS MO
          if(
              userPanel == "MSS_MO_ADMIN" &&
                  (
                      pendingLoanRequestMoL1Permission == "LOAN_APPROVAL_LEVEL_ONE_ADD" ||
                          pendingLoanRequestMoL2Permission == "LOAN_APPROVAL_LEVEL_TWO_ADD" ||
                          pendingLoanRequestMoL3Permission == "LOAN_APPROVAL_LEVEL_THREE_ADD"
                  )
          ){
            items.add(
              Hero(
                tag: 'loanAdvanceReport',
                child: Card(
                  color: Mythemes.whitish,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, MyRoutings.loanAdvanceRoute);
                      /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                    },
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.money,
                            size: 50,
                            color: Mythemes.lightBluishColor,
                          ),
                          /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 75, left: 10),
                            padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                                'Loan',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style:
                                TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );

          }

          //MSS
          if( userPanel == "MSS" &&
              (
                  pendingLoanRequestMSSL1Permission == "LOAN_APPROVAL_LEVEL_ONE_ADD" ||
                      pendingLoanRequestMSSL2Permission == "LOAN_APPROVAL_LEVEL_TWO_ADD" ||
                      pendingLoanRequestMSSL3Permission == "LOAN_APPROVAL_LEVEL_THREE_ADD"
              )
          ){
            items.add(
              Hero(
                tag: 'loanAdvanceReport',
                child: Card(
                  color: Mythemes.whitish,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, MyRoutings.loanAdvanceRoute);
                      /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                    },
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.money,
                            size: 50,
                            color: Mythemes.lightBluishColor,
                          ),
                          /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 75, left: 10),
                            padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                                'Loan',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style:
                                TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );

          }

          //USER
          if(
          userPanel == "USER" &&
              (
                  pendingLoanRequestMoL1Permission == "LOAN_APPROVAL_LEVEL_ONE_ADD" ||
                      pendingLoanRequestMoL2Permission == "LOAN_APPROVAL_LEVEL_TWO_ADD" ||
                      pendingLoanRequestMoL3Permission == "LOAN_APPROVAL_LEVEL_THREE_ADD"
              )
          ){
            items.add(
              Hero(
                tag: 'loanAdvanceReport',
                child: Card(
                  color: Mythemes.whitish,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, MyRoutings.loanAdvanceRoute);
                      /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                    },
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.money,
                            size: 50,
                            color: Mythemes.lightBluishColor,
                          ),
                          /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 75, left: 10),
                            padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                                'Loan',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style:
                                TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );

          }


        //Helpdesk
        if(orgId == 3 || orgId == 145) {
          items.add(
            Hero(
              tag: 'helpdeskItems',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, MyRoutings.helpDeskItemsRoute);
                    /*Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.support_agent_rounded,
                          size: 50,
                          color: Mythemes.warningColor,
                        ),
                        /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 75, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                              'Helpdesk',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }


        /*if(showRo  || showAdmin) {
        items.add(
          Hero(
            tag: 'tracking',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: (){

                  Navigator.pushNamed(context, MyRoutings.empListRoute);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.location_on,
                        size: 50,
                        color: Mythemes.lightBluishColor,
                      ),

                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Tracking',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }*/

        //OCR
        if(orgId == 3 || orgId == 145) {
          items.add(
            Hero(
              tag: 'ocr',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, MyRoutings.ocrPageRoute);
                    /*Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.document_scanner_outlined,
                          size: 50,
                          color: Mythemes.activeStepColor,
                        ),
                        /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 75, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                              'OCR',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        //Face Recognition
        if(orgId == 3 || orgId == 145) {
          items.add(
            Hero(
              tag: 'face_recognition',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, MyRoutings.faceRecognitionHome);
                    /*Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*/
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.face_retouching_natural,
                          size: 50,
                          color: Mythemes.successColor,
                        ),
                        /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 75, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                              'Face Recognition',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }


        //Visitor Management
        if(orgId == 3 || orgId == 145) {
          items.add(
            Hero(
              tag: 'visitorManage',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, MyRoutings.visitorManageSections);
                    /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.approval,
                          size: 50,
                          color: Mythemes.alertColor,
                        ),
                        /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 75, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                              'Visitor ',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        //New Landing
        if(orgId == 3 || orgId == 145) {
          items.add(
            Hero(
              tag: 'frontPage',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
                  onTap: () {
                    //Navigator.pushNamed(context, MyRoutings.visitorManageSections);
                    Navigator.pushNamed(context, MyRoutings.landingPageRoute);
                    /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.new_releases_sharp,
                          size: 50,
                          color: Mythemes.warningColor,
                        ),
                        /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 75, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                              'New',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        //Induction Onboarding
        if(orgId == 3 || orgId == 145) {
          items.add(
            Hero(
              tag: 'induction',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
                  onTap: () {
                    //Navigator.pushNamed(context, MyRoutings.visitorManageSections);
                    Navigator.pushNamed(context, MyRoutings.inductionOnboardRoute);
                    /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.add_moderator_outlined,
                          size: 50,
                          color: Mythemes.warningColor,
                        ),
                        /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 75, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                              'Induction',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        //Pre-Onboard
        if((
            setPreOnboardShow == "true" ||
                empIdNew == 75324 ||
                emailId == "sid@voyageofwellness.co.in" ||
                orgId == 3 ||
                orgId == 145
        ) && !(orgId == 190 || orgId == 191 || orgId == 198)) {
          items.add(
            Hero(
              tag: 'preInduction',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
                  onTap: () {
                    //Navigator.pushNamed(context, MyRoutings.visitorManageSections);
                    Navigator.pushNamed(context, MyRoutings.preOnboardItemRoute);
                    /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.manage_accounts_sharp,
                          size: 50,
                          color: Mythemes.warningColor,
                        ),
                        /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 75, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                              'Pre-Induction',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        //Exit
        if((
            setExitShow == "true" ||
                orgId == 3 ||
                orgId == 145
        ) && !(orgId == 190 || orgId == 191 || orgId == 198)) {
          items.add(
            Hero(
              tag: 'exit',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
                  onTap: () {
                    if(userPanel == "MSS" || userPanel == "USER") {
                      Navigator.pushNamed(context, MyRoutings.exitListRoute);
                    }
                    if(userPanel == "MSS_MO_ADMIN") {
                      Navigator.pushNamed(context, MyRoutings.exitListMORoute);
                    }
                    //Navigator.pushNamed(context, MyRoutings.visitorManageSections);

                    /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.auto_delete,
                          size: 50,
                          color: Mythemes.dangerColor,
                        ),
                        /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 75, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                              'Exit',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

          //Exit Resignation Approval
          if(setExitResignationListShow == "true" || setExitResignationListView == "1") {
            print("Check Permission - $setExitResignationListShow");
            print("Check - $setExitResignationListView");
            items.add(
              Hero(
                tag: 'exitResignationApproval',
                child: Card(
                  color: Mythemes.whitish,
                  child: InkWell(
                    onTap: () {
                      if(userPanel == "MSS" || userPanel == "USER") {
                        Navigator.pushNamed(context, MyRoutings.exitResignationRequestListRoute);
                      }
                      if(userPanel == "MSS_MO_ADMIN") {
                        Navigator.pushNamed(context, MyRoutings.exitResignationRequestListRoute);
                      }
                    },
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.outbond,
                            size: 50,
                            color: Mythemes.purplish,
                          ),
                          /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 75, left: 10),
                            padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                                'Resignation',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style:
                                TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

        //My Teams
        if(setMyTeamShow == "true" || setMyTeamPageShow == "1") {
          print("Check My Team Permission - $setMyTeamShow");
          print("Check My Team- $setMyTeamPageShow");
            items.add(
              Hero(
                tag: 'myTeams',
                child: Card(
                  color: Mythemes.whitish,
                  child: InkWell(
                    onTap: () {
                      if (userPanel == "MSS" || userPanel == "USER") {
                        Navigator.pushNamed(context, MyRoutings.empListRoute);
                      }
                      if (userPanel == "MSS_MO_ADMIN") {
                        Navigator.pushNamed(context, MyRoutings.myTeamMORoute);
                      }
                    },
                    child: Stack(
                      children: <Widget>[
                        // Main content
                        Center(
                          child: Icon(
                            Icons.supervised_user_circle_sharp,
                            size: 50,
                            color: Colors.purpleAccent,
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 75, left: 10),
                            padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                              'My Team',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Mythemes.black,
                                fontSize: boxText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ),
            );
          }

          /*if(userPanel == "MSS" || userPanel == "MSS_MO_ADMIN") {
            items.add(
              Hero(
                tag: 'mySharedTeams',
                child: Card(
                  color: Mythemes.whitish,
                  child: InkWell(
                    onTap: (){
                      if(userPanel == "MSS" || userPanel == "USER") {
                        Navigator.pushNamed(context, MyRoutings.empListRoute);
                      }
                      if(userPanel == "MSS_MO_ADMIN") {
                        Navigator.pushNamed(context, MyRoutings.myTeamMORoute);
                      }

                    },
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Image.network(
                            "https://s3.ap-south-1.amazonaws.com/employroll.com/images/1757493772177.png",
                            fit: BoxFit.contain,
                            width: 50,   // adjust as per your design
                            height: 50,  // adjust as per your design
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 75, left: 10),
                            padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                                'Shared Team',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style:
                                TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }*/



          if(orgId == 3 || orgId == 145) {
            items.add(
              Hero(
                tag: 'incidentReporting',
                child: Card(
                  color: Mythemes.whitish,
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, MyRoutings.incidentReportListRoute);
                    },
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.report_outlined,
                            size: 50,
                            color: Colors.red,
                          ),

                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 75, left: 10),
                            padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                                'Incident',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style:
                                TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          if(orgId == 3 || orgId == 145) {
            items.add(
              Hero(
                tag: 'offlineAttendance',
                child: Card(
                  color: Mythemes.whitish,
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, MyRoutings.offlineAttendanceRoute);
                    },
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.offline_share_sharp,
                            size: 50,
                            color: Colors.blueGrey,
                          ),

                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 75, left: 10),
                            padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                            child: Text(
                                'Sync My Attendance',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style:
                                TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }


        //Location
        if(orgId == 3 || orgId == 145) {
          items.add(
            Hero(
              tag: 'realLocation',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
                  onTap: () {
                    //Navigator.pushNamed(context, MyRoutings.visitorManageSections);
                    // Navigator.pushNamed(context, MyRoutings.realTimeLocationRoute);
                    //Navigator.pushNamed(context, MyRoutings.customCalender);
                    //Navigator.pushNamed(context, MyRoutings.locationTracking);
                    Navigator.pushNamed(context, MyRoutings.geoLocationTracking);
                    /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.pin_drop,
                          size: 50,
                          color: Mythemes.warningColor,
                        ),
                        /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 75, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                              'Location',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        //ESS Dashboard
        if(orgId == 3 || orgId == 145) {
          items.add(
            Hero(
              tag: 'essDashboard',
              child: Card(
                color: Mythemes.whitish,
                child: InkWell(
                  onTap: () {
                    //Navigator.pushNamed(context, MyRoutings.visitorManageSections);
                    Navigator.pushNamed(context, MyRoutings.realtimeESSDashboard);
                    /*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.dashboard,
                          size: 50,
                          color: Mythemes.warningColor,
                        ),
                        /*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*/
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 75, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                              'Real-Time',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }


      }


      /*if(orgId == 3 || orgId == 145) {
        items.add(
          Hero(
            tag: 'meal',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutings.mealScannerRoute);

                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.fastfood,
                        size: 50,
                        color: Mythemes.warningColor,
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                            'Meal',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }*/

     /* items.add(
        Hero(
          tag: 'location',
          child: Card(
            color: Mythemes.whitish,
            child: InkWell(
              onTap: (){
               *//* Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*//*
                Navigator.pushNamed(context, MyRoutings.getCurrentLocation);
              },
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.location_on,
                      size: 50,
                      color: Mythemes.greyish,
                    ),
                    *//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//*
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 75, left: 10),
                      padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                      child: Text(
                        'Location',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style:
                        TextStyle(color: Mythemes.black, fontSize: boxText, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );*/
      return items;
    }
    timeDilation = 0.5;
    return Material(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: userPanel == "MSS",
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedToggleSwitch<int>.size(
                        height: 30,
                        current: min(value, 2),
                        style: ToggleStyle(
                          backgroundColor: Mythemes.greyishade,
                          indicatorColor: Mythemes.lightBluishColor,
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                          indicatorBorderRadius: BorderRadius.zero,
                        ),
                        values: const [0, 1],
                        iconOpacity: 1.0,
                        selectedIconScale: 1.0,
                        indicatorSize: const Size.fromWidth(150),
                        iconAnimationType: AnimationType.onHover,
                        styleAnimationType: AnimationType.onHover,
                        spacing: 2.0,
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
                          final text = const ['ESS', 'MSS'][local.index];
                          return Center(
                              child: Text(text,
                                  style: TextStyle(
                                      color: Color.lerp(Colors.black, Colors.white,
                                          local.animationValue))));
                        },
                        borderWidth: 0.0,
                        onChanged: (i) {
                          setState(() {

                            value = i;
                            print(i);
                          });
                          if(value == 1) {
                            getRequisitionCounts(sessionId!);
                            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
                          }
                        },
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: userPanel == "MSS_MO_ADMIN",
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedToggleSwitch<int>.size(
                        height: 30,
                        current: min(value, 2),
                        style: ToggleStyle(
                          backgroundColor: Mythemes.greyishade,
                          indicatorColor: Mythemes.lightBluishColor,
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                          indicatorBorderRadius: BorderRadius.zero,
                        ),
                        values: const [0, 1],
                        iconOpacity: 1.0,
                        selectedIconScale: 1.0,
                        indicatorSize: const Size.fromWidth(150),
                        iconAnimationType: AnimationType.onHover,
                        styleAnimationType: AnimationType.onHover,
                        spacing: 2.0,
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
                          final text = const ['ESS', 'MSS MO'][local.index];
                          return Center(
                              child: Text(text,
                                  style: TextStyle(
                                      color: Color.lerp(Colors.black, Colors.white,
                                          local.animationValue))));
                        },
                        borderWidth: 0.0,
                        onChanged: (i) {
                          setState(() {
                            value = i;
                            print(i);

                          });
                          if(value == 1) {
                            getRequisitionCounts(sessionId!);
                            //Navigator.pushNamed(context, MyRoutings.mssMoNewDashboardRoute);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ).pLTRB(0, 8, 0, 8),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: generateGridViewItems(),
              ),
            ),
          ]
        ),
      ),
      //debugShowCheckedModeBanner: false,
    );
  }
}
