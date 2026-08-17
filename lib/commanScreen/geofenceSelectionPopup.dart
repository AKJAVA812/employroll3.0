import 'package:flutter/material.dart';

class GeofenceSelectionPopup extends StatefulWidget {
  const GeofenceSelectionPopup({super.key});

  @override
  State<GeofenceSelectionPopup> createState() => _GeofenceSelectionPopupState();
}

class _GeofenceSelectionPopupState extends State<GeofenceSelectionPopup> {
  final TextEditingController searchController = TextEditingController();
  final List<String> geofenceList = [
    'Head Office',
    'Warehouse',
    'Plant 1',
    'Plant 2',
    'Client Site',
    'Remote Office',
  ];

  String? selectedGeofence;
  List<String> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = geofenceList;
  }

  void _filterGeofence(String query) {
    setState(() {
      filteredList = geofenceList
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Select Geofence",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔍 Search Field
            /*TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search geofence...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterGeofence,
            ),
            const SizedBox(height: 12),*/

            // 📍 Dropdown List
            DropdownButtonFormField<String>(
              value: selectedGeofence,
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Select Geofence",
              ),
              items: filteredList
                  .map((geo) => DropdownMenuItem<String>(
                value: geo,
                child: Text(geo),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedGeofence = value;
                });
              },
            ),
          ],
        ),
      ),

      // 🔘 Buttons
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            if (selectedGeofence != null) {
              Navigator.pop(context, selectedGeofence);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select a geofence")),
              );
            }
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}