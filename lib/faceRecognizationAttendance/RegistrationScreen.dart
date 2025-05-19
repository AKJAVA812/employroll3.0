import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:er_flutter_project/faceRecognizationAttendance/ML/Recognition.dart';
import 'package:er_flutter_project/faceRecognizationAttendance/ML/Recognizer.dart';
import 'package:er_flutter_project/faceRecognizationAttendance/empListFaceRegistered.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import 'package:http_parser/http_parser.dart';
import '../commanScreen/allAPIList.dart';
import '../commanScreen/commanNotificationPage.dart';
import '../commanScreen/homePage.dart';
import '../commanScreen/punchInOutScreen.dart';
import '../commanScreen/routes.dart';
import '../profiles/profilePageWithHead.dart';
import '../sharedPrefancePage/ShardPre.dart';
import 'FaceRecognitionHome.dart';

class RegistrationScreen extends StatefulWidget {
  //const RegistrationScreen({Key? key}) : super(key: key);

  final String empId;
  const RegistrationScreen(
      {Key? key, required this.empId})
      : super(key: key);
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState(empId);
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
int? empRole;
int? roRole;
int? adminRole;
bool showHide = false;
bool showAdmin = false;
bool showRo = false;
dynamic empIdReceived;
class _RegistrationScreenState extends State<RegistrationScreen> {
  final String  empIdReceive;

  _RegistrationScreenState(this.empIdReceive);
  //TODO declare variables
  late ImagePicker imagePicker;
  File? _image;
  int codeAuto =1;

  //TODO declare detector
  late FaceDetector faceDetector;

  //TODO declare face recognizer
  late Recognizer recognizer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPrfanceList();
    imagePicker = ImagePicker();

    //TODO initialize face detector
    final options = FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate);
    faceDetector = FaceDetector(options: options);

