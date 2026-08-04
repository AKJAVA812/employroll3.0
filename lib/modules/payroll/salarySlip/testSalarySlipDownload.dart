/*
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/themes/empThemes.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import '../../../commanScreen/allAPIList.dart';
import '../../../sharedPrefancePage/ShardPre.dart';
import '../modalClass/salarySlipDownloadModal.dart';
import 'package:flutter_month_picker/flutter_month_picker.dart';
import 'package:download/download.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class TestSalarySlipDownload extends StatefulWidget {
  const TestSalarySlipDownload({Key? key}) : super(key: key);

  @override
  State<TestSalarySlipDownload> createState() => _TestSalarySlipDownloadState();
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
int? empId;
var salarySlip;
SalarySlipDownloadModal? salarySlipDownloadModalGlobal;

class _TestSalarySlipDownloadState extends State<TestSalarySlipDownload> {

  Dio dio = Dio();
  var progress = 0;
  var timeString = "0.0";

  @override
  void initState() {
    super.initState();

   timeString = _formatDateTime(DateTime.now());
   // Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    Future.delayed(Duration.zero, () {
      dateSelection();
      salarySlip = "";
      //FileDownload().registerPortData(setState);
    });
    //startDownloading();
  }


  ReceivePort receivePort = ReceivePort();
  dateSelection() async {
    DateTime? date = DateTime.now();
    FocusScope.of(context).requestFocus(new FocusNode());

    date = await showMonthPicker(
        context: context,
        initialDate: date,
        firstDate:DateTime(1947),
        lastDate: DateTime.now().add(Duration(days: 0)));
    setState(() {
     // singleDateString = DateFormat('dd-MM-yyyy').format(date!);
      _dateController.text = DateFormat("MMMM-yy").format(date!);
      selectedDate = _dateController.text;

      print('MonthPicker $selectedDate');
      getSharedPrfanceList();



      //  DateFormat.yMd().format(date!).toString();
    });
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "downloadingPdf");
    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });
    FlutterDownloader.registerCallback(downloadCallback);
    print(date);
  }



  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();

  }
  static downloadCallback(id, status, progress){
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloadingPdf');
    sendPort!.send(progress);

  }
  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    empId = await shared!.getEmpId();
    print('empId $empId');
    Future<SalarySlipDownloadModal> getEmployeeList11 = getSalarySlip(sessionId!);

    getEmployeeList11.then((value) {
      setState(() {
        salarySlipDownloadModalGlobal=value;
        salarySlip = salarySlipDownloadModalGlobal!.salarySlip;
        print('salarySlip $salarySlip');
      });
    });

  }


  Future<SalarySlipDownloadModal> getSalarySlip(String SessionId) async {
    String conn = ApiDetails.serverTwo;
    String apiUrl = ApiDetails.salarySlipDownload;
    print('employeeList11: ${SessionId}');
    SalarySlipDownloadModal salarySlipDownloadModal;
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$SessionId&"
        "empId=$empId&"
        "month=$selectedDate"

    );
    final response = await MobileHttpClient.instance.get(urlapi);
    print('URL ${response.request}');


    mapResponse = json.decode(response.body);
    var getData = mapResponse;
    print('responseemployeeList $getData');
    salarySlipDownloadModal=SalarySlipDownloadModal.fromJson(mapResponse);

    return salarySlipDownloadModal;
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('s').format(dateTime);
  }
  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (!mounted) return;
    setState(() {
      timeString = formattedDateTime;
    });
  }


  */
/*void startDownloading() async {
     String url =
        '$salarySlip';

    String fileName = '$selectedDate' + " " +timeString.toString() + '.pdf';


    String path = await _getFilePath(fileName);

    await dio.download(
      url,
      path,
      onReceiveProgress: (recivedBytes, totalBytes) {
        setState(() {
          progress = recivedBytes / totalBytes;
        });

        print(progress);
        print(path);
      },
      deleteOnError: true,
    ).then((_) {
      Navigator.pop(context);
    });
  }*/ /*


  Future<String> _getFilePath(String filename) async {
    final dir = await getExternalStorageDirectory();
    return "${dir!.path}/$filename";
  }
  String singleDateString="";
  final TextEditingController _dateController = TextEditingController();
  String? selectedDate;



 */
