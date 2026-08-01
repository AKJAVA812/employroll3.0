import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../commanScreen/allAPIList.dart';
import '../sharedPrefancePage/ShardPre.dart';
import '../themes/empThemes.dart';
import 'modalClass/companyPolicyModal.dart';

class Policy {
  final String uploadedFileName;
  final String policyName;
  final String policyType;
  final String description;
  final String id;
  final String docPath;

  Policy({
    required this.uploadedFileName,
    required this.policyName,
    required this.policyType,
    required this.description,
    required this.id,
    required this.docPath,
  });

  factory Policy.fromJson(Map<String, dynamic> json) {
    return Policy(
      uploadedFileName: json['uploadedFileName'] ?? '',
      policyName: json['policyName'] ?? '',
      policyType: json['policytype'] ?? '',
      description: json['description'] ?? '',
      id: json['id'] ?? '',
      docPath: json['docPath'] ?? '',
    );
  }
}

Map<String, dynamic> mapResponse = {};
SessionManager shared = SessionManager();
String? sessionId;

class CompanyPoliciesPage extends StatefulWidget {
  const CompanyPoliciesPage({Key? key}) : super(key: key);

  @override
  _CompanyPoliciesPageState createState() => _CompanyPoliciesPageState();
}

class _CompanyPoliciesPageState extends State<CompanyPoliciesPage> {
  List<Policy> policies = [];
  bool isLoading = true;
  List<AllPolicyList>? allUsernew = [];
  List<AllPolicyList>? foundDataNew = [];
  CompanyPolicyModal? companyPolicyGlobal;
  CompanyPolicyModal? companyPolicyGlobaled;

  @override
  void initState() {
    super.initState();
    //fetchPolicies();
    getSharedPrfanceList();
    setState(() {});
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
    Future<CompanyPolicyModal> getEmployeeList11 = getPolicies(sessionId!);
    getEmployeeList11.then((value) {
      setState(() {
        foundDataNew = allUsernew;
        companyPolicyGlobal = value;
        companyPolicyGlobaled = companyPolicyGlobal;
      });
      print('Policy list - ${companyPolicyGlobal!.allPolicyList!.length}');
    });
  }

  Future<void> fetchPolicies() async {
    // Simulating API call with the provided JSON data
    const jsonString = '''
    {
      "payrollPolicyList": [],
      "timeAttPolicyList": [],
      "leavePolicyList": [],
      "allPolicyList": [
        {
          "uploadedFileName": "Privado_HR_Policies.pdf",
          "policyName": "Company HR Policy Document",
          "policytype": "Organisation Policy",
          "description": "",
          "id": "19",
          "docPath": "https://s3.ap-south-1.amazonaws.com/employroll.com/policyDocs/1745410137591.pdf"
        },
        {
          "uploadedFileName": "Q Green Techcon HSE Policy.pdf",
          "policyName": "Document",
          "policytype": "Organisation Policy",
          "description": "",
          "id": "23",
          "docPath": "https://s3.ap-south-1.amazonaws.com/employroll.com/policyDocs/1750158297355.pdf"
        }
      ],
      "orgPolicyList": [
        {
          "uploadedFileName": "Privado_HR_Policies.pdf",
          "policyName": "Company HR Policy Document",
          "policytype": "Organisation Policy",
          "description": "",
          "id": "19",
          "docPath": "https://s3.ap-south-1.amazonaws.com/employroll.com/policyDocs/1745410137591.pdf"
        },
        {
          "uploadedFileName": "Q Green Techcon HSE Policy.pdf",
          "policyName": "Document",
          "policytype": "Organisation Policy",
          "description": "",
          "id": "23",
          "docPath": "https://s3.ap-south-1.amazonaws.com/employroll.com/policyDocs/1750158297355.pdf"
        }
      ],
      "claimsPolicyList": []
    }
    ''';

    final jsonData = json.decode(jsonString);
    setState(() {
      policies =
          (jsonData['orgPolicyList'] as List)
              .map((policyJson) => Policy.fromJson(policyJson))
              .toList();
      isLoading = false;
    });
  }

  IconData _getPolicyIcon(String policyName) {
    if (policyName.toLowerCase().contains('hr')) {
      return Icons.people;
    } else if (policyName.toLowerCase().contains('claim')) {
      return Icons.monetization_on;
    } else if (policyName.toLowerCase().contains('shift')) {
      return Icons.schedule;
    } else if (policyName.toLowerCase().contains('paid')) {
      return Icons.paid;
    }
    return Icons.description;
  }

  Color _getPolicyColor(String policyName) {
    if (policyName.toLowerCase().contains('hr')) {
      return Colors.blue;
    } else if (policyName.toLowerCase().contains('claim')) {
      return Colors.green;
    } else if (policyName.toLowerCase().contains('shift')) {
      return Colors.purple;
    } else if (policyName.toLowerCase().contains('paid')) {
      return Colors.orange;
    }
    return Colors.teal;
  }

  Future<CompanyPolicyModal> getPolicies(String SessionId) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.companyPolicyApi;
    print('employeeList11: ${SessionId}');
    CompanyPolicyModal companyPolicyModal;
    var urlapi = Uri.parse("$conn$apiUrl?sessionId=$SessionId");
    final response = await MobileHttpClient.instance.post(urlapi);
    print('URL ${response.request}');