    //TODO initialize face recognizer
    recognizer = Recognizer();

  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    empRole= await shared.getEmpRoll();
    roRole= await shared.getRoRole();
    adminRole= await shared.getAdminRole();
    print('empRole $empRole');
    print('roRole $roRole');
    print('adminRole $adminRole');
    empIdReceived = empId;
    print("EMP ID REC -$empId");
    setState(() {
      if(empRole==1){
        showHide=true;
        print('Show Emp $showHide');
        setState(() {
        });
      }
      if(empRole==0){
        showHide=false;
        print('Show Emp $showHide');
        setState(() {
        });
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

  //TODO capture image using camera
  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState((){
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  //TODO choose image using gallery
  _imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState((){
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  //TODO face detection code here
  List<Face> faces = [];
  doFaceDetection() async {
    //TODO remove rotation of camera images
    InputImage inputImage = InputImage.fromFile(_image!);
    //image = await _image?.readAsBytes();
    image = await decodeImageFromList(_image!.readAsBytesSync());

    print("Image Path - $_image");
    //TODO passing input to face detector and getting detected faces
    faces = await faceDetector.processImage(inputImage);

    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;

      num left = boundingBox.left<0?0:boundingBox.left;
      num right = boundingBox.right>image.width?image.width-1:boundingBox.right;
      num top = boundingBox.top<0?0:boundingBox.top;
      num bottom = boundingBox.bottom>image.height?image.height-1:boundingBox.bottom;
      num width = right-left;
      num height = bottom - top;

      print("Ract Position :- " +boundingBox.toString());
      /*if(boundingBox!=null){
        var snackBar = SnackBar(content: Text('Face Id :-'+boundingBox.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }*/
      final bytes= _image!.readAsBytesSync();
      img.Image? faceImg = img.decodeImage(bytes!);
      img.Image croppedFace = img.copyCrop(faceImg!, x: left.toInt(), y: top.toInt(), width: width.toInt(), height: height.toInt());
      Recognition recognition=  recognizer.recognize(croppedFace, boundingBox);
      recognizer.registerFaceInDB(textEditingController.text, recognition.embeddings);
      uploadFaceRegisters(context, recognition.embeddings.toString(), _image!);
      //showFaceRegistrationDialogue(Uint8List.fromList(img.encodeBmp(croppedFace)), recognition);
    }
    drawRectangleAroundFaces();
   /* var snackBar = SnackBar(content: Text(" No Face Founded "));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);*/

    //TODO call the method to perform face recognition on detected faces
  }

  //TODO remove rotation of camera images
  removeRotation(File inputImage) async {
    final img.Image? capturedImage = img.decodeImage(await File(inputImage!.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

  //TODO perform Face Recognition

  //TODO Face Registration Dialogue
  TextEditingController textEditingController = TextEditingController();
  showFaceRegistrationDialogue(Uint8List cropedFace, Recognition recognition){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Face Registration",textAlign: TextAlign.center),alignment: Alignment.center,
        content: SizedBox(
          height: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              Image.memory(
                cropedFace,
                width: 200,
                height: 200,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: textEditingController,
                    decoration: const InputDecoration( fillColor: Colors.white, filled: true,hintText: "Enter Name")
                ),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                  onPressed: () {
                    recognizer.registerFaceInDB(textEditingController.text, recognition.embeddings);
                    //uploadFaceRegister(context, recognition.embeddings.toString(), _image!);
                    textEditingController.text = "";
                    Navigator.of(context, rootNavigator: true).pop();
                    /*ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Face Registered"),
                    ));*/
                  },style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,minimumSize: const Size(200,40)),
                  child: const Text("Register"))
            ],
          ),
        ),contentPadding: EdgeInsets.zero,
      ),
    );
  }
  //TODO draw rectangles
  var image;
  var registerMsg = "";
  drawRectangleAroundFaces() async {

    print("${image.width}   ${image.height}");
    setState(() {
      image;
      faces;
    });
  }
  /*Future<void> uploadFaceRegister(BuildContext context,String coordinates, String image) async {
    print("Image Check - $_image");
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.faceRegistered;
   *//* Map data = {
      'sessionId': sessionId,
      'empId': empIdReceived,
      'coordinates': coordinates.toString(),
      'image': image.toString(),
    };*//*
    CommonNotificationPage.showLoaderDialog(context);
    *//*var urlapi = Uri.parse("$conn$apiUrl");
    var request = new http.MultipartRequest("Post", urlapi);
    request.fields['sessionId'] = sessionId!;
    request.fields['empId'] = empIdReceived!.toString();
    request.fields['coordinates'] =  coordinates.toString();
    request.files.add(await http.MultipartFile.fromPath('image', image));*//*

    var urlapi = Uri.parse("$conn$apiUrl");
    var request = http.MultipartRequest("POST", urlapi);

// Add multipart form data
    request.fields['sessionId'] = sessionId!;
    request.fields['empId'] = empIdReceived!.toString();

// Add image file
    request.files.add(await http.MultipartFile.fromPath('image', image));

// Send 'coordinates' as JSON in the body
    var coordinatesJson = jsonEncode({"coordinates": coordinates});
    request.files.add(http.MultipartFile.fromString(
      'json',
      coordinatesJson,
      contentType: MediaType('application', 'json'),
    ));

    print("Sending request: ${request.fields}");
    print("Coordinates JSON: $coordinatesJson");

    http.Response response = await http.Response.fromStream(await request.send());
    // Construct API URL with parameters
    String apiWithParams = urlapi.toString() + '?' + request.fields.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');


// Print the full API URL with parameters
    print('API URL with Parameters: $apiWithParams');
    //http.Response response = await http.Response.fromStream(await request.send());
    *//*var body = json.encode(data);
    //var uri = Uri.parse("$conn$apiUrl");
    var urlapi = Uri.parse("$conn$apiUrl?");
    var request = new http.MultipartRequest("Post", urlapi);*//*
    //var response = await http.post(urlapi,headers: {"Content-Type": "application/json"},body: body);
// Print the full API URL with parameters
    print('API URL with Parameters: $apiWithParams');
    if (response.statusCode == 200) {
      var responseResult = json.decode(response.body);
      Navigator.of(context, rootNavigator: true).pop();
      print('Response: $responseResult');

      String status = responseResult['status'].toLowerCase();
      String reason = responseResult['reason'];

      // Define dialog properties based on result type
      String title = "Success";
      IconData icon = Icons.check_circle;
      Color iconColor = Colors.green;
      registerMsg = "Registered Successfully !";

      if (status == "error") {
        title = "Error";
        icon = Icons.error;
        iconColor = Colors.red;
        registerMsg = "No punch received !";
      } else if (status == "warning") {
        title = "Warning";
        icon = Icons.warning;
        iconColor = Colors.orange;
        registerMsg = "No punch received !";
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
   *//* http.Response response = await http.Response.fromStream(await request.send());

    }*//*
  }*/

  Future<void> uploadFaceRegister(BuildContext context, String coordinates, File image) async {
    try {
      if (!await image.exists()) {
        throw Exception("File does not exist at path: ${image.path}");
      }

      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.faceRegistered;
      var urlapi = Uri.parse("$conn$apiUrl");
      CommonNotificationPage.showLoaderDialog(context);
      // Convert only 'coordinates' into JSON
      Map<String,Object> jsonData={'coordinates': coordinates};

      var request = http.MultipartRequest("POST", urlapi);

      // Add other form fields
      request.fields['sessionId'] = sessionId!;
      request.fields['empId'] = empIdReceived!.toString();
      // Attach JSON data as a field
      request.fields['json'] = json.encode(jsonData);
      // Attach Image File
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType('image', 'jpeg'), // Adjust format accordingly
      ));

      // **Debugging Logs**
      print("🔹 API URL: $urlapi");
      print("🔹 Request Fields: ${request.fields}");
      print("🔹 Coordinates JSON: $jsonData");
      print("🔹 Image Path: ${image.path}");

      // Send Request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("✅ JSON Upload successful: ${await response.stream.bytesToString()}");
      } else {
        print("❌ JSON Upload Error: ${response.statusCode}, ${await response.stream.bytesToString()}");
      }

      // Now send the Multipart request
      http.StreamedResponse multipartResponse = await request.send();

      if (multipartResponse.statusCode == 200) {
        print("✅ Multipart Upload successful: ${await multipartResponse.stream.bytesToString()}");
      } else {
        print("❌ Multipart Upload Error: ${multipartResponse.statusCode}, ${await multipartResponse.stream.bytesToString()}");
      }
    } catch (e) {
      print("❌ Error uploading file: $e");
    }
  }

