import 'package:flutter/material.dart';

class MealSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select a Meal")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1, // Square cards
          ),
          itemCount: mealOptions.length,
          itemBuilder: (context, index) {
            final meal = mealOptions[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRScannerPage(mealName: meal['name'])),
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(meal['icon'], size: 50, color: Colors.blueAccent),
                    SizedBox(height: 10),
                    Text(meal['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

class QRScannerPage extends StatefulWidget {
  final String mealName;
  QRScannerPage({required this.mealName});

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
/*  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan QR for ${widget.mealName}")),
      body: Column(
        children: [
          /*Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  controller.pauseCamera();
                  Navigator.pop(context, scanData.code);
                });
              },
            ),
          ),*/
          Expanded(
            child: Center(child: Text("Scan a QR code")),
          ),
        ],
      ),
    );
  }
}

// Meal options with icons
final List<Map<String, dynamic>> mealOptions = [
  {"name": "Breakfast", "icon": Icons.free_breakfast},
  {"name": "Lunch", "icon": Icons.lunch_dining},
  {"name": "Snacks", "icon": Icons.fastfood},
  {"name": "Dinner", "icon": Icons.dinner_dining},
];