import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import '../../../commanScreen/allAPIList.dart';
import '../../../sharedPrefancePage/ShardPre.dart';
import 'package:month_year_picker/month_year_picker.dart';
import '../../commanScreen/homePage.dart';
import '../../commanScreen/routes.dart';
import '../../main.dart';
import '../../themes/empThemes.dart';
import 'documentsAdded.dart';
import 'modalClass/documentDataModal.dart';

class DownloadLetters extends StatefulWidget {
  var docId;
  var docName;
  DownloadLetters(this.docId, this.docName);

  @override
  State<DownloadLetters> createState() => _DownloadLettersState(docId, docName);
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
int? empId;
var documentUrl;
var documentName;
DocumentDataModal? documentDownloadlGlobal;
var docIdCheck = "";
var docNameCheck = "";

class _DownloadLettersState extends State<DownloadLetters> {
  _DownloadLettersState(docId, docName);
  Dio dio = Dio();
  var progress = 0;
  var timeString = "0.0";

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
    empId = await shared.getEmpId();
    print('empId $empId');
    Future<DocumentDataModal> getEmployeeList11 = getDocument(sessionId!);

    getEmployeeList11.then((value) {
      setState(() {
        documentDownloadlGlobal = value;
        for (int i = 0; i < documentDownloadlGlobal!.data!.length; i++) {
          documentUrl = documentDownloadlGlobal!.data![i].letter;
          documentName = documentDownloadlGlobal!.data![i].document;
          setState(() {});
          print('DOC URLGet -  $documentUrl');
          print('DOC Name -  $documentName');
        }
      });
    });
    setState(() {});
  }