/* String Progress = "0";
  //Final Dio dio = Dio();
    Future requestPermission() async {
      final permission = await Permission.storage;
      if (permission != PermissionStatus.granted) {
        await Permission.manageExternalStorage;
      }
      return permission == PermissionStatus.granted;
    }

    Future <Directory> getDownloadDirectory() async {
      if (Platform.isAndroid){
        return await DownloadsPathProvider.downloadsDirectory;
      }
      return getApplicationDocumentsDirectory();
    }

    Future startDownload(String savePath, String urlPath) async {
      Map<String,dynamic> result = {
        "isSuccess": false,
        "filePath" : null,
        "error" : null
      };
      try {
        var response  = await dio.download(urlPath, savePath, onReceiveProgress: _onReceiveProgress);
        result['isSuccess'] = response.statusCode == 200;
        result['filePath'] = savePath;
      } catch (e) {
        result['error'] = e.toString();
      } finally {
        _showNotifications(result);
      }
    }

    Future _onReceiveProgress(int receive , int total) {
      if( total != -1) {
        setState(() {
          Progress = (receive/total*100).toStringAsFixed(0) + "%";
        });
      }
    }

    Future _showNotifications(Map<String,dynamic> downloadStatus)async {
      final android = AndroidNotificationDetails("channelId", "MyChannel", channelDescription: "Channel Description",
          priority: Priority.high,importance: Importance.max
      );
      final ios = DarwinNotificationDetails();
      final notificationDet = NotificationDetails(android: android, iOS: ios);
      final json = jsonEncode(downloadStatus);
      final isSuccess = downloadStatus['isSuccess'];
      await FlutterLocalNotificationsPlugin().show(
          0, isSuccess?"Success" : "error",
          isSuccess?"File Download" : "File Download Failed",
          notificationDet,
        payload: json
      );
    }
*/ /*


  final Dio newDio = Dio();
  double newProgress = 0.0;

  void  _downloadFile() async {
    final status = await Permission.storage.request();
    print('Status $status');
    if (status.isGranted) {
      */
/*const downloadsFolderPath = '/storage/emulated/0/Download/';
      Directory dir = Directory(downloadsFolderPath);
      file = File('${dir.path}/$fileNamedemo');
*/ /*

      final baseStorage = await getExternalStorageDirectory();
      final id = await FlutterDownloader.enqueue(url: '$salarySlip',
          savedDir: '/storage/emulated/0/Download/',
          fileName: 'myfile.pdf',
        showNotification: true,
        openFileFromNotification: true,
        requiresStorageNotLow: true
      );
    }
    else{
      print('no permission');
    }
  }

  Future<bool> saveNewFile(String url, String fileName) async{
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if(await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();

          String newPath = "";
          List<String> folders = directory!.path.split("/");
          for(int x = 1; x<folders.length; x++) {
            String folder = folders[x];
            if(folder != "Android") {
              newPath += "/"+folder;
            } else {
              break;
            }
          }



          newPath = newPath+"/MyPdfs";
          directory = Directory(newPath);
          print(directory!.path);
        } else {
          return false;
        }
      }
      else{
        if(await _requestPermission(Permission.photos)) {
          directory = await getApplicationDocumentsDirectory();
        } else {
          return false;
        }

      }
      if(!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if(await directory.exists()) {
        File saveFile = File(directory.path+"/$fileName");
       await newDio.download(url, saveFile.path, onReceiveProgress: (downloaded, totalSize) {
         setState(() {
           newProgress = downloaded/totalSize;
         });
       });
       if(Platform.isIOS) {
         await ImageGallerySaver.saveFile(saveFile.path, isReturnPathOfIOS: true);
       }
       return true;
      }
    } catch(e) {
      print(e);
    }

    return false;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if(await permission.isGranted) {
      return true;
    } else {
     var result = await permission.request();
     if(result == PermissionStatus.granted) {
       return true;
     } else {
       return false;
     }
    }
  }

  bool loading = false;
  newDownloadFile() async {
    String fileName = '$selectedDate' + " " +timeString.toString() + '.pdf';
    setState(() {
      loading= true;
    });

    bool downloaded = await saveNewFile("$salarySlip" , "$fileName");
    if(downloaded) {
      print("File Downloaded");
    }
    else{
      print("File not Downloaded");
    }

    setState(() {
      loading= false;
    });
  }

  var titleName = 'Salary Slip';
  @override
  Widget build(BuildContext context) {
    String downloadingprogress = (progress * 100).toInt().toString();
    return Scaffold(
      appBar: AppBar(
        title: titleName.text.make(),
        actions: [
          selectedDate == null ?
          IconButton(
              onPressed: () {
                dateSelection();
              }, icon: Icon(Icons.date_range_rounded)) :
              InkWell(
                onTap: () {
                  dateSelection();
                },
                child: "$selectedDate".text.lg.center.color(Mythemes.black).make().px8().py12(),
              )
        ],
      ),

      body: salarySlip == "" ? Center(
        child: "Salary Not Released !!".text.make(),
      ) :
      PDF().cachedFromUrl(
        '$salarySlip',
        placeholder: (progress) => Center(child: Text('$progress %')),
        errorWidget: (error) => Center(child: Text(error.toString())),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: newDownloadFile,
        */
/*onPressed: () async {
          newDownloadFile();
          */ /*
*/
/*_downloadFile();*/ /*
*/
/*
          //FileDownload().download(context,salarySlip);
         // _download();
          //startDownloading();
          AlertDialog(
            backgroundColor: Colors.black,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator.adaptive(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Downloading: $downloadingprogress%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          );
        },*/ /*

        backgroundColor: Mythemes.lightBluishColor,
        child: Icon(
          Icons.download, color: Mythemes.whitish, size: 28,
        ),
      ),
    );
  }
}
*/
