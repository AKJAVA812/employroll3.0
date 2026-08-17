import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

//import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:velocity_x/velocity_x.dart';

import '../commanScreen/recognization_page.dart';
import '../themes/empThemes.dart';

class OCRPage extends StatefulWidget {
  const OCRPage({super.key});

  @override
  State<OCRPage> createState() => _OCRPageState();
}

class _OCRPageState extends State<OCRPage> {
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  var titleName = "OCR";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleName.text.make(),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () {
                  imagePickerModal(context,
                      onCameraTap: () {}, onGalleryTap: () {});
                  //_startScan();
                },
                child: "Scan Text".text.make()),
          ),
        ],
      ),
    );
  }

  void imagePickerModal(BuildContext context,
      {VoidCallback? onCameraTap, VoidCallback? onGalleryTap}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 120,
            child: Column(
              children: [
                OverflowBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                            onPressed: () {
                              pickImage(source: ImageSource.camera)
                                  .then((value) {
                                if (value != '') {
                                  imageCropperView(value, context)
                                      .then((value) {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) => RecognizePage(
                                          path: value,
                                        ),
                                      ),
                                    );
                                  });
                                }
                              });
                            },
                            child: "Camera".text.make())
                        .px8(),
                    ElevatedButton(
                        onPressed: () {
                          pickImage(source: ImageSource.gallery).then((value) {
                            if (value != '') {
                              imageCropperView(value, context).then((value) {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => RecognizePage(
                                      path: value,
                                    ),
                                  ),
                                );
                              });
                            }
                          });
                        },
                        child: "Gallery".text.make()),
                  ],
                )
              ],
            ),
          );
        });
  }

  //Image picker
  Future<String> pickImage({ImageSource? source}) async {
    final picker = ImagePicker();

    String path = '';

    try {
      final getImage = await picker.pickImage(source: source!);

      if (getImage != null) {
        path = getImage.path;
      } else {
        path = '';
      }
    } catch (e) {
      log(e.toString());
    }

    return path;
  }

  //Image crop
  Future<String> imageCropperView(String? path, BuildContext context) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path!,

      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Mythemes.lightBluishColor,
            toolbarWidgetColor: Mythemes.whitish,
            initAspectRatio: CropAspectRatioPreset.original,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedFile != null) {
      log("Image cropped");
      return croppedFile.path;
    } else {
      log("Do nothing");
      return '';
    }
  }
}