  Future<DocumentDataModal> getDocument(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.documentDetApi;
    print('employeeList11: ${SessionId}');
    DocumentDataModal documentDataModal;
    var urlapi = Uri.parse(
      "$conn$apiUrl?"
      "sessionId=$SessionId&"
      "empid=$empId&"
      "docId=$docId",
    );
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse;
    print('responseemployeeList $getData');
    documentDataModal = DocumentDataModal.fromJson(mapResponse);

    return documentDataModal;
  }

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    docIdCheck = docId;
    docNameCheck = docName;
    getSharedPrfanceList();
    setState(() {
      documentUrl = "";
    });
    /*timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    Future.delayed(Duration.zero, () {
      dateSelection();
      salarySlip = "";
      //FileDownload().registerPortData(setState);
    });*/
    //startDownloading();
  }

  ReceivePort receivePort = ReceivePort();
  dateSelection() async {
    DateTime? date = DateTime.now();
    FocusScope.of(context).requestFocus(FocusNode());

    date = await showMonthYearPicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1947),
      lastDate: DateTime.now().add(Duration(days: 0)),
    );
    setState(() {
      // singleDateString = DateFormat('dd-MM-yyyy').format(date!);
      _dateController.text = DateFormat("MMMM-yy").format(date!);
      selectedDate = _dateController.text;

      print('MonthPicker $selectedDate');
      getSharedPrfanceList();

      //  DateFormat.yMd().format(date!).toString();
    });
    IsolateNameServer.registerPortWithName(
      receivePort.sendPort,
      "downloadingPdf",
    );
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

  static downloadCallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloadingPdf');
    sendPort!.send(progress);
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
  }*/

  Future<String> _getFilePath(String filename) async {
    final dir = await getExternalStorageDirectory();
    return "${dir!.path}/$filename";
  }

  String singleDateString = "";
  final TextEditingController _dateController = TextEditingController();
  String? selectedDate;

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
*/

  final Dio newDio = Dio();
  double newProgress = 0.0;
  Future<String> getDownloadDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    // You can also use getApplicationDocumentsDirectory() for the app's documents directory
    return directory.path;
  }

  void findAndroidDataPath() async {
    final externalStorageDir = await getExternalStorageDirectory();
    final androidDataPath = '${externalStorageDir!.path}/Android/data/';

    print('Android Data Path: $androidDataPath');
  }

  void _downloadFile() async {
    for (int i = 0; i < documentDownloadlGlobal!.data!.length; i++) {
      documentUrl = documentDownloadlGlobal!.data![i].letter;
      documentName = documentDownloadlGlobal!.data![i].document;
      print('DOC URL -  $documentUrl');
      print('DOC Name -  $documentName');
    }
    String fileName = '$documentName' + '.pdf';
    /*if(Platform.isAndroid) {
      var storagePath = "/storage/emulated/0/Download/$fileName";
      var file = File(storagePath);
      var res = await get(Uri.parse("$documentUrl"));
      Fluttertoast.showToast(
          msg: "Download Completed - $fileName",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      _showNotification(storagePath, fileName);
      print("$documentUrl");
      print("$fileName");
      print("$storagePath");
      file.writeAsBytes(res.bodyBytes);
    }*/
    if (Platform.isAndroid) {
      var storagePath = "/storage/emulated/0/Download/$fileName";
      var file = File(storagePath);
      var res = await MobileHttpClient.instance.get(Uri.parse("$documentUrl"));
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
      print("$documentUrl");
      print("$fileName");
      print("$storagePath");
    } else if (Platform.isIOS) {
      print("I am IOS");
      final status = await Permission.storage.request();
      if (status.isGranted) {
        final downloadDir = await getDownloadDirectory();
        final filePath = '$downloadDir/$fileName';
        var file = File(filePath);
        var res = await MobileHttpClient.instance.get(
          Uri.parse("$documentUrl"),
        );
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
        print('no permission');
      }
    }
    /*else{
      final status = await Permission.storage.request();
      print('Status $status');
      if (status.isGranted) {
        final downloadDir = await getDownloadDirectory();
        final filePath = '$downloadDir/$fileName';
        //String fileName = '$documentName'+'.pdf';
        final baseStorage = await getApplicationDocumentsDirectory();
        final id = await FlutterDownloader.enqueue(url: '$documentUrl',
            savedDir: downloadDir,
            fileName: '$fileName',
            showNotification: true,
            openFileFromNotification: true,
            requiresStorageNotLow: true
        );
        Fluttertoast.showToast(
            msg: "Download Completed - $fileName",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
        _showNotification(filePath, fileName);
        //findAndroidDataPath();
        print("DOCUMENT - $baseStorage");
        print("File Name - $fileName");
        print("Storage - $downloadDir");
      }
      else{
        print('no permission');
      }
    }*/
  }

  void _showNotification(String filePath, String fileName) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          icon: '@mipmap/ic_launcher', // Specify the correct icon resource here
        );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
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
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (
        NotificationResponse notificationResponse,
      ) async {
        if (notificationResponse.payload != null) {
          _onNotificationTap(notificationResponse.payload!);
        }
      },
    );
  }

  Future<bool> saveNewFile(String url, String fileName) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();

          String newPath = "";
          List<String> folders = directory!.path.split("/");
          for (int x = 1; x < folders.length; x++) {
            String folder = folders[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }

          newPath = newPath + "/MyPdfs";
          directory = Directory(newPath);
          print(directory.path);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getApplicationDocumentsDirectory();
        } else {
          return false;
        }
      }
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File saveFile = File(directory.path + "/$fileName");
        await newDio.download(
          url,
          saveFile.path,
          onReceiveProgress: (downloaded, totalSize) {
            setState(() {
              newProgress = downloaded / totalSize;
            });
          },
        );
        if (Platform.isIOS) {
          await ImageGallerySaverPlus.saveFile(
            saveFile.path,
            isReturnPathOfIOS: true,
          );
        }
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool loading = false;
  newDownloadFile() async {
    for (int i = 0; i < documentDownloadlGlobal!.data!.length; i++) {
      documentUrl = documentDownloadlGlobal!.data![i].letter;
      documentName = documentDownloadlGlobal!.data![i].document;
      print('DOC URL -  $documentUrl');
      print('DOC Name -  $documentName');
    }
    _downloadFile();
    /*String fileName = '$selectedDate' + " " +timeString.toString() + '.pdf';
    setState(() {
      loading= true;
    });

    bool downloaded = await saveNewFile("$documentUrl" , "$fileName");
    if(downloaded) {
      print("File Downloaded");
    }
    else{
      print("File not Downloaded");
    }

    setState(() {
      loading= false;
    });*/
  }

  int pageIndex = 3;
  int currentIndex = 3;
  var titleName = 'Download Document';
  @override
  Widget build(BuildContext context) {
    String downloadingprogress = (progress * 100).toInt().toString();
    return Scaffold(
      appBar: AppBar(
        title: docNameCheck.text.make(),
        /* actions: [
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
        ],*/
      ),

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
            print('home tab');
          }
          if (index == 1) {
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            print('Dashboard');
          }
          if (index == 2) {
            Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Attendance');
          }
          if (index == 3) {
            Navigator.pushNamed(context, MyRoutings.documentsAddedRoute);
            print('e-Doc');
          }
          /*if(index==3){
                title="Notifications";
              }*/
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.time_solid),
            label: 'Attendance',
            //backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_text_search),
            label: 'e-Doc',
            //backgroundColor: Colors.blue,
          ),
        ],
      ),

      body:
          documentUrl == "-"
              ? Center(
                child: "Document not uploaded in the system !!".text.make(),
              )
              : PDF().cachedFromUrl(
                '$documentUrl',
                placeholder: (progress) => Center(child: Text('$progress %')),
                errorWidget: (error) => Center(child: Text(error.toString())),
              ),

      floatingActionButton: Visibility(
        visible: documentUrl != "-",
        child: FloatingActionButton(
          onPressed: newDownloadFile,
          /*onPressed: () async {
            newDownloadFile();
            */
          /*_downloadFile();*/
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
          },*/
          backgroundColor: Mythemes.lightBluishColor,
          child: Icon(Icons.download, color: Mythemes.whitish, size: 28),
        ),
      ),
    );
  }
}