  Future<void> uploadFaceRegisters(BuildContext context, String coordinates, File image) async {
    try {
      if (!await image.exists()) {
        throw Exception("File does not exist at path: ${image.path}");
      }

      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.faceRegistered;
      var urlapi = Uri.parse("$conn$apiUrl");
      CommonNotificationPage.showLoaderDialog(context);

      // Convert only 'coordinates' into JSON
      Map<String, Object> jsonData = {'coordinates': coordinates};

      var request = http.MultipartRequest("POST", urlapi);

      // Add other form fields
      request.fields['sessionId'] = sessionId!;
      request.fields['empId'] = empIdReceived!.toString();
      request.fields['json'] = json.encode(jsonData); // Send coordinates as JSON string

      // Attach Image File
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      ));

      // **Debugging Logs**
      print("🔹 API URL: $urlapi");
      print("🔹 Request Fields: ${request.fields}");
      print("🔹 Coordinates JSON: $jsonData");
      print("🔹 Image Path: ${image.path}");

      // Send Request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonResponse = await response.stream.bytesToString();
        print("✅ JSON Upload successful: $jsonResponse");

        Map<String, dynamic> responseData = json.decode(jsonResponse);

        // Extract values from response
        String status = responseData['result']?.toLowerCase() ?? "error";
        String reason = responseData['reason'] ?? "Unknown error occurred!";

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
              content: Text(reason),
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
        print("❌ JSON Upload Error: ${response.statusCode}, ${await response.stream.bytesToString()}");
      }
    } catch (e) {
      print("❌ Error uploading file: $e");
    }
  }

  /*Future<void> uploadFaceRegister(BuildContext context, String coordinates, File image) async {
    try {
      if (!await image.exists()) {
        throw Exception("File does not exist at path: ${image.path}");
      }

      String conn = ApiDetails.server;
      String apiUrl = ApiDetails.faceRegistered;
      var urlapi = Uri.parse("$conn$apiUrl");
      CommonNotificationPage.showLoaderDialog(context);
      var request = http.MultipartRequest("POST", urlapi);
      request.fields['sessionId'] = sessionId!;
      request.fields['empId'] = empIdReceived!.toString();

      // Send JSON formatted coordinates
      var coordinatesJson = '{"coordinates": "$coordinates"}';
      request.files.add(http.MultipartFile.fromString(
        'json',
        coordinatesJson,
        contentType: MediaType('application', 'json'),
      ));
      //request.fields['json'] = json.encode(coordinatesJson);
      // Correct way to add a file
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType('image', 'jpeg'), // Adjust based on your image type
      ));

      print("Sending request: ${request.fields}");
      print("Coordinates JSON: $coordinatesJson");

      // Send the request
      http.StreamedResponse response = await request.send();

      print("🔹 API URL: $urlapi");
      print("🔹 Request Fields: ${request.fields}");
      print("🔹 JSON Data Sent: $coordinatesJson");
      print("🔹 Image Path: ${image.path}");

      if (response.statusCode == 200) {
        print("Upload successful: ${await response.stream.bytesToString()}");
      } else {
        print("Error: ${response.statusCode}, ${await response.stream.bytesToString()}");
      }
    } catch (e) {
      print("Error uploading file: $e");
    }
  }*/
  int currentIndex = 2;
  var titleName = "Face Registration";
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int i=0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: titleName.text.make(),
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const FaceRecognitinHome()));
            print('Face');
          }
          if(index==3){
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
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
            icon: Icon(Icons.face_3),
            label: 'AI',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          image != null
              ?
         // Container(
                  //margin: const EdgeInsets.only(top: 100),
                  //width: screenWidth - 50,
                  //height: screenWidth - 50,
                  //child: Image.file(_image!),
              //  )
               Container(
                 margin: const EdgeInsets.only(
                     top: 60, left: 30, right: 30, bottom: 0),
                 child: FittedBox(
                   child: SizedBox(
                     width: image.width.toDouble(),
                     height: image.width.toDouble(),
                     child: CustomPaint(
                       painter: FacePainter(
                           facesList: faces, imageFile: image),
                     ),
                   ),
                 ),
               )
              : Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: screenWidth - 100,
                    height: screenWidth - 100,
                  ),
                ),

          Container(
            height: 50,
          ),

          //TODO section which displays buttons for choosing and capturing images
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               /* Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(200))),
                  child: InkWell(
                    onTap: () {
                      _imgFromGallery();
                    },
                    child: SizedBox(
                      width: screenWidth / 2 - 70,
                      height: screenWidth / 2 - 70,
                      child: Icon(Icons.image,
                          color: Colors.blue, size: screenWidth / 7),
                    ),
                  ),
                ),*/
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(200))),
                  child: InkWell(
                    onTap: () {
                      _imgFromCamera();
                    },
                    child: SizedBox(
                      width: screenWidth / 2 - 70,
                      height: screenWidth / 2 - 70,
                      child: Icon(Icons.camera,
                          color: Colors.blue, size: screenWidth / 7),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  List<Face> facesList;
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

    for (Face face in facesList) {
      canvas.drawRect(face.boundingBox, p);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}
