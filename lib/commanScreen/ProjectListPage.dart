import 'dart:convert';
import 'dart:developer';
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
dynamic empIdNew;
bool? setShowPayroll;
String? setPreOnboardShow;
String? setExitShow;
int? orgId;
String? orgName;
int? empRoles;
int? roRoles;
int? adminRoles;
bool showHide = false;
bool showAdmin = false;
bool showRo = false;

class _ProjectListState extends State<ProjectList> {
  int currentIndex = 0;
  final ImagePicker _picker = ImagePicker();
  File? image;





  Future<LoginModel> monthAttendance(String emailId, String password) async {
    LoginModel loginModel;
    var urlapi = Uri.parse(
        "http://www.employroll.com/restful/service/login?userName=$emailId&password=$password");
    /*  final response= await http.get(urlapi,headers: {
      "email": emailId,
      "password": password
    });*/
    final response = await http.get(urlapi);
    print('Response status: ${response.request}');
    print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');
    mapResponse = json.decode(response.body);
    log('Response body: ${mapResponse}');
    loginModel = LoginModel.fromJson(mapResponse);
    return loginModel;
    if (response.statusCode == 200) {
      setState(() {
        //stringResponse= response.body;
      });
    }
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

    sessionId = await shared!.getSessionId();
    userType = await shared!.getUserType();
    setState(() {

    });
    print("User Type - $userType");
    setShowPayroll = await shared!.getShowPayroll();
    orgId = await shared!.getOrgId();
    emailId = await shared!.getEmailId();
    empIdNew = await shared!.getEmpId();
    orgName = await shared!.getOrgName();
    empRoles= await shared.getEmpRoll();
    roRoles= await shared.getRoRole();
    adminRoles= await shared.getAdminRole();
    setPreOnboardShow= await shared.getPreOnboardShow();
    setExitShow= await shared.getExitShow();
    print('Pre-Onboard $setPreOnboardShow');
    print('Exit Show $setExitShow');
    print('empRole $empRoles');
    print('roRole $roRoles');
    print('adminRole $adminRoles');
    print('Response snapshot: ${sessionId}');
    print('Show Payroll: ${setShowPayroll}');
    print('OrgId -  ${orgId}');
    print('OrgName - : ${orgName}');
    setState(() {

    });
    setState(() {
      if(empRoles==1){
        showHide=true;
        print('Show Emp $showHide');
        setState(() {
        });
      }
      if(empRoles==0){
        showHide=false;
        print('Show Emp $showHide');
        setState(() {
        });
      }
      if (adminRoles == 0) {
        showAdmin = false;
        print("Show Admin $showAdmin");
      }
      if (adminRoles == 1) {
        showAdmin = true;
        print("Show Admin $showAdmin");
      }
      if (roRoles == 0) {
        showRo = false;

        print("Show Ro $showRo");
      }
      if (roRoles == 1) {
        showRo = true;
        print("Show Ro $showRo");
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
      print('no image selected');
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
    print('Response status: ${length}');
    print('Response body: ${stream}');
    print('Response body: ${image}');
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
    print('Response body: ${request}');
    print('Response body: ${response.toString()}');
    print('Response body: ${responseData.toString()}');
    print('Response body: ${response.statusCode}');
  }

  //============================== Image from gallery
  Future getGalleryImage() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
  }

  void _uploadFile(filePath) async {
    String filename = basename(filePath.path);
    print("File base name $filename");
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

      print('Response status: ${response.statusMessage}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response}');
    } catch (e) {
      print('Response statuserror: ${e.toString()}');
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
        print(value);
        print('Response status: ${response.stream}');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response}');
      });
    }).catchError((e) {
      print(e);
    });
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
      print("CheckOrg - $orgId");
      List<Widget> items = [];

      if(orgId != 144 && orgId != 138) {
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
                        Icons.access_time_filled,
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
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
                        TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      /*if(setShowPayroll == true) {
        items.add(
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, MyRoutings.documentsAddedRoute);

            },
            child: Hero(
              tag: 'e-doc',
              child: Card(
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.document_scanner_sharp,
                        size: 50,
                        color: Mythemes.warningColor,
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 75, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                          'E-Doc',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                          TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold),
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

      if(userType != 'COMPANY_ADMIN') {
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
                            'HRIS',
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
                      color: Mythemes.dangerColorOne,
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
                          TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      /*items.add(
        Hero(
          tag: 'workDoneReport',
          child: Card(
            color: Mythemes.whitish,
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, MyRoutings.roWorkDoneFilterRoute);

              },
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.work_history,
                      size: 50,
                      color: Mythemes.successColor,
                    ),

                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 75, left: 10),
                      padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                      child: Text(
                          'Work Done',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                          TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );*/

      if(orgId == 3 || orgId == 145 || orgId == 171 || orgId == 179 || orgId == 186) {
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
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
                          TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
      if(setPreOnboardShow == "true" || empIdNew == 75324 || emailId == "sid@voyageofwellness.co.in" || orgId == 3 || orgId == 145) {
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
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
      if(setExitShow == "true" || orgId == 3 || orgId == 145) {
        items.add(
          Hero(
            tag: 'exit',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  //Navigator.pushNamed(context, MyRoutings.visitorManageSections);
                  Navigator.pushNamed(context, MyRoutings.exitListRoute);
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
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
            tag: 'essDashboard',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () {
                  //Navigator.pushNamed(context, MyRoutings.visitorManageSections);
                  Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
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
                            'ESS Dash',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
                        TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
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
        body: GridView.count(
          crossAxisCount: 3,
          children: generateGridViewItems(),
          /*<Widget>[
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
                          Icons.access_time_filled,
                          size: 50,
                          color: Mythemes.greyish,
                        ),
                        *//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//*
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 80, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                            'Attendance',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                          color: Mythemes.greyish,
                        ),
                        *//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//*
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 80, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                            'Leave',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, MyRoutings.documentsAddedRoute);
                *//*Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );*//*
              },
              child: Hero(
                tag: 'e-doc',
                child: Card(
                  //color: Mythemes.whiteShadeSeventy,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.document_scanner_sharp,
                          size: 50,
                          color: Mythemes.greyish,
                        ),
                        *//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//*
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 80, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                            'E-Doc',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.greyish, fontSize: boxText),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Hero(
              tag: 'hrisReport',
              child: InkWell(
                onTap: () {
                  *//*Fluttertoast.showToast(
                      msg: "Not Activated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*//*
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
                          color: Mythemes.greyish,
                        ),
                        *//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//*
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 80, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                            'HRIS',
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Hero(
              tag: 'loanAdvanceReport',
              child: Card(
                color: Mythemes.whiteShadeSeventy,
                child: InkWell(
                  onTap: () {
                    //Navigator.pushNamed(context, MyRoutings.loanAdvanceRoute);
                    Fluttertoast.showToast(
                        msg: "Not Activated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.currency_exchange,
                          size: 50,
                          color: Mythemes.greyish,
                        ),
                        *//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//*
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 80, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                            'Loan',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Hero(
              tag: 'claim',
              child: Card(
                color: Mythemes.whiteShadeSeventy,
                child: InkWell(
                  onTap: () {
                    //Navigator.pushNamed(context, MyRoutings.claimItemsListRoute);
                    Fluttertoast.showToast(
                        msg: "Not Activated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.handshake_outlined,
                          size: 50,
                          color: Mythemes.greyish,
                        ),
                        *//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//*
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 80, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                            'Claim',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Hero(
              tag: 'odReport',
              child: Card(
                color: Mythemes.whiteShadeSeventy,
                child: InkWell(
                  onTap: (){
                    //Navigator.pushNamed(context, MyRoutings.onDutyTypes);
                    Fluttertoast.showToast(
                        msg: "Not Activated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.business_center,
                          size: 50,
                          color: Mythemes.greyish,
                        ),
                        *//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//*
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 80, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                            'OD',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Hero(
              tag: 'helpdeskItems',
              child: Card(
                color: Mythemes.whiteShadeSeventy,
                child: InkWell(
                  onTap: () {
                    //Navigator.pushNamed(context, MyRoutings.helpDeskItemsRoute);
                    Fluttertoast.showToast(
                        msg: "Not Activated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.support_agent_rounded,
                          size: 50,
                          color: Mythemes.greyish,
                        ),
                        *//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//*
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 80, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                            'Helpdesk',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Hero(
              tag: 'tracking',
              child: Card(
                color: Mythemes.whiteShadeSeventy,
                child: InkWell(
                  onTap: (){
                    Fluttertoast.showToast(
                        msg: "Not Activated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                    //Navigator.pushNamed(context, MyRoutings.empListRoute);
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
                          margin: EdgeInsets.only(top: 80, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                            'Tracking',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            *//*Hero(
              tag: 'qrItems',
              child: Card(
                //color: Mythemes.whiteShadeSeventy,
                child: InkWell(
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: "Not Activated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                    //Navigator.pushNamed(context, MyRoutings.qrItemsRoute);
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.qr_code_scanner,
                          size: 50,
                          color: Mythemes.greyish,
                        ),
                        *//**//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//**//*
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 80, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                            'QR',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),*//*
            *//*Hero(
              tag: 'roster',
              child: Card(
                color: Mythemes.whiteShadeSeventy,
                child: InkWell(
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: "Not Activated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                    //Navigator.pushNamed(context, MyRoutings.rosterCalendarRoute);
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.calendar_month,
                          size: 50,
                          color: Mythemes.greyish,
                        ),
                        *//**//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//**//*
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 80, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                            'Roster',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Hero(
              tag: 'induction',
              child: Card(
                color: Mythemes.whiteShadeSeventy,
                child: InkWell(
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: "Not Activated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                    //Navigator.pushNamed(context, MyRoutings.inductionOnboardRoute);
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.supervised_user_circle*//**//**//**//*,
                          size: 50,
                          color: Mythemes.greyish,
                        ),
                        *//**//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//**//*
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 80, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                            'Onboard',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                //Navigator.pushNamed(context, MyRoutings.ocrPageRoute);
                Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              },
              child: Hero(
                tag: 'ocr',
                child: Card(
                  color: Mythemes.whiteShadeSeventy,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.document_scanner,
                          size: 50,
                          color: Mythemes.greyish,
                        ),
                        *//**//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//**//*
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 80, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                            'OCR',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.greyish, fontSize: boxText),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Hero(
              tag: 'taskManage',
              child: Card(
                color: Mythemes.whiteShadeSeventy,
                child: InkWell(
                  onTap: (){
                   *//**//* Fluttertoast.showToast(
                        msg: "Not Activated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );*//**//*
                    Navigator.pushNamed(context, MyRoutings.projectManageItemsRoute);
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.task_alt,
                          size: 50,
                          color: Mythemes.greyish,
                        ),
                        *//**//*Image(
                          image: AssetImage('images/applications.png'),width: 100,height: 100,
                        ),*//**//*
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 80, left: 10),
                          padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                          child: Text(
                            'Project',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                            TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: () {
                Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              },
              child: Card(
                color: Mythemes.whiteShadeSeventy,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.bar_chart,
                        size: 50,
                        color: Mythemes.greyish,
                      ),
                      *//**//*Image(
                        image: AssetImage('images/applications.png'),width: 100,height: 100,
                      ),*//**//*
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 80, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                          'PMS',
                          style:
                              TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            InkWell(
              onTap: () {
                Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              },
              child: Card(
                color: Mythemes.whiteShadeSeventy,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.coronavirus,
                        size: 50,
                        color: Mythemes.greyish,
                      ),
                      *//**//*Image(
                        image: AssetImage('images/applications.png'),width: 100,height: 100,
                      ),*//**//*
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 80, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                          'Covid-19',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                          TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            InkWell(
              onTap: () {
                Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              },
              child: Card(
                color: Mythemes.whiteShadeSeventy,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.inventory_2,
                        size: 50,
                        color: Mythemes.greyish,
                      ),
                      *//**//*Image(
                        image: AssetImage('images/applications.png'),width: 100,height: 100,
                      ),*//**//*
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 80, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                          'Assets',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              },
              child: Card(
                color: Mythemes.whiteShadeSeventy,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.groups,
                        size: 50,
                        color: Mythemes.greyish,
                      ),
                      *//**//*Image(
                        image: AssetImage('images/applications.png'),width: 100,height: 100,
                      ),*//**//*
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 80, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                          'Company',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Fluttertoast.showToast(
                    msg: "Not Activated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              },
              child: Card(
                color: Mythemes.whiteShadeSeventy,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.settings,
                        size: 50,
                        color: Mythemes.greyish,
                      ),
                      *//**//*Image(
                        image: AssetImage('images/applications.png'),width: 100,height: 100,
                      ),*//**//*
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 80, left: 10),
                        padding: EdgeInsets.fromLTRB(2, 5, 10, 0),
                        child: Text(
                          'Settings',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              TextStyle(color: Mythemes.blackish, fontSize: boxText, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),*//*
          ],*/
        ),

        /*GridView.builder(
          itemCount: 10,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (ctx, index) {
              return Container (
                color: Colors.blue,
                margin: EdgeInsets.all(5),
                child: Center(
                  child: Text(index.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              );
            }),*/
        /*   GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          children: <Widget>[
            Container(
              color: Colors.white,
              margin: EdgeInsets.all(5),

            ),

            Container(
              color: Colors.blue,
              margin: EdgeInsets.all(5),
            ),
            Container(
              color: Colors.blue,
              margin: EdgeInsets.all(5),
            ),
            Container(
              color: Colors.blue,
              margin: EdgeInsets.all(5),
            ),
            Container(
              color: Colors.blue,
              margin: EdgeInsets.all(5),
            ),
            Container(
              color: Colors.blue,
              margin: EdgeInsets.all(5),
            ),
            Container(
              color: Colors.blue,
              margin: EdgeInsets.all(5),
            ),
            Container(
              color: Colors.blue,
              margin: EdgeInsets.all(5),
            ),
          ],
        ),*/


        //IndexedStack(
        //index:currentIndex,
        //children: screens,
        //),


      ),
      //debugShowCheckedModeBanner: false,
    );
  }
}
