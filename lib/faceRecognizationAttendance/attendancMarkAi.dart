import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:camera/camera.dart';
import 'package:er_flutter_project/faceRecognizationAttendance/faceRecognizeEmployeeList.dart';
import 'package:flutter/services.dart';
import 'package:er_flutter_project/commanScreen/ProjectListPage.dart';
import 'package:er_flutter_project/commanScreen/punchInUploadPage.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/commanScreen/workDonePage.dart';
import 'package:er_flutter_project/singUP/model/loginModel.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/singUP/login_page.dart';
import 'package:er_flutter_project/widgets/drawer_file.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../adminPage/modelClass/dashboardModel.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/homePage.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../profiles/profilePageWithHead.dart';
import '../../../../sharedPrefancePage/ShardPre.dart';
import '../commanScreen/allAPIList.dart';
import '../commanScreen/commanNotificationPage.dart';
import 'FaceRecognitionHome.dart';
import 'ML/Recognition.dart';
import 'ML/Recognizer.dart';
import 'package:image/image.dart' as img;
import 'package:http_parser/http_parser.dart';

class MarkAttendanceAI extends StatefulWidget {
  final dynamic empId;
  const MarkAttendanceAI({super.key, required this.empId});
  @override
  State<MarkAttendanceAI> createState() =>
      _MarkAttendanceAIState(empId.toString());
}

dynamic empIdReceived;

