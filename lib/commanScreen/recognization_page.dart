import 'dart:developer';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  const RecognizePage({Key? key, this.path}) : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  bool _isBusy = false;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Text Recognized"),
          actions: [
            IconButton(
                onPressed: () {
                  FlutterClipboard.copy(controller.text)
                      .then(
                          (value) {
                        return Fluttertoast.showToast(
                            msg: "Text Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      },
                  );
                }, icon: Icon(Icons.copy, size: 20,))
          ],
        ),
        body: _isBusy == true
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : Container(
          padding: const EdgeInsets.all(20),
          child: TextFormField(
            readOnly: true,
            maxLines: MediaQuery.of(context).size.height.toInt(),
            controller: controller,
            decoration:
            const InputDecoration(hintText: "Text goes here...", border: InputBorder.none),
          ),
        ));
  }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    log(image.filePath!);
    final RecognizedText recognizedText =
    await textRecognizer.processImage(image);

    controller.text = recognizedText.text;

    ///End busy state
    setState(() {
      _isBusy = false;
    });
  }
}