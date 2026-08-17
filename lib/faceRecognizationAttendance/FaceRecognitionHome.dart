import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';
import '../commanScreen/allAPIList.dart';
import '../commanScreen/homePage.dart';
import '../commanScreen/punchInOutScreen.dart';
import '../commanScreen/routes.dart';
import '../profiles/profilePageWithHead.dart';
import '../sharedPrefancePage/ShardPre.dart';
import '../themes/empThemes.dart';
import 'ML/Recognition.dart';
import 'ML/Recognizer.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'attendancMarkAi.dart';
import 'empListFaceRegistered.dart';

class FaceRecognitinHome extends StatefulWidget {
  const FaceRecognitinHome({super.key});
  @override
  State<FaceRecognitinHome> createState() => _FaceRecognitinHomeState();
}

var titleName = "Face Recognition";
Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
dynamic empIdSelf;
int? empRole;
int? roRole;
int? adminRole;
bool showHide = false;
bool showAdmin = false;
bool showRo = false;

class _FaceRecognitinHomeState extends State<FaceRecognitinHome> {
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
    super.initState();
    imagePicker = ImagePicker();

    //TODO initialize face detector
    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
    );
    faceDetector = FaceDetector(options: options);
    getSharedPrfanceList();
    //TODO initialize face recognizer
    recognizer = Recognizer();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    empRole = await shared.getEmpRoll();
    roRole = await shared.getRoRole();
    adminRole = await shared.getAdminRole();
    empIdSelf = await shared.getEmpId();
    setState(() {
      if (empRole == 1) {
        showHide = true;
        setState(() {});
      }
      if (empRole == 0) {
        showHide = false;
        setState(() {});
      }
      if (adminRole == 0) {
        showAdmin = false;
      }
      if (adminRole == 1) {
        showAdmin = true;
      }
      if (roRole == 0) {
        showRo = false;

      }
      if (roRole == 1) {
        showRo = true;
      }
    });
  }

  //TODO capture image using camera
  _imgFromCameraRegister() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
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

  //TODO face detection code here
  List<Face> facesRecognized = [];
  List<Recognition> recognitionList = [];
  doFaceDetectionRecognize() async {
    //TODO remove rotation of camera images
    InputImage inputImage = InputImage.fromFile(_image!);
    //image = await _image?.readAsBytes();
    imageRecognize = await decodeImageFromList(_image!.readAsBytesSync());
    recognitionList.clear();
    //TODO passing input to face detector and getting detected faces
    facesRecognized = await faceDetector.processImage(inputImage);

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


      final bytes = _image!.readAsBytesSync();
      img.Image? faceImg = img.decodeImage(bytes);
      img.Image croppedFace = img.copyCrop(
        faceImg!,
        x: left.toInt(),
        y: top.toInt(),
        width: width.toInt(),
        height: height.toInt(),
      );
      Recognition recognition = recognizer.recognize(croppedFace, boundingBox);
      recognitionList.add(recognition);
      getFaceData(context, recognition.embeddings.toString());
      if (recognition.distance > 0.6) {
        recognition.name = "Unknown Face $recognition.distance";
      }

      /* var snackBar = SnackBar(content: Text(" Face Name " + recognition.name));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
      //showFaceRegistrationDialogue(Uint8List.fromList(img.encodeBmp(croppedFace)), recognition);
    }
    drawRectangleAroundFaces();

    //TODO call the method to perform face recognition on detected faces
  }

  var punchMsg = "";

  getFaceData(BuildContext context, String image) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.faceRecognizeOther;
    Map data = {'image': image};
    var body = json.encode(data);
    //var uri = Uri.parse("$conn$apiUrl");
    var urlapi = Uri.parse("$conn$apiUrl?");
    var request = http.MultipartRequest("Post", urlapi);
    var response = await MobileHttpClient.instance.post(
      urlapi,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      var responseResult = json.decode(response.body);

      String result =
          responseResult['result'].toLowerCase() ?? "Result not defined";
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
            content: Text("$reason $name $punchMsg"),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    imageRecognize = null;
                    Navigator.of(context, rootNavigator: true).pop();
                  });
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  //TODO face detection code here
  List<Face> faces = [];
  doFaceDetection() async {
    //TODO remove rotation of camera images
    InputImage inputImage = InputImage.fromFile(_image!);
    //image = await _image?.readAsBytes();
    image = await decodeImageFromList(_image!.readAsBytesSync());

    //TODO passing input to face detector and getting detected faces
    faces = await faceDetector.processImage(inputImage);

    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;

      num left = boundingBox.left < 0 ? 0 : boundingBox.left;
      num right =
          boundingBox.right > image.width ? image.width - 1 : boundingBox.right;
      num top = boundingBox.top < 0 ? 0 : boundingBox.top;
      num bottom =
          boundingBox.bottom > image.height
              ? image.height - 1
              : boundingBox.bottom;
      num width = right - left;
      num height = bottom - top;

      var snackBar = SnackBar(
        content: Text('Face Id :-$boundingBox'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
          final bytes = _image!.readAsBytesSync();
      img.Image? faceImg = img.decodeImage(bytes);
      img.Image croppedFace = img.copyCrop(
        faceImg!,
        x: left.toInt(),
        y: top.toInt(),
        width: width.toInt(),
        height: height.toInt(),
      );
      Recognition recognition = recognizer.recognize(croppedFace, boundingBox);
      showFaceRegistrationDialogue(
        Uint8List.fromList(img.encodeBmp(croppedFace)),
        recognition,
      );
    }
    drawRectangleAroundFaces();
    var snackBar = SnackBar(content: Text(" No Face Founded "));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    //TODO call the method to perform face recognition on detected faces
  }

  //TODO remove rotation of camera images
  removeRotation(File inputImage) async {
    final img.Image? capturedImage = img.decodeImage(
      await File(inputImage.path).readAsBytes(),
    );
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

  //TODO perform Face Recognition

  //TODO Face Registration Dialogue
  TextEditingController textEditingController = TextEditingController();
  showFaceRegistrationDialogue(Uint8List cropedFace, Recognition recognition) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Face Registration", textAlign: TextAlign.center),
            alignment: Alignment.center,
            content: SizedBox(
              height: 340,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Image.memory(cropedFace, width: 200, height: 200),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: textEditingController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Enter Name",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      recognizer.registerFaceInDB(
                        textEditingController.text,
                        recognition.embeddings,
                      );
                      uploadFaceRegister(
                        context,
                        recognition.embeddings.toString(),
                        textEditingController.text,
                        "0001",
                      );
                      textEditingController.text = "";
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Face Registered")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(200, 40),
                    ),
                    child: const Text("Register"),
                  ),
                ],
              ),
            ),
            contentPadding: EdgeInsets.zero,
          ),
    );
  }

  //TODO draw rectangles
  var image;
  var imageRecognize;
  drawRectangleAroundFaces() async {
    //print("${image.width}   ${image.height}");
    setState(() {
      image;
      imageRecognize;
      faces;
      facesRecognized;
    });
  }

  Future<void> uploadFaceRegister(
    BuildContext context,
    String image,
    String name,
    String code,
  ) async {
    codeAuto++;
    String conn = "http://www.employroll.com/";
    String apiUrl = "restful/service/face/recognize/data/save";
    Map data = {
      'image': image.toString(),
      'name': name,
      'code': codeAuto.toString(),
    };
    var body = json.encode(data);

    var urlapi = Uri.parse("$conn$apiUrl?");
    var request = http.MultipartRequest("Post", urlapi);
    var response = await MobileHttpClient.instance.post(
      urlapi,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 200) {
    }
    /* http.Response response = await http.Response.fromStream(await request.send());

    }*/
  }

  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    /*double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;*/

    // Get the screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // You can use these values to determine the size of your widget
    double widgetWidth = screenWidth * 0.03; // 80% of the screen width
    double widgetHeight = screenHeight * 0.5; // 50% of the screen height
    double boxText = widgetWidth;
    List<Widget> generateGridViewItems() {
      List<Widget> items = [];
      //Register Face
      if (showRo || showAdmin) {
        items.add(
          Hero(
            tag: 'registerFace',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                onTap: () async {
                  bool internetCheck =
                      await InternetConnectionChecker().hasConnection;
                  if (internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content:
                            "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please check your Internet connection.",
                          ),
                        ),
                      );
                    });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmpListFaceRegistered(),
                      ),
                    );
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.add_reaction,
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
                          'Register Face',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Mythemes.blackish,
                            fontSize: boxText,
                            fontWeight: FontWeight.bold,
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

      //Mark AI Attendance
      if (showHide || showAdmin) {
        items.add(
          Hero(
            tag: 'facialAttendance',
            child: Card(
              color: Mythemes.whitish,
              child: InkWell(
                /*onTap: () async{
                  bool internetCheck = await InternetConnectionChecker().hasConnection;
                  if(internetCheck == false) {
                    setState(() {
                      AlertDialog(
                        content: "Please check your internet connection".text.make(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet connection."),
                      ));
                    });

                  } else {
                    if(showHide || showAdmin){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> MarkAttendanceAI(empId: empIdSelf,)));
                    }  if(showRo  || showAdmin) {
                      Navigator.pushNamed(context, MyRoutings.empListFaceRecognize);
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>const EmpListFaceRecognize()));
                    }
                  }
                },*/
                onTap: () async {
                  bool internetCheck =
                      await InternetConnectionChecker().hasConnection;

                  if (!internetCheck) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please check your Internet connection."),
                      ),
                    );
                    return;
                  }

                  /*if (showHide || showAdmin) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MarkAttendanceAI(empId: empIdSelf)),
                    );
                  } else if (showRo || showAdmin) {
                    Navigator.pushReplacementNamed(context, MyRoutings.empListFaceRecognize);
                  }*/
                  if (showHide || showAdmin) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MarkAttendanceAI(empId: empIdSelf),
                      ),
                    ).then((_) {
                      // Ensure that when user comes back, it goes back to Navigation Page
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName('/faceRecognitionHome'),
                      );
                    });
                  }
                  if (showRo || showAdmin) {
                    Navigator.pushNamed(
                      context,
                      MyRoutings.empListFaceRecognize,
                    ).then((_) {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName('/faceRecognitionHome'),
                      );
                    });
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.face_retouching_natural_sharp,
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
                          'AI Attendance',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Mythemes.blackish,
                            fontSize: boxText,
                            fontWeight: FontWeight.bold,
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

      return items;
    }

    return Scaffold(
      appBar: AppBar(title: titleName.text.make()),
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
              MaterialPageRoute(
                builder: (context) => HomePage(selectedIndex: 0),
              ),
            );
            //Navigator.of(context, rootNavigator: true).pop();
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PunchInOUtActivity(selectedIndex: 1),
              ),
            );
            //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FaceRecognitinHome(),
              ),
            );
          }
          if (index == 3) {
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
          }
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePageNew()),
            );
            //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
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
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 3,
          children: generateGridViewItems(),
        ),
      ),
      /* body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          imageRecognize != null
              ?
          Container(

            margin: const EdgeInsets.only(
                top: 60, left: 30, right: 30, bottom: 0),
            child: FittedBox(
              child: SizedBox(
                width: imageRecognize.width.toDouble(),
                height: imageRecognize.width.toDouble(),
                child: CustomPaint(
                  painter: FacePainter(
                      facesList: recognitionList, imageFile: imageRecognize),
                ),
              ),
            ),
          )
              :
          Container(margin: const EdgeInsets.only(top: 100),child: Image.asset("assets/images/logo.png",width: screenWidth-40,height: screenWidth-40,)),

          Container(
            margin: const EdgeInsets.only(bottom: 50),
            child: Column(
              children: [
                Visibility(
                  visible: showRo  || showAdmin,
                  child: ElevatedButton(onPressed: (){
                     //_imgFromCameraRegister();
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>const RegistrationScreen()));
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const EmpListFaceRegistered()));
                  },
                    style: ElevatedButton.styleFrom(minimumSize: Size(screenWidth-30, 50)), child: const Text("Register Face"),),
                ),
                Container(height: 20,),

                Visibility(
                  visible: showHide || showAdmin,
                  child: ElevatedButton(onPressed: (){
                    _imgFromCameraRecognize();
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>const RecognitionScreen()));
                  },
                    style: ElevatedButton.styleFrom(minimumSize: Size(screenWidth-30, 50)), child: const Text("AI Attendance"),),
                ),
              ],
            ),
          ),

        ],
      ),*/
    );
  }
}

class FacePainter extends CustomPainter {
  List<Recognition> facesList;
  dynamic imageFile;
  FacePainter({required this.facesList, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 3;

    for (Recognition face in facesList) {
      canvas.drawRect(face.location, p);
      TextSpan textSpan = TextSpan(
        text: "${face.name} ${face.distance}",
        style: TextStyle(color: Colors.white, fontSize: 50),
      );
      TextPainter tp = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(face.location.left, face.location.top));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
