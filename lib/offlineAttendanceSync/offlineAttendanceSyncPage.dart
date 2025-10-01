import 'package:flutter/material.dart';

class OfflineAttendanceSyncPage extends StatefulWidget {
  @override
  _OfflineAttendanceSyncPageState createState() => _OfflineAttendanceSyncPageState();
}

class _OfflineAttendanceSyncPageState extends State<OfflineAttendanceSyncPage> {
  // Dummy offline attendance data
  List<Map<String, String>> attendanceLogs = [
    {
      "photo": "https://i.pravatar.cc/150?img=3",
      "type": "In",
      "address": "Sector 21, Gurgaon"
    },
    {
      "photo": "https://i.pravatar.cc/150?img=4",
      "type": "Out",
      "address": "Cyber City, Gurgaon"
    },
    {
      "photo": "https://i.pravatar.cc/150?img=5",
      "type": "In",
      "address": "MG Road, Gurgaon"
    },
  ];

  void syncLog(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Synced: ${attendanceLogs[index]['type']} at ${attendanceLogs[index]['address']}")),
    );
  }

  void deleteLog(int index) {
    setState(() {
      attendanceLogs.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Deleted log")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Offline Attendance Sync",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: attendanceLogs.isEmpty
            ? Center(
          child: Text(
            "No Offline Logs Found",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        )
            : ListView.builder(
          itemCount: attendanceLogs.length,
          itemBuilder: (context, index) {
            final log = attendanceLogs[index];
            return Card(
              elevation: 6,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Employee Photo
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(log["photo"]!),
                    ),
                    SizedBox(width: 12),

                    // Punch details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Punch Type
                          Text(
                            "Punch: ${log["type"]}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: log["type"] == "In" ? Colors.green : Colors.red,
                            ),
                          ),
                          SizedBox(height: 4),
                          // Address
                          Text(
                            "Address: ${log["address"]}",
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),

                    // Sync Button
                    ElevatedButton.icon(
                      onPressed: () => syncLog(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      icon: Icon(Icons.sync, color: Colors.white),
                      label: Text(
                        "Sync",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 8),

                    // Delete Icon
                    IconButton(
                      onPressed: () => deleteLog(index),
                      icon: Icon(Icons.delete, color: Colors.red, size: 28),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}