    print('responseemployeeList ${response.body}');

    mapResponse = json.decode(response.body);
    var getData = mapResponse['mappedData'];
    print('responseemployeeList $getData');
    companyPolicyModal = CompanyPolicyModal.fromJson(mapResponse);
    allUsernew = companyPolicyModal.allPolicyList;
    isLoading = false;
    return companyPolicyModal;
  }

  void _runFilter(String enteredKeyword) {
    print('value$enteredKeyword');
    List<AllPolicyList>? results = [];

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
                (element) => element.policyName!.toLowerCase().contains(
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

  var titleName = "Company Policies";
  TextEditingController searchType = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
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
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : foundDataNew!.isEmpty
                ? const Center(child: Text('No policies available'))
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: foundDataNew!.length,
                  itemBuilder: (context, index) {
                    final policy = foundDataNew![index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => PdfViewerPage(
                                    policy: Policy(
                                      uploadedFileName:
                                          foundDataNew![index].uploadedFileName,
                                      policyName:
                                          foundDataNew![index].policyName,
                                      policyType:
                                          foundDataNew![index].policytype,
                                      description:
                                          foundDataNew![index].description,
                                      id: foundDataNew![index].id,
                                      docPath: foundDataNew![index].docPath,
                                    ),
                                  ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _getPolicyColor(
                                    foundDataNew![index].policyName,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getPolicyIcon(
                                    foundDataNew![index].policyName,
                                  ),
                                  color: _getPolicyColor(
                                    foundDataNew![index].policyName,
                                  ),
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      foundDataNew![index].policyName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      foundDataNew![index].policytype
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey.shade400,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}

class PdfViewerPage extends StatefulWidget {
  final Policy policy;

  const PdfViewerPage({Key? key, required this.policy}) : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localPath;
  bool isLoading = true;
  double downloadProgress = 0.0;
  bool isDownloading = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _downloadAndSavePdf();
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
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          await _onNotificationTap(response.payload!);
        }
      },
    );
  }

  Future<void> _onNotificationTap(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final result = await OpenFile.open(filePath);
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error opening file: ${result.message}')),
          );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('File not found')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error opening file: $e')));
    }
  }

  Future<void> _showNotification(String filePath, String fileName) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'policy_download_channel',
          'Policy Downloads',
          channelDescription: 'Notifications for policy document downloads',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          icon: '@mipmap/ic_launcher',
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
      'Downloaded: $fileName',
      platformChannelSpecifics,
      payload: filePath,
    );
  }

  Future<void> _downloadAndSavePdf() async {
    try {
      final response = await MobileHttpClient.instance.get(
        Uri.parse(widget.policy.docPath),
      );
      final bytes = response.bodyBytes;
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${widget.policy.uploadedFileName}');
      await file.writeAsBytes(bytes);
      setState(() {
        localPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error downloading PDF: $e')));
    }
  }

  Future<void> _downloadFile() async {
    if (isDownloading) return;

    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
    });

    try {
      final response = await MobileHttpClient.instance.get(
        Uri.parse(widget.policy.docPath),
      );
      final bytes = response.bodyBytes;
      String filePath;

      if (Platform.isAndroid) {
        final downloadsDir = Directory('/storage/emulated/0/Download/');
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }
        filePath =
            '/storage/emulated/0/Download/${widget.policy.uploadedFileName}';
      } else if (Platform.isIOS) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission denied')),
          );
          setState(() {
            isDownloading = false;
          });
          return;
        }
        final dir = await getApplicationDocumentsDirectory();
        filePath = '${dir.path}/${widget.policy.uploadedFileName}';
      } else {
        setState(() {
          isDownloading = false;
        });
        return;
      }

      final file = File(filePath);
      await file.writeAsBytes(bytes);

      // Simulate progress for user feedback
      for (int i = 1; i <= 10; i++) {
        await Future.delayed(const Duration(milliseconds: 200));
        setState(() {
          downloadProgress = i / 10.0;
        });
      }

      Fluttertoast.showToast(
        msg: 'Download Completed - ${widget.policy.uploadedFileName}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      await _showNotification(filePath, widget.policy.uploadedFileName);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error downloading file: $e')));
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.policy.policyName),
        //backgroundColor: Colors.blue.shade700,
        elevation: 3,
      ),
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : localPath != null
              ? PDFView(
                key: ValueKey(widget.policy.id),
                filePath: localPath!,
                pageSnap: true,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: true,
                pageFling: true,
                onError: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error loading PDF: $error')),
                  );
                },
              )
              : const Center(child: Text('Failed to load PDF')),
          if (isDownloading)
            Center(
              child: AlertDialog(
                backgroundColor: Colors.black.withOpacity(0.8),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator.adaptive(),
                    const SizedBox(height: 20),
                    Text(
                      'Downloading: ${(downloadProgress * 100).toInt()}%',
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton:
          widget.policy.docPath.isNotEmpty
              ? FloatingActionButton(
                onPressed: _downloadFile,
                backgroundColor: Colors.blue.shade700,
                child: const Icon(
                  Icons.download,
                  color: Colors.white,
                  size: 28,
                ),
              )
              : null,
    );
  }
}