class _MarkAttendanceAIState extends State<MarkAttendanceAI> {
  final dynamic empIdReceive;
  _MarkAttendanceAIState(this.empIdReceive);
  int pageIndex = 0;
  int currentIndex = 2;
  dynamic empIdSelfReceive;
  @override
  void initState() {
    getSharedPrfanceList();
    // TODO: implement initState
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    empRole = await shared.getEmpRoll();
    roRole = await shared.getRoRole();
    adminRole = await shared.getAdminRole();
    print('empRole $empRole');
    print('roRole $roRole');
    print('adminRole $adminRole');
    empIdReceived = empId;
    empIdSelfReceive = empIdSelf;
    print("EMP ID REC -$empId");
    setState(() {
      if (empRole == 1) {
        showHide = true;
        print('Show Emp $showHide');
        setState(() {});
      }
      if (empRole == 0) {
        showHide = false;
        print('Show Emp $showHide');
        setState(() {});
      }
      if (adminRole == 0) {
        showAdmin = false;
        print("Show Admin $showAdmin");
      }
      if (adminRole == 1) {
        showAdmin = true;
        print("Show Admin $showAdmin");
      }
      if (roRole == 0) {
        showRo = false;

        print("Show Ro $showRo");
      }
      if (roRole == 1) {
        showRo = true;
        print("Show Ro $showRo");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var titleName = "AI Attendance";

    return Scaffold(
      appBar: AppBar(title: titleName.text.make()),

      body: MarkAIAttendance(),

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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FaceRecognitinHome(),
              ),
            );
            print('Face');
          }
          if (index == 3) {
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
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
          BottomNavigationBarItem(icon: Icon(Icons.face_3), label: 'AI'),
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
}

class MarkAIAttendance extends StatefulWidget {
  const MarkAIAttendance({Key? key}) : super(key: key);

  @override
  State<MarkAIAttendance> createState() => _MarkAIAttendanceState();
}

String? clockingType = " ";
Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
int? empRole;
int? roRole;
int? adminRole;
bool showHide = false;
bool showAdmin = false;
bool showRo = false;
bool faceLoader = false;
double lat = 0;
double lng = 0;

class _MarkAIAttendanceState extends State<MarkAIAttendance> {
  String UserName = "Employee Name";
  File? _workDoneImage;
  //TODO declare variables
  late ImagePicker imagePicker;
  File? _image;
  int codeAuto = 1;

  //TODO declare detector
  late FaceDetector faceDetector;

  //TODO declare face recognizer
  late Recognizer recognizer;

  @override
  void initState() {
    // TODO: implement initState
    imagePicker = ImagePicker();

    //TODO initialize face detector
    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
    );
    faceDetector = FaceDetector(options: options);
    getSharedPrfanceList();
    //TODO initialize face recognizer
    recognizer = Recognizer();
    getUserName();
    timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    empRole = await shared.getEmpRoll();
    roRole = await shared.getRoRole();
    adminRole = await shared.getAdminRole();
    print('empRole $empRole');
    print('roRole $roRole');
    print('adminRole $adminRole');
    lat = await shared!.getLatitude();
    lng = await shared!.getLongitude();

    setState(() {
      if (empRole == 1) {
        showHide = true;
        print('Show Emp $showHide');
        setState(() {});
      }
      if (empRole == 0) {
        showHide = false;
        print('Show Emp $showHide');
        setState(() {});
      }
      if (adminRole == 0) {
        showAdmin = false;
        print("Show Admin $showAdmin");
      }
      if (adminRole == 1) {
        showAdmin = true;
        print("Show Admin $showAdmin");
      }
      if (roRole == 0) {
        showRo = false;

        print("Show Ro $showRo");
      }
      if (roRole == 1) {
        showRo = true;
        print("Show Ro $showRo");
      }
    });
  }

  Future getUserName() async {
    UserName = await shared!.getempName();
    print('Response snapshot: ${UserName}');
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (!mounted) return;
    setState(() {
      timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }

  //AI Attendance Code

  Future<void> captureWithFrontCamera(BuildContext context) async {
    final cameras = await availableCameras(); // Get available cameras
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    final controller = CameraController(frontCamera, ResolutionPreset.medium);
    await controller.initialize();

    final image = await controller.takePicture();
    print("Captured Image Path: ${image.path}");
  }

  //TODO capture image using camera
  _imgFromCameraRecognize() async {
    XFile? pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetectionRecognize();
      });
    }
  }

  var imageRecognize;
  //TODO face detection code here
  List<Face> facesRecognized = [];
  List<Recognition> recognitionList = [];

  doFaceDetectionRecognize() async {
    //TODO remove rotation of camera images
    InputImage inputImage = InputImage.fromFile(_image!);
    //image = await _image?.readAsBytes();
    imageRecognize = await decodeImageFromList(_image!.readAsBytesSync());
    print("Image - ${inputImage}");
    recognitionList.clear();
    //TODO passing input to face detector and getting detected faces
    facesRecognized = await faceDetector.processImage(inputImage);
    faceLoader = true;
    print("Face Count -  ${facesRecognized.length}");
    for (Face face in facesRecognized) {
      final Rect boundingBox = face.boundingBox;

      num left = boundingBox.left < 0 ? 0 : boundingBox.left;
      num right =
          boundingBox.right > imageRecognize.width
              ? imageRecognize.width - 1
              : boundingBox.right;
      num top = boundingBox.top < 0 ? 0 : boundingBox.top;
      num bottom =
          boundingBox.bottom > imageRecognize.height
              ? imageRecognize.height - 1
              : boundingBox.bottom;
      num width = right - left;
      num height = bottom - top;

      print("Ract Position :- " + boundingBox.toString());

      final bytes = _image!.readAsBytesSync();
      img.Image? faceImg = img.decodeImage(bytes!);
      img.Image croppedFace = img.copyCrop(
        faceImg!,
        x: left.toInt(),
        y: top.toInt(),
        width: width.toInt(),
        height: height.toInt(),
      );
      Recognition recognition = recognizer.recognize(croppedFace, boundingBox);
      recognitionList.add(recognition);
      print("Face List Leng - ${recognitionList.length}");
      print("Image - ${recognition.embeddings.toString()}");
      getFaceData(this.context, recognition.embeddings.toString(), _image!);
      if (recognition.distance > 0.6) {
        recognition.name = "Unknown Face $recognition.distance";
      }
      print("Face Matche Name " + recognition.name);

      /* var snackBar = SnackBar(content: Text(" Face Name " + recognition.name));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
      //showFaceRegistrationDialogue(Uint8List.fromList(img.encodeBmp(croppedFace)), recognition);
    }
    drawRectangleAroundFaces();

    //TODO call the method to perform face recognition on detected faces
  }

  var punchMsg = "";

  Future<void> getFaceData(
    BuildContext context,
    String coordinates,
    File image,
  ) async {
    String apiUrl;
    try {
      if (!await image.exists()) {
        throw Exception("File does not exist at path: ${image.path}");
      }

      String conn = ApiDetails.server;
      apiUrl =
          (value == 0)
              ? ApiDetails.faceRecognizeSelf
              : ApiDetails.faceRecognizeOther;
      print("ðŸ”¹ Selected API: $apiUrl");

      var urlapi = Uri.parse("$conn$apiUrl");
      CommonNotificationPage.showLoaderDialog(context);

      // Convert only 'coordinates' into JSON
      Map<String, Object> jsonData = {'coordinates': coordinates};

      var request = http.MultipartRequest("POST", urlapi);

      // Add other form fields
      request.fields['sessionId'] = sessionId!;
      request.fields['clockingType'] = clockingType!;
      request.fields['address'] = currentAddress;
      request.fields['lat'] = lat.toString();
      request.fields['lng'] = lng.toString();
      request.fields['json'] = json.encode(
        jsonData,
      ); // Send coordinates as JSON string

      // Attach Image File
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      // **Debugging Logs**
      print("ðŸ”¹ API URL: $urlapi");
      print("ðŸ”¹ Request Fields: ${request.fields}");
      print("ðŸ”¹ Coordinates JSON: $jsonData");
      print("ðŸ”¹ Image Path: ${image.path}");

      // Send Request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonResponse = await response.stream.bytesToString();
        print("âœ… JSON Upload successful: $jsonResponse");

        Map<String, dynamic> responseData = json.decode(jsonResponse);

        // Extract values from response
        String status = responseData['result']?.toLowerCase() ?? "error";
        String reason = responseData['reason'] ?? "Unknown error occurred!";
        String name = responseData['empName'] ?? "User !";

        // Define dialog properties based on result type
        String title = "Success";
        IconData icon = Icons.check_circle;
        Color iconColor = Colors.green;

        if (status == "failed") {
          title = "Error";
          icon = Icons.error;
          iconColor = Colors.red;
        } else if (status == "warning") {
          title = "Warning";
          icon = Icons.warning;
          iconColor = Colors.orange;
        }

        Navigator.of(context, rootNavigator: true).pop(); // Close Loader

        // Show Success/Error/Warning Dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(icon, color: iconColor),
                  SizedBox(width: 8),
                  Text(title),
                ],
              ),
              content: SingleChildScrollView(
                child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('$reason'),
                        /*Container(
              child: "Location".text.align(TextAlign.left).color(Mythemes.greyish).make().py12() ,
            ),*/
                        Container(
                          child: Text(
                            "Location",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Mythemes.greyish),
                          ),
                        ).py12(),
                        Text(
                          currentAddress,
                          style: TextStyle(letterSpacing: 0.5),
                        ),
                        Container(
                          child: Text(
                            "Name",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Mythemes.greyish),
                          ),
                        ).py12(),
                        Text(name, style: TextStyle(letterSpacing: 0.5)),
                        /* currentAddress.text.letterSpacing(0.5).make(),*/
                      ],
                    ).px8(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        print(
          "âŒ JSON Upload Error: ${response.statusCode}, ${await response.stream.bytesToString()}",
        );
      }
    } catch (e) {
      print("âŒ Error uploading file: $e");
    }
  }

  /* Future<void> getFaceData(BuildContext context, String coordinates, File image) async {
    String apiUrl;
    try {
      if (!await image.exists()) {
        throw Exception("File does not exist at path: ${image.path}");
      }

      String conn = ApiDetails.server;
      if(value == 0) {
        apiUrl = ApiDetails.faceRecognizeSelf;
        print("${ApiDetails.faceRecognizeSelf}");
      } else {
        apiUrl = ApiDetails.faceRecognizeOther;
        print("${ApiDetails.faceRecognizeOther}");
      }

      var urlapi = Uri.parse("$conn$apiUrl");
      CommonNotificationPage.showLoaderDialog(context);
      // Convert only 'coordinates' into JSON
      Map<String,Object> jsonData={'coordinates': coordinates};

      var request = http.MultipartRequest("POST", urlapi);

      // Add other form fields
      request.fields['sessionId'] = sessionId!;
      request.fields['clockingType'] = clockingType!;
      request.fields['address'] = currentAddress;
      request.fields['lat'] = lat.toString();
      request.fields['lng'] = lng.toString();
      // Attach JSON data as a field
      request.fields['json'] = json.encode(jsonData);
      // Attach Image File
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType('image', 'jpeg'), // Adjust format accordingly
      ));

      // **Debugging Logs**
      print("ðŸ”¹ API URL: $urlapi");
      print("ðŸ”¹ Request Fields: ${request.fields}");
      print("ðŸ”¹ Coordinates JSON: $jsonData");
      print("ðŸ”¹ Image Path: ${image.path}");

      // Send Request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("âœ… JSON Upload successful: ${await response.stream.bytesToString()}");
      } else {
        print("âŒ JSON Upload Error: ${response.statusCode}, ${await response.stream.bytesToString()}");
      }

      // Now send the Multipart request
      //http.Response multipartResponse = await http.Response.fromStream(await request.send());
      http.StreamedResponse multipartResponse = await request.send();
      if (multipartResponse.statusCode == 200) {
        var responseResult = multipartResponse.stream.bytesToString();
        Navigator.of(context, rootNavigator: true).pop();
        print('Response: $responseResult');

        String status = "";
        String reason = "";

        // Define dialog properties based on result type
        String title = "Success";
        IconData icon = Icons.check_circle;
        Color iconColor = Colors.green;
        //registerMsg = "Registered Successfully !";

        if (status == "error") {
          title = "Error";
          icon = Icons.error;
          iconColor = Colors.red;
          //registerMsg = "No punch received !";
        } else if (status == "warning") {
          title = "Warning";
          icon = Icons.warning;
          iconColor = Colors.orange;
          //registerMsg = "No punch received !";
        }

        // Show Success/Error/Warning Dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(icon, color: iconColor),
                  SizedBox(width: 8),
                  Text(title),
                ],
              ),
              content: Text("${reason}"),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context, rootNavigator: true).pop();
                    });
                  } ,
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }

    */ /*  if (multipartResponse.statusCode == 200) {
        print("âœ… Multipart Upload successful: ${await multipartResponse.stream.bytesToString()}");
      } else {
        print("âŒ Multipart Upload Error: ${multipartResponse.statusCode}, ${await multipartResponse.stream.bytesToString()}");
      }*/ /*
    } catch (e) {
      print("âŒ Error uploading file: $e");
    }
  }*/

  /* getFaceData(BuildContext context,String image) async{
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.faceRecognize;

    Map data = {
      'image': "$image",
    };
    var body = json.encode(data);
    //var uri = Uri.parse("$conn$apiUrl");
    var urlapi = Uri.parse("$conn$apiUrl?");
    var request = new http.MultipartRequest("Post", urlapi);
    var response = await MobileHttpClient.instance.post(urlapi,headers: {"Content-Type": "application/json"},body: body);


    print("Face Loader -  $faceLoader");
    print('URL ${response.request}');
    print('BODY - ${response.body}');
    print("Image - $body");

    if (response.statusCode == 200) {
      faceLoader = false;
      var responseResult = json.decode(response.body);
      print('Response: $responseResult');

      String result = responseResult['result'].toLowerCase() ?? "Result not defined";
      String reason = responseResult['reason'] ?? "Reason not defined";
      String name = responseResult['name'] ?? "User";

      // Define dialog properties based on result type
      String title = "Success";
      IconData icon = Icons.check_circle;
      Color iconColor = Colors.green;
      punchMsg = "Punched Successfully !";

      if (result == "error") {
        title = "Error";
        icon = Icons.error;
        iconColor = Colors.red;
        punchMsg = "No punch received !";
      } else if (result == "warning") {
        title = "Warning";
        icon = Icons.warning;
        iconColor = Colors.orange;
        punchMsg = "No punch received !";
      }

      // Show Success/Error/Warning Dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(icon, color: iconColor),
                SizedBox(width: 8),
                Text(title),
              ],
            ),
            content: Text("${reason} ${name} ${punchMsg}"),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    imageRecognize = null;
                    Navigator.of(context, rootNavigator: true).pop();
                  });

                } ,
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }*/

  var image;
  drawRectangleAroundFaces() async {
    //print("${image.width}   ${image.height}");
    print("${imageRecognize.width}   ${imageRecognize.height}");
    setState(() {
      image;
      imageRecognize;
      facesRecognized;
    });
  }

  int value = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: showRo || showAdmin,
          child:
              Row(
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
                        color: Colors.white38.withOpacity(opacity),
                      );
                    },
                    customIconBuilder: (context, local, global) {
                      final text = const ['Self', 'My Team'][local.index];
                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Color.lerp(
                              Colors.black,
                              Colors.white,
                              local.animationValue,
                            ),
                          ),
                        ),
                      );
                    },
                    borderWidth: 0.0,
                    onChanged: (i) {
                      setState(() {
                        value = i;
                        print(i);
                      });
                      if (value == 1) {
                        //Navigator.pushNamed(context, MyRoutings.roWorkDoneFilterRoute);
                      }
                      if (value == 0) {
                        //Navigator.pushNamed(context, MyRoutings.workDoneDateReportRoute);
                      }
                    },
                  ),
                ],
              ).py1(),
        ),
        Expanded(
          child: Container(
            child: Card(
              child: GoogleMap(
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(position!.latitude, position!.longitude),
                  zoom: 14,
                ),
                myLocationEnabled: true,
                mapToolbarEnabled: false,
                onMapCreated: (GoogleMapController controler) {
                  googleMapController = controler;
                },
              ),
            ),
          ),
        ),

        Container(height: 10, color: Colors.white70),
        /*Visibility(
          visible: faceLoader,
          child: Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // Adds a semi-transparent overlay
              child: Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                  color: Colors.lightBlue,
                  size: 100,
                ),
              ),
            ),
          ),
        ),*/
        SingleChildScrollView(
          child: Container(
            color: context.cardColor,
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    //title: Text({_loginModel.data?.userLoginned?.name}==null ?' ': " Name "),
                    //title: Text(UserName),
                    title: Text(currentAddress),
                    //subtitle: Text('$currentAddress'),
                    leading: Container(
                      child: CircleAvatar(
                        radius: 30,
                        //backgroundImage: Icon(Icons.pin_drop),
                        backgroundColor: Mythemes.whitish,
                        child: Icon(
                          Icons.pin_drop,
                          size: 40,
                          color: Mythemes.lightBluishColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(height: 20, width: 0, color: context.cardColor),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 3,
                      margin: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("Today Date"),
                          ),
                          Container(height: 12, color: Colors.white70),
                          Padding(padding: EdgeInsets.all(0)),
                          Container(
                            margin: EdgeInsets.all(10),
                            height: 25,
                            width: 125,
                            child: Text(
                              '$todayDateShow',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 3,
                      margin: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("Today Time"),
                          ),
                          Container(
                            height: 12,
                            color: Mythemes.whiteShadeSeventy,
                          ),
                          Padding(padding: EdgeInsets.all(0)),
                          Container(
                            margin: EdgeInsets.all(10),
                            height: 25,
                            width: 125,
                            child: Text(
                              '$timeString',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child:
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 0,
                              color: Colors.transparent,
                              margin: EdgeInsets.all(5),
                              child: InkWell(
                                onTap: () async {
                                  bool internetCheck =
                                      await InternetConnectionChecker()
                                          .hasConnection;
                                  if (internetCheck == false) {
                                    setState(() {
                                      AlertDialog(
                                        content:
                                            "Please check your internet connection"
                                                .text
                                                .make(),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Please check your Internet connection.",
                                          ),
                                        ),
                                      );
                                    });
                                  } else {
                                    clockingType = "In";
                                    _imgFromCameraRecognize();
                                    //getImageODIn();
                                  }

                                  /*    getUploadImage();
                              clockingType = "In";
                              print("click in");
                              _getId();
                              */ /*await AndroidMultipleIdentifier
                                              .requestPermission();*/ /*
                              punchInnew(sessionId);*/
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.tag_faces,
                                          size: 30,
                                          color: Mythemes.creamColor,
                                        ),
                                        backgroundColor: Mythemes.successColor,
                                        radius: 30,
                                      ),
                                    ),
                                    Container(height: 5),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      //margin: EdgeInsets.all(5),
                                      child: Text(
                                        "Punch In",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              elevation: 0,
                              color: Colors.transparent,
                              margin: EdgeInsets.all(5),
                              child: InkWell(
                                onTap: () async {
                                  bool internetCheck =
                                      await InternetConnectionChecker()
                                          .hasConnection;
                                  if (internetCheck == false) {
                                    setState(() {
                                      AlertDialog(
                                        content:
                                            "Please check your internet connection"
                                                .text
                                                .make(),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Please check your Internet connection.",
                                          ),
                                        ),
                                      );
                                    });
                                  } else {
                                    clockingType = "Out";
                                    _imgFromCameraRecognize();
                                    //getImageODOut();
                                  }
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.tag_faces,
                                          size: 30,
                                          color: Mythemes.creamColor,
                                        ),
                                        backgroundColor:
                                            Mythemes.dangerColorOne,
                                        radius: 30,
                                      ),
                                    ),
                                    Container(height: 5),
                                    Padding(padding: EdgeInsets.all(0)),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        "Punch Out",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ).p8(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
