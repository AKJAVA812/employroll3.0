import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../../commanScreen/allAPIList.dart';
import '../DB/DatabaseHelper.dart';
import '../FaceRecognitionHome.dart';
import 'Recognition.dart';
import 'package:http/http.dart' as http;

class Recognizer {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;
  //this is for mobile face net
  //static const int WIDTH = 112;
  //static const int HEIGHT = 112;
  static const int WIDTH = 160;
  static const int HEIGHT = 160;
  final dbHelper = DatabaseHelper();
  Map<String,Recognition> registered = Map();
  @override
  //String get modelName => 'assets/mobile_face_net.tflite';
  String get modelName => 'assets/facenet.tflite';

  Recognizer({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }
    loadModel();
    initDB();
  }

  initDB() async {
    await dbHelper.init();
    //loadRegisteredFaces();
  }
  void getServerMessage() {
  }

  void loadRegisteredFaces() async {
    final allRows = await dbHelper.queryAllRows();
   // debugPrint('query all rows:');
    for (final row in allRows) {
    //  debugPrint(row.toString());
      print(row[DatabaseHelper.columnName]);
      String name = row[DatabaseHelper.columnName];
      List<double> embd = row[DatabaseHelper.columnEmbedding].split(',').map((e) => double.parse(e)).toList().cast<double>();
      Recognition recognition = Recognition(row[DatabaseHelper.columnName],Rect.zero,embd,0);
      print("ImageData"+recognition.embeddings.toString());

      registered.putIfAbsent(name, () => recognition);


    }
    print("Total Faces- ${allRows.length}");
  }



  void registerFaceInDB(String name, List<double> embedding) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnEmbedding: embedding.join(",")
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  getFaceData() async{
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.faceRecognizeOther;
    Map data = {
      'image': "",
    };
    var body = json.encode(data);
    //var uri = Uri.parse("$conn$apiUrl");
    var urlapi = Uri.parse("$conn$apiUrl?");
    var request = new http.MultipartRequest("Post", urlapi);
    var response = await http.post(urlapi,headers: {"Content-Type": "application/json"},body: body);
    print('URL ${response.request}');
    print('BODY - ${response.body}');
    print("Image - $body");

    if (response.statusCode == 200) {
      var responseResult = json.decode(response.body);
      print('Response: $responseResult');

      String status = responseResult['status'].toLowerCase();
      String reason = responseResult['reason'];

      // Define dialog properties based on result type
      String title = "Success";
      IconData icon = Icons.check_circle;
      Color iconColor = Colors.green;

      if (status == "error") {
        title = "Error";
        icon = Icons.error;
        iconColor = Colors.red;
      } else if (status == "warning") {
        title = "Warning";
        icon = Icons.warning;
        iconColor = Colors.orange;
      }

      // Show Success/Error/Warning Dialog
      /*showDialog(
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
                  } ,
                  child: Text("OK"),
                ),
              ],
            );
          },
        );*/
    }
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(modelName);
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  List<dynamic> imageToArray(img.Image inputImage){
    img.Image resizedImage = img.copyResize(inputImage!, width: WIDTH, height: HEIGHT);
    List<double> flattenedList = resizedImage.data!.expand((channel) => [channel.r, channel.g, channel.b]).map((value) => value.toDouble()).toList();
    Float32List float32Array = Float32List.fromList(flattenedList);
    int channels = 3;
    int height = 160;
    int width = 160;
    Float32List reshapedArray = Float32List(1 * height * width * channels);
    for (int c = 0; c < channels; c++) {
      for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
          int index = c * height * width + h * width + w;
          reshapedArray[index] = (float32Array[c * height * width + h * width + w]-127.5)/127.5;
        }
      }
    }
    //return reshapedArray.reshape([1,112,112,3]);
    return reshapedArray.reshape([1,160,160,3]);
  }

  Recognition recognize(img.Image image,Rect location) {

    //TODO crop face from image resize it and convert it to float array
    var input = imageToArray(image);
    print(input.shape.toString());

    //TODO output array
    //List output = List.filled(1*192, 0).reshape([1,192]);
    List output = List.filled(1*512, 0).reshape([1,512]);

    //TODO performs inference
    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(input, output);
    final run = DateTime.now().millisecondsSinceEpoch - runs;
    print('Time to run inference: $run ms$output');

    //TODO convert dynamic list to double list
     List<double> outputArray = output.first.cast<double>();

     //TODO looks for the nearest embeeding in the database and returns the pair
     Pair pair = findNearest(outputArray);
     print("distance= ${pair.distance}");

     return Recognition(pair.name,location,outputArray,pair.distance);
  }

  //TODO  looks for the nearest embeeding in the database and returns the pair which contain information of registered face with which face is most similar
  findNearest(List<double> emb){
    Pair pair = Pair("Unknown", -5);
    for (MapEntry<String, Recognition> item in registered.entries) {
      final String name = item.key;
      List<double> knownEmb = item.value.embeddings;
      double distance = 0;
      for (int i = 0; i < emb.length; i++) {
        double diff = emb[i] -
            knownEmb[i];
        distance += diff*diff;
      }
      distance = sqrt(distance);
      if (pair.distance == -5 || distance < pair.distance) {
        pair.distance = distance;
        pair.name = name;
      }
    }
    return pair;
  }

  void close() {
    interpreter.close();
  }

}
class Pair{
   String name;
   double distance;
   Pair(this.name,this.distance);
}


