import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/modules/claimAndReimbursement/claimItems/addExpense/addExpensePage.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../themes/empThemes.dart';

class HDRaisedTicketReply extends StatefulWidget {
  const HDRaisedTicketReply({Key? key}) : super(key: key);

  @override
  State<HDRaisedTicketReply> createState() => _HDRaisedTicketReplyState();
}

class _HDRaisedTicketReplyState extends State<HDRaisedTicketReply> {
  List<Message> messages = [
    Message(
      text: 'Yes Offcourse !',
      date: DateTime.now().subtract(Duration(days: 3, minutes: 3)),
      isSentByMe: true,
    ),
    Message(
      text: 'Yes Offcourse !',
      date: DateTime.now().subtract(Duration(days: 3, minutes: 4)),
      isSentByMe: false,
    ),
    Message(
      text: 'Yes Offcourse !',
      date: DateTime.now().subtract(Duration(days: 3, minutes: 5)),
      isSentByMe: true,
    ),
    Message(
      text: 'Yes Offcourse !',
      date: DateTime.now().subtract(Duration(days: 3, minutes: 6)),
      isSentByMe: false,
    ),
    Message(
      text: 'Yes Offcourse !',
      date: DateTime.now().subtract(Duration(days: 3, minutes: 7)),
      isSentByMe: true,
    ),
    Message(
      text: 'Yes Offcourse !',
      date: DateTime.now().subtract(Duration(days: 3, minutes: 8)),
      isSentByMe: false,
    ),
    Message(
      text: 'Yes Offcourse !',
      date: DateTime.now().subtract(Duration(days: 3, minutes: 9)),
      isSentByMe: true,
    ),
    Message(
      text: 'Yes Offcourse !',
      date: DateTime.now().subtract(Duration(days: 3, minutes: 10)),
      isSentByMe: false,
    ),
    Message(
      text: 'Yes Offcourse !',
      date: DateTime.now().subtract(const Duration(days: 3, minutes: 11)),
      isSentByMe: true,
    ),
    Message(
      text: 'Yes Offcourse !',
      date: DateTime.now().subtract(Duration(days: 3, minutes: 12)),
      isSentByMe: false,
    ),
    Message(
      text: 'Yes Offcourse !',
      date: DateTime.now().subtract(Duration(days: 3, minutes: 13)),
      isSentByMe: true,
    ),
  ].reversed.toList();

  final typedText = TextEditingController();
  var filePath = "Document";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    typedText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var titleName = "Query Mail Trail";
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: titleName.text.make(),
        ),
        body: Container(
          color: Mythemes.whitish,
          child: Column(
            children: [
              Container(
                color: Mythemes.whitish,
                padding: EdgeInsets.all(2.0),
                child: Card(
                  elevation: 0.5,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          "Ticket No.".text.make().px8().py2(),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "627738"
                                  .text
                                  .color(Mythemes.lightBluishColor)
                                  .sm
                                  .make()
                                  .px4(),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              "1 Year ago, Wed".text.sm.make().px8(),
                            ],
                          )),
                        ],
                      ),
                      Row(
                        children: [
                          "HRIS/Backend Query"
                              .text
                              .maxFontSize(12)
                              .make()
                              .px8(),
                        ],
                      ).py1(),
                      Row(
                        children: [
                          "Mobile No.".text.maxFontSize(12).make().px8(),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              "9899667445"
                                  .text
                                  .size(10)
                                  .textStyle(context.captionStyle)
                                  .make()
                            ],
                          ))
                        ],
                      ).py2(),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: GroupedListView<Message, DateTime>(
                reverse: true,
                order: GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                floatingHeader: true,
                elements: messages,
                groupBy: (message) => DateTime(
                  message.date.year,
                  message.date.month,
                  message.date.day,
                ),
                groupHeaderBuilder: (Message message) => SizedBox(
                  height: 40,
                  child: Center(
                    child: DateFormat.yMMMd().format(message.date).text.make(),
                  ),
                ),
                itemBuilder: (context, Message message) => Align(
                    alignment: message.isSentByMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: message.isSentByMe
                        ? Container(
                            padding: EdgeInsets.all(5.0),
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Mythemes.greyLight,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: message.text.text.make(),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(5.0),
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Mythemes.greyishade,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: message.text.text.make(),
                            ),
                          )),
              )),
              Container(
                padding: EdgeInsets.all(5.0),
                color: Mythemes.whitish,
                child: TextFormField(
                  controller: typedText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                            color: Mythemes.greyishade,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                            color: Mythemes.greyishade,
                          )),
                      prefixIcon: IconButton(
                        onPressed: () async {
                          final result = await FilePicker.platform
                              .pickFiles(allowMultiple: true);
                          if (result == null) return;

                          final file = result.files.first;
                          print('Bytes: ${file.bytes}');
                          print('Name: ${file.name}');
                          print('Size: ${file.size}');
                          print('Size: ${file.extension}');
                          print('Path: ${file.path}');

                          final newFile = await saveFilePermanently(file);
                          //openFiles(result.files);
                          final kb = file.size / 1024;
                          final mb = kb / 1024;
                          final fileSize = mb >= 1
                              ? '${mb.toStringAsFixed(2)} MB'
                              : '${kb.toStringAsFixed(2)} KB';
                          final extension = file.extension ?? 'none';
                          setState(() {
                            filePath = file.name;
                          });
                          final message = Message(
                              text: filePath,
                              date: DateTime.now(),
                              isSentByMe: true);
                          typedText.clear();
                          messages.add(message);
                        },
                        icon: Icon(
                          Icons.attach_file,
                          size: 22,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          final message = Message(
                              text: typedText.text,
                              date: DateTime.now(),
                              isSentByMe: true);
                          setState(() {
                            if (typedText.text.isEmpty) {
                              print("no chat");
                            }
                            typedText.clear();
                            messages.add(message);
                          });
                        },
                        icon: Icon(Icons.send),
                      ),
                      contentPadding: EdgeInsets.all(12),
                      hintText: 'Type your message here...'),

                  /*onFieldSubmitted: (text) {
                        final message = Message(text: text, date: DateTime.now(), isSentByMe: true);
                        setState(() {
                          messages.add(message);
                        });
                      },*/
                ),
              ),
            ],
          ),
        ),

        /*  bottomNavigationBar: Container(
          color: Mythemes.whitish,
          child: ButtonBar(
              alignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  return null;
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: 'Type your message here...'
                ),

                onFieldSubmitted: (text) {
                  final message = Message(text: text, date: DateTime.now(), isSentByMe: true);
                  setState(() {
                    messages.add(message);
                  });
                },

              ),
            ],
          )
        ),*/
      ),
    );
  }
}

void openFile(PlatformFile file) {
  OpenFile.open(file.path!);
  print('Bytes: ${file.name}');
  print('Size: ${file.size}');
  print('Size: ${file.extension}');
  print('Path: ${file.path}');
}

Future<File> saveFilePermanently(PlatformFile file) async {
  final appStorage = await getApplicationDocumentsDirectory();
  final newFile = File('${appStorage.path}/${file.name}');
  return File(file.path!).copy(newFile.path);
}

class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;

  const Message(
      {required this.text, required this.date, required this.isSentByMe});
}
