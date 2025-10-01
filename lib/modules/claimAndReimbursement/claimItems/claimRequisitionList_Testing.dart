import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../commanScreen/allAPIList.dart';
import '../../../main.dart';
import '../../../sharedPrefancePage/ShardPre.dart';
import '../newModalClasses/selfClaimRequisitionListModal.dart';

class ClaimRequisitionPageTesting extends StatefulWidget {
  @override
  _ClaimRequisitionPageTestingState createState() => _ClaimRequisitionPageTestingState();
}

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;

class _ClaimRequisitionPageTestingState extends State<ClaimRequisitionPageTesting> with RouteAware{
  int currentTabIndex = 0; // Tracks the current selected tab
  late Future<ClaimRequisitionModal> futureData;

  List<dynamic> draftList = [];
  List<dynamic> pendingList = [];
  List<dynamic> approvedList = [];
  List<dynamic> disapprovedList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
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

  @override
  void initState() {
    super.initState();
    futureData = getClaimRequisitionData();
    getSharedPrfanceList();
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared.getSessionId();
  }

  Future<ClaimRequisitionModal> getClaimRequisitionData() async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.selfClaimRequestListApi;
    var url = Uri.parse("$conn$apiUrl?sessionId=$sessionId");

    final response = await http.post(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ClaimRequisitionModal claimRequisitionModal =
      ClaimRequisitionModal.fromJson(data);

      // Filter data into separate lists
     /* draftList = claimRequisitionModal.claimRequisitionDraftlist!;
      pendingList = claimRequisitionModal.claimRequisitionPendinglist!;
      approvedList = claimRequisitionModal.claimRequisitionApprovedlist!;
      disapprovedList = claimRequisitionModal.claimRequisitionDisapprovelist!;*/

      return claimRequisitionModal;
    } else {
      throw Exception("Failed to load data");
    }
  }

  Widget buildTabContent() {
    List<dynamic> currentList;

    switch (currentTabIndex) {
      case 0:
        currentList = draftList;
        break;
      case 1:
        currentList = pendingList;
        break;
      case 2:
        currentList = approvedList;
        break;
      case 3:
        currentList = disapprovedList;
        break;
      default:
        currentList = [];
    }

    if (currentList.isEmpty) {
      return Center(child: Text("No data available"));
    }

    return ListView.builder(
      itemCount: currentList.length,
      itemBuilder: (context, index) {
        final item = currentList[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(item['empName']),
            subtitle: Text("Claim No: ${item['claimNo']}"),
            trailing: Text(item['statusShow']),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Claim Requisition")),
      body: FutureBuilder<ClaimRequisitionModal>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedToggleSwitch<int>.rolling(
                  current: currentTabIndex,
                  values: [0, 1, 2, 3],
                  iconBuilder: (tab, isActive) {
                    // Adjust icon based on the tab index
                    switch (tab) {
                      case 0:
                        return Icon(Icons.edit, color: isActive ? Colors.blue : Colors.grey);
                      case 1:
                        return Icon(Icons.pending, color: isActive ? Colors.blue : Colors.grey);
                      case 2:
                        return Icon(Icons.check_circle, color: isActive ? Colors.blue : Colors.grey);
                      case 3:
                        return Icon(Icons.cancel, color: isActive ? Colors.blue : Colors.grey);
                      default:
                        return Icon(Icons.help, color: isActive ? Colors.blue : Colors.grey);
                    }
                  },
                  onChanged: (index) => setState(() => currentTabIndex = index),
                )
              ),
              Expanded(child: buildTabContent()),
            ],
          );
        },
      ),
    );
  }
}

