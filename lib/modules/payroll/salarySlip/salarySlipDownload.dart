import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import '../../../commanScreen/allAPIList.dart';
import '../../../commanScreen/homePage.dart';
import '../../../commanScreen/routes.dart';
import '../../../main.dart';
import '../../../sharedPrefancePage/ShardPre.dart';
import '../modalClass/salarySlipDownloadModal.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:download/download.dart';

class SalarySlipDownload extends StatefulWidget {
  const SalarySlipDownload({Key? key}) : super(key: key);

  @override
  State<SalarySlipDownload> createState() => _SalarySlipDownloadState();
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;
int? empId;
var salarySlip;
SalarySlipDownloadModal? salarySlipDownloadModalGlobal;

class _SalarySlipDownloadState extends State<SalarySlipDownload> {

  Dio dio = Dio();
  var progress = 0;
  var timeString = "0.0";

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    // timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    Future.delayed(Duration.zero, () {
      //dateSelection();
      showCustomMonthPicker(
        context: context,
        initialDate: DateTime.now(),
        onMonthSelected: (date) {
          setState(() {
            _dateController.text = DateFormat("MMMM-yy").format(date!);
            selectedDate = _dateController.text;
            print('MonthPicker $selectedDate');
            getSharedPrfanceList();
            print("New Get Salary - $salarySlip");
            print('Selected: $date');
            print(date);
          });

        },
      );
      salarySlip = "";
      //FileDownload().registerPortData(setState);
    });
    // Register port with isolate for download progress communication
    /*IsolateNameServer.registerPortWithName(receivePort.sendPort, "downloadingPdf");

    // Listen to download progress
    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });

    // Register the callback for download progress
    FlutterDownloader.registerCallback(downloadCallback);*/
    //startDownloading();

  }

  void showCustomMonthPicker({
    required BuildContext context,
    required Function(DateTime selectedMonth) onMonthSelected,
    DateTime? initialDate,
  }) {
    final now = DateTime.now();
    DateTime selected = initialDate ?? DateTime(now.year, now.month);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        int selectedYear = selected.year;
        List<String> months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Year Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => setState(() => selectedYear--),
                      ),
                      Text(
                        '$selectedYear',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          if (selectedYear < now.year) {
                            setState(() => selectedYear++);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Month Grid
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 2.5,
                    children: List.generate(12, (index) {
                      final isDisabled = selectedYear == now.year && index > now.month - 1;
                      return GestureDetector(
                        onTap: isDisabled
                            ? null
                            : () {
                          final selectedDate = DateTime(selectedYear, index + 1);
                          Navigator.pop(context);
                          onMonthSelected(selectedDate);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isDisabled ? Colors.grey[300] : Colors.blue[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            months[index],
                            style: TextStyle(
                              color: isDisabled ? Colors.grey : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  ReceivePort receivePort = ReceivePort();
  dateSelection() async {
    DateTime? date = DateTime.now();
    FocusScope.of(context).requestFocus(new FocusNode());

    // Show the month-year picker
    /*date = await showMonthYearPicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    );*/

    /*date = await showMonthYearPicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            primaryColor: Colors.lightBlue,
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: Colors.lightBlue,                         // Color for selected month/year
              onPrimary: Colors.white,                            // Text color on selected month/year
              onSurface: Colors.black,                            // Color for unselected month/year
            ),
            textTheme: TextTheme(
              headlineMedium: TextStyle(                          // Text style for the month/year
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
              ),
              bodyLarge: TextStyle(fontSize: 10, color: Colors.black, letterSpacing: 0), // Style for unselected items

            ),
          ),
          child: child!,
        );
      },
    );*/
    date = await showMonthYearPicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.lightBlue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                fontSize: 14,
                color: Colors.black,
                letterSpacing: 0,
              ),
            ),
          ),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(0), // Remove padding
                margin: const EdgeInsets.all(0),
                constraints: const BoxConstraints(
                  maxWidth: 480,
                  minWidth: 480,
                ),
                child: child!,
              ),
            ),
          ),
        );
      },
    );

    setState(() {
      _dateController.text = DateFormat("MMMM-yy").format(date!);
      selectedDate = _dateController.text;
      print('MonthPicker $selectedDate');
      getSharedPrfanceList();
    });

    // Register port with isolate for download progress communication
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "downloadingPdf");

    // Listen to download progress
    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });

    // Register the callback for download progress
    FlutterDownloader.registerCallback(downloadCallback);

    print(date);
  }



  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();

  }
  static downloadCallback(id, status, progress){
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);

  }
  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    empId = await shared!.getEmpId();
    print('empId $empId');
    _getTime();
    print('TIME - $timeString');
    Future<SalarySlipDownloadModal> getEmployeeList11 = getSalarySlip(sessionId!);

    getEmployeeList11.then((value) {
      setState(() {
        salarySlipDownloadModalGlobal=value;
        salarySlip = salarySlipDownloadModalGlobal!.salarySlip;
        print('salarySlip $salarySlip');
      });
    });

    final status = await Permission.storage.request();
    print('Status $status');

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
    final response = await http.get(urlapi);
    print('URL ${response.request}');

    setState(() {
      mapResponse = json.decode(response.body);
      var getData = mapResponse;
      print('My Salary Slip $getData');

    });
    salarySlipDownloadModal=SalarySlipDownloadModal.fromJson(mapResponse);
    salarySlip = salarySlipDownloadModal.salarySlip;
    print("Salary Slip Show - $salarySlip");
    setState(() {

    });
    return salarySlipDownloadModal;
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('ss').format(dateTime);
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
      Navigator.of(context, rootNavigator: true).pop();
    });
  }*/

  Future<String> _getFilePath(String filename) async {
    final dir = await getExternalStorageDirectory();
    return "${dir!.path}/$filename";
  }
  String singleDateString="";
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

  /*void  _downloadFile() async {
    String fileName = '$selectedDate'+ "-"+ "$timeString"+'.pdf';
    if(Platform.isAndroid) {
      var storagePath = "/storage/emulated/0/Download/$fileName";
      var file = File(storagePath);
      var res = await get(Uri.parse("$salarySlip"));
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
      print("$salarySlip");
      print("$fileName");
      print("$storagePath");
      file.writeAsBytes(res.bodyBytes);

    }
    else{
      final status = await Permission.storage.request();
      print('Status $status');
      if (status.isGranted) {
        final downloadDir = await getDownloadDirectory();
        final filePath = '$downloadDir/$fileName';
        String fileName = '$selectedDate'+"-"+"$timeString"+'.pdf';

        final baseStorage = await getApplicationDocumentsDirectory();
        final id = await FlutterDownloader.enqueue(url: '$salarySlip',
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
    }


  }*/


  void _downloadFile() async {
    String fileName = '$selectedDate' + "-" + "$timeString" + '.pdf';
    if (Platform.isAndroid) {
      print("I am Android");
      var storagePath = "/storage/emulated/0/Download/$fileName";
      var file = File(storagePath);
      var res = await http.get(Uri.parse("$salarySlip"));
      await file.writeAsBytes(res.bodyBytes);
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
    } else if (Platform.isIOS) {
      print("I am iOS");
      final status = await Permission.storage.request(); // Use 'photos' permission as 'storage' is not available on iOS
      if (status.isGranted) {
        final downloadDir = await getDownloadDirectory();
        final filePath = '$downloadDir/$fileName';
        var file = File(filePath);
        var res = await http.get(Uri.parse("$salarySlip"));
        await file.writeAsBytes(res.bodyBytes);
        Fluttertoast.showToast(
            msg: "Download Completed - $fileName",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        _showNotification(filePath, fileName);
      } else {
        print('No permission granted');
      }
    }
  }

  /*void _downloadFile() async {
    String fileName = '$selectedDate' + "-" + "$timeString" + '.pdf';
    if (Platform.isAndroid) {
      print("I am Android");
      var storagePath = "/storage/emulated/0/Download/$fileName";
      var file = File(storagePath);
      var res = await http.get(Uri.parse("$salarySlip"));
      file.writeAsBytes(res.bodyBytes);
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
    }
    else if (Platform.isIOS) {
      print("I am iOS");
      // Request storage permission (for compatibility, but not always necessary on iOS)
      final status = await Permission.storage.request();
      if (status.isGranted) {
        final downloadDir = await getApplicationDocumentsDirectory();
        final filePath = '${downloadDir.path}/$fileName';
        var file = File(filePath);
        var res = await http.get(Uri.parse("$salarySlip"));
        await file.writeAsBytes(res.bodyBytes);
        Fluttertoast.showToast(
            msg: "Download Completed - $fileName",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        _showNotification(filePath, fileName);
      } else {
        print('No permission granted');
      }
    }
    *//*else {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        final downloadDir = await getDownloadDirectory();
        final filePath = '$downloadDir/$fileName';
        final id = await FlutterDownloader.enqueue(
            url: '$salarySlip',
            savedDir: downloadDir,
            fileName: fileName,
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
      } else {
        print('no permission');
      }
    }*//*
  }*/



  /*void _showNotification(String filePath, String fileName) async {
    print("File Path - $filePath");
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      icon: '@mipmap/ic_launcher',  // Specify the correct icon resource here
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Completed',
      fileName,
      platformChannelSpecifics,
      payload: filePath,
    );
  }*/

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
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
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        if (notificationResponse.payload != null) {
          _onNotificationTap(notificationResponse.payload!);
        }
      },
    );
  }

  void _onNotificationTap(String payload) async {
    await OpenFile.open(payload);
  }

  void _showNotification(String filePath, String fileName) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      icon: '@mipmap/ic_launcher',
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

/*  void _showNotification(String filePath, String fileName) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      icon: '@mipmap/ic_launcher',  // Specify the correct icon resource here
    );
   *//* const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );*//*
    // iOS notification details
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
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
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
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        if (notificationResponse.payload != null) {
          _onNotificationTap(notificationResponse.payload!);
        }
      },
    );
  }*/

  int pageIndex = 0;
  int currentIndex = 3;
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
                //dateSelection();
                showCustomMonthPicker(
                  context: context,
                  initialDate: DateTime.now(),
                  onMonthSelected: (date) {
                    setState(() {
                      _dateController.text = DateFormat("MMMM-yy").format(date!);
                      selectedDate = _dateController.text;
                      print('MonthPicker $selectedDate');
                      getSharedPrfanceList();
                      print("New Get Salary - $salarySlip");
                      print('Selected: $date');
                      print(date);
                    });

                  },

                );
                salarySlip = "";
              }, icon: Icon(Icons.date_range_rounded)) :
          InkWell(
            onTap: () {
              //dateSelection();
              showCustomMonthPicker(
                context: context,
                initialDate: DateTime.now(),
                onMonthSelected: (date) {
                  setState(() {
                    _dateController.text = DateFormat("MMMM-yy").format(date!);
                    selectedDate = _dateController.text;
                    print('MonthPicker $selectedDate');
                    getSharedPrfanceList();
                    print("New Get Salary - $salarySlip");
                    print('Selected: $date');
                    print(date);
                  });
                },
              );
              salarySlip = "";
            },
            child: "$selectedDate".text.lg.center.color(Mythemes.black).make().px8().py12(),
          )
        ],
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
            print('home tab');
          }
          if(index==1){
            Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
            print('Dashboard');
          }
          if(index==2){
            Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            print('Attendance');
          }
          if(index==3){
            Navigator.pushNamed(context, MyRoutings.documentsAddedRoute);
            print('e-Doc');
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

      body: salarySlip == "" ? Center(
        child: "Salary Not Released !!".text.make(),
      ) :
      PDF().cachedFromUrl(
        '$salarySlip',
        placeholder: (progress) => Center(child: Text('$progress %')),
        errorWidget: (error) => Center(child: Text(error.toString())),
      ),



      floatingActionButton: Visibility(
        visible: salarySlip != "",
        child: FloatingActionButton(
          onPressed: () async {
            _downloadFile();
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
          },
          backgroundColor: Mythemes.lightBluishColor,
          child: Icon(
            Icons.download, color: Mythemes.whitish, size: 28,
          ),
        ),
      ),
    );
  }
}