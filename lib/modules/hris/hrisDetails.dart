import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:er_flutter_project/adminPage/adminDashboard/adminDashboard.dart';
import 'package:er_flutter_project/themes/empThemes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../../adminPage/modelClass/dashboardModel.dart';
import '../../adminPage/mssDashboard.dart';
import '../../commanScreen/allAPIList.dart';
import '../../commanScreen/commanNotificationPage.dart';
import '../../commanScreen/homePage.dart';
import '../../commanScreen/punchInOutScreen.dart';
import '../../commanScreen/routes.dart';
import '../../commanScreen/ujalaCreditWorkdone.dart';
import '../../profiles/profilePageWithHead.dart';
import '../../sharedPrefancePage/ShardPre.dart';


class HRISDetails extends StatefulWidget {
  const HRISDetails({Key? key}) : super(key: key);

  @override
  State<HRISDetails> createState() => _HRISDetailsState();
}

File? file;
var imageValue;
TextEditingController aadhar = TextEditingController();
TextEditingController pfNo = TextEditingController();
TextEditingController esicNo = TextEditingController();
TextEditingController bankAcc = TextEditingController();
TextEditingController ifscCode = TextEditingController();
TextEditingController bankAccName = TextEditingController();
TextEditingController dateOfBirth = TextEditingController();

Map<String, dynamic> mapResponse = {};

SessionManager shared = SessionManager();

String? sessionId;

Future<File> _fileFromImageUrl() async {
  final response = await http.get(Uri.parse('https://s3.ap-south-1.amazonaws.com/employroll.com/images/1705814809103.jpg'));
  //final responseNew = await http.get(Uri.parse('https://s3.ap-south-1.amazonaws.com/employroll.com/images/1707640420694.png'));

  final documentDirectory = await getApplicationDocumentsDirectory();
  file = File(join(documentDirectory.path, 'imagetest.png'));

  file!.writeAsBytes(response.bodyBytes);
  //imageValue!.writeAsBytes(responseNew.bodyBytes);

  return file!;
}


class _HRISDetailsState extends State<HRISDetails> {
  late String name=" ",
      designation="",
      mobileNo="",
      emailId="",
      dept="",
      branch="",
      urlImage="",
      dateOfjoin="";

  Future getUserDetails() async {

    urlImage= await shared.getProfileImage();
    name= await shared.getempName();
    emailId=await shared.getEmailId();
    dept=await shared.getDept();
    branch=await shared.getBranch();
    dateOfBirth.text=await shared.getDob();
    mobileNo=await shared.getMobileNo();
    designation=await shared.getDesignation();
    aadhar.text= await shared.getAadhar();
    pfNo.text= await shared.getPfNo();
    esicNo.text= await shared.getEsicNo();
    bankAcc.text= await shared.getBankAcc();
    ifscCode.text= await shared.getIfscCode();
    bankAccName.text= await shared.getBankName();
    dateOfjoin=await shared.getDoj();

    print('Image: ${urlImage.text}');
    print('Employee Name: ${name.text}');
    print('Email Id: ${emailId.text}');
    print('Department: ${dept.text}');
    print('Branch: ${branch.text}');
    print('Date of Birth: ${dateOfBirth.text}');
    print('Mobile No: ${mobileNo.text}');
    print('Designation: ${designation.text}');
    print('Aadhar No.: ${aadhar.text}');
    print('PF No.: ${pfNo.text}');
    print('ESIC No.: ${esicNo.text}');
    print('Bank A/c: ${bankAcc.text}');
    print('IFSC Code: ${ifscCode.text}');
    print('Bank Name: ${bankAccName.text}');
    print('Date of Joining: ${dateOfjoin.text}');
    setState(() {

    });

  }
  final ImagePicker _picker = ImagePicker();
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
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          try{
                            //ImagePicker picker = ImagePicker();
                            imageValue = await _picker.pickImage(source: ImageSource.camera);

                            //picker.dispose();
                            if(imageValue==null) return;
                            print("Heloo ji ""$imageValue");
                            setState(() {
                              final imagePath= File(imageValue!.path);
                              //this._workDoneImage=imagePath;
                              file= File(imageValue!.path);
                              urlImage = file.toString();
                              print("IMAGE Change - $urlImage");
                            });
                            imageValue=null;
                            //imageCache.clear();

                          }on Exception catch (e) {
                            print('failed to upload: $e');
                          }
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: "Camera".text.make())
                        .px8(),
                    ElevatedButton(
                        onPressed: () async{
                          try{
                            //ImagePicker picker = ImagePicker();
                            imageValue = await _picker.pickImage(source: ImageSource.gallery);

                            //picker.dispose();
                            if(imageValue==null) return;
                            print("Heloo ji ""$imageValue");
                            setState(() {
                              final imagePath= File(imageValue!.path);
                              //this._workDoneImage=imagePath;
                              file= File(imageValue!.path);
                              urlImage = file.toString();
                              print("IMAGE Change - $urlImage");

                            });
                            imageValue=null;
                            //imageCache.clear();

                          }on Exception catch (e) {
                            print('failed to upload: $e');
                          }
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: "Gallery".text.make()),
                  ],
                )
              ],
            ),
          );
        });
  }

  String dateOfBir="";
  String dateOfJoinn="";
  final TextEditingController _dateController = TextEditingController();
  @override
  void initState() {
    getSharedPrfanceList();
    getUserDetails();
    _fileFromImageUrl();
    // TODO: implement initState
    super.initState();
  }
  int pageIndex = 0;
  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: Mythemes.whitish,
        appBar: AppBar(
          elevation: 0.5,
          title: "Profile".text.make(),
          leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        /* body: Container(
          color: context.canvasColor,
          child: Center(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  CircleAvatar(
                    maxRadius: 65,
                    backgroundImage: AssetImage("assets/images/avtar7.png"),
                  ).h15(context),

                  Expanded(child: VxArc(
                    height: 40.0,
                    edge: VxEdge.TOP,
                    arcType: VxArcType.CONVEX,
                    child: Container(
                      color: context.cardColor,
                      width: context.screenWidth,
                      child: Column(
                        children: [
                          "Bharat Rajora".text.xl2.color(context.accentColor).make(),
                          "Designer".text.textStyle(context.captionStyle).make(),
                        ],
                      ),
                    ),
                  ))

                ],
              ),
            ),
          ),
        ),*/
        body: Stack(
          alignment: Alignment.center,
          children: [
            RefreshIndicator(
              onRefresh: () {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (a, b, c) =>
                          HRISDetails(),
                      transitionDuration: Duration(seconds: 1),
                      maintainState: true,
                    ));
                return Future.value(false);
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.all(20),
                      // child: "Profile".text.make(),

                    ),
                    /*Container(
                      padding: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width/2,
                      height: MediaQuery.of(context).size.width/2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Mythemes.lightBluishColor, width: 3),
                        shape: BoxShape.circle,
                        color: Mythemes.whitish,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(urlImage),
                        ),
                      ),

                    ),*/
                    urlImage == null ?
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width/2,
                      height: MediaQuery.of(context).size.width/2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Mythemes.lightBluishColor, width: 3),
                        shape: BoxShape.circle,
                        color: Mythemes.whitish,
                        image: DecorationImage(
                          fit: BoxFit.scaleDown,
                          image:  NetworkImage("https://s3.ap-south-1.amazonaws.com/employroll.com/images/1705814809103.jpg"),
                          /*FileImage(file!)*/
                        ),
                      ),

                    )
                        :
                    /*Container(
                      padding: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width/2,
                      height: MediaQuery.of(context).size.width/2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Mythemes.lightBluishColor, width: 3),
                        shape: BoxShape.circle,
                        color: Mythemes.whitish,
                        image: DecorationImage(
                          fit: BoxFit.scaleDown,
                          image:  NetworkImage(urlImage),
                          *//*FileImage(file!)*//*
                        ),
                      ),

                    ),*/
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            border: Border.all(color: Mythemes.lightBluishColor, width: 3),
                            shape: BoxShape.circle,
                            color: Mythemes.whitish,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: file != null
                                  ? FileImage(file!) as ImageProvider   // ✅ Local file
                                  : NetworkImage(urlImage),             // ✅ Fallback to network image
                            ),
                          ),
                        ),

                        /// Positioned edit button
                        Positioned(
                          bottom: 8,
                          right: MediaQuery.of(context).size.width / 2 - 60, // auto-aligns near circle border
                          child: CircleAvatar(
                            backgroundColor: Mythemes.successColor,
                            radius: 20,
                            child: IconButton(
                              icon: Icon(Icons.edit, color: Colors.white, size: 18),
                              onPressed: () {
                                imagePickerModal(context,
                                    onCameraTap: () {}, onGalleryTap: () {});
                                // TODO: Open image picker or profile update method
                                print("Edit profile picture clicked!");
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            children: [
                              name.text.xl2.make(),
                              designation.text.textStyle(context.captionStyle).make(),
                            ],
                          ),
                        )

                    ),
                    /*Row(
                      children: [
                        Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                    tooltip: 'Attach Image',
                                    onPressed: () async {
                                      imagePickerModal(context,
                                          onCameraTap: () {}, onGalleryTap: () {});
                                    },
                                    icon: Icon(
                                      Icons.edit, color: Mythemes.successColor,
                                    )
                                )

                              ],
                            )
                        ),
                      ],
                    ),*/

                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: TextEditingController(text: emailId),
                              enabled: false,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Mythemes.lightBluishColor,
                                ),
                                  hintText: "Email Id",
                                  labelText: "Email Id"
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: TextEditingController(text: mobileNo),
                              enabled: false,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Mythemes.lightBluishColor,
                                ),
                                  hintText: "Mobile No.",
                                  labelText: "Mobile No."
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: TextEditingController(text: dept),
                              enabled: false,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                prefixIcon: Icon(
                                  Icons.work,
                                  color: Mythemes.lightBluishColor,
                                ),
                                  hintText: "Department",
                                  labelText: "Department"
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: TextEditingController(text: branch),
                              enabled: false,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                prefixIcon: Icon(
                                  Icons.apartment,
                                  color: Mythemes.lightBluishColor,
                                ),
                                  hintText: "Branch",
                                  labelText: "Branch"
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              onTap: () async{
                                DateTime? date = DateTime.now();
                                FocusScope.of(context).requestFocus(new FocusNode());

                                date = await showDatePicker(
                                    context: context,
                                    initialDate: date,
                                    firstDate:DateTime(1947),
                                    lastDate: DateTime.now().add(Duration(days: 0)));
                                setState(() {
                                  dateOfBir = DateFormat('dd-MM-yyyy').format(date!);
                                  dateOfBirth.text = DateFormat("dd-MM-yyyy").format(date!);

                                  //  DateFormat.yMd().format(date!).toString();
                                });

                                print(date);
                              },
                              controller: dateOfBirth,
                              enabled: true,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                prefixIcon: Icon(
                                  Icons.date_range_rounded,
                                  color: Mythemes.lightBluishColor,
                                ),
                                  hintText: "Date of Birth",
                                  labelText: "Date of Birth"
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              onTap: () async{
                                DateTime? date = DateTime.now();
                                FocusScope.of(context).requestFocus(new FocusNode());

                                date = await showDatePicker(
                                    context: context,
                                    initialDate: date,
                                    firstDate:DateTime(1947),
                                    lastDate: DateTime.now().add(Duration(days: 0)));
                                setState(() {
                                  dateOfJoinn = DateFormat('dd-MM-yyyy').format(date!);
                                  dateOfjoin = DateFormat("dd-MM-yyyy").format(date!);

                                  //  DateFormat.yMd().format(date!).toString();
                                });

                                print(date);
                              },
                              controller: TextEditingController(text: dateOfjoin),
                              enabled: false,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.edit_calendar,
                                    color: Mythemes.lightBluishColor,
                                  ),
                                  hintText: "Date of Joining",
                                  labelText: "Date of Joining"
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: aadhar,
                              enabled: true,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.credit_card_outlined,
                                    color: Mythemes.lightBluishColor,
                                  ),
                                  hintText: "Aadhar No.",
                                  labelText: "Aadhar No."
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: pfNo,
                              enabled: true,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Mythemes.lightBluishColor,
                                  ),
                                  hintText: "PF No.",
                                  labelText: "PF No."
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: esicNo,
                              enabled: true,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.document_scanner_rounded,
                                    color: Mythemes.lightBluishColor,
                                  ),
                                  hintText: "ESIC No.",
                                  labelText: "ESIC No."
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: bankAcc,
                              enabled: true,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.confirmation_num,
                                    color: Mythemes.lightBluishColor,
                                  ),
                                  hintText: "Bank A/c No.",
                                  labelText: "Bank A/c No."
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: ifscCode,
                              enabled: true,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.code,
                                    color: Mythemes.lightBluishColor,
                                  ),
                                  hintText: "IFSC Code",
                                  labelText: "IFSC Code"
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: bankAccName,
                              enabled: true,
                              //initialValue: "${branchName}",
                              decoration:  InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.attach_money_sharp,
                                    color: Mythemes.lightBluishColor,
                                  ),
                                  hintText: "Bank Name",
                                  labelText: "Bank Name"
                              ),
                            ),
                          ),


                          /*Container(
                            height: 68,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.email, size: 25, color: Mythemes.lightBluishColor,).py16(),
                                  ],
                                ).px16(),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child: "Email Id".text.align(TextAlign.left).color(Mythemes.greyish).make(),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child: emailId.text.letterSpacing(1).bold.make(),
                                        ),
                                      )


                                    ],
                                  ).px8(),
                                ),


                              ],
                            ),

                          ),
                          Container(
                            height: 68,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.phone, size: 25, color: Mythemes.lightBluishColor,).py16(),
                                  ],
                                ).px16(),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child: "Mobile No.".text.align(TextAlign.left).color(Mythemes.greyish).make(),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child: mobileNo.text.letterSpacing(1).bold.make(),
                                        ),
                                      ),


                                    ],
                                  ).px8(),
                                ),

                              ],
                            ),
                          ),
                          Container(
                            height: 68,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.work, size: 25, color: Mythemes.lightBluishColor,).py16(),
                                  ],
                                ).px16(),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child: "Department".text.align(TextAlign.left).color(Mythemes.greyish).make(),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child: dept.text.letterSpacing(1).bold.make(),
                                        ),
                                      ),


                                    ],
                                  ).px8(),
                                ),

                              ],
                            ),
                          ),
                          Container(
                            height: 68,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.apartment, size: 25, color: Mythemes.lightBluishColor,).py16(),
                                  ],
                                ).px16(),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child: "Branch".text.align(TextAlign.left).color(Mythemes.greyish).make(),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child: branch.text.letterSpacing(1).bold.make(),
                                        ),
                                      ),


                                    ],
                                  ).px8(),
                                ),

                              ],
                            ),
                          ),
                          Container(
                            height: 68,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.date_range, size: 25, color: Mythemes.lightBluishColor,).py16(),
                                  ],
                                ).px16(),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child: "Date Of Birth".text.align(TextAlign.left).color(Mythemes.greyish).make(),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                            child:
                                            DateFormat("dd-MM-yyyy")
                                                .format(DateTime.parse(dateOfBirth)).text.letterSpacing(1).bold.make()
                                          //dateOfBirth.text.letterSpacing(1).bold.make(),
                                        ),
                                      ),
                                    ],
                                  ).px8(),
                                )

                              ],
                            ),
                          ),*/
                        ],
                      ),
                    ),

                    Container(
                      height: 90,
                      color: context.cardColor,
                      child: ButtonBar(
                          alignment: MainAxisAlignment.center,
                          buttonPadding: Vx.mOnly(right: 16),
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                updateHRISDet(
                                    sessionId!,
                                    aadhar.text,
                                    bankAcc.text,
                                    bankAccName.text,
                                    esicNo.text,
                                    ifscCode.text,
                                    pfNo.text,
                                    dateOfBirth.text
                                );

                                print(aadhar.text);
                                print(bankAcc.text);
                                print(bankAccName.text);
                                print(esicNo.text);
                                print(ifscCode.text);
                                print(pfNo.text);
                                print(dateOfBirth.text);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Mythemes.successColor),
                              ),
                              child: "Save".text.make(),
                            ).wh(150, 40).py12()
                          ]),
                    ),




                  ],
                ),
              ),
            ),
            /*Padding(padding: EdgeInsets.only(bottom: 270, left: 184),
              child: CircleAvatar(
                backgroundColor: Mythemes.blackish,
                child: IconButton(
                  icon: Icon(
                      Icons.edit,
                    color: Mythemes.whitish,
                  ),
                  onPressed: () {},

                ),
              ),

            ),*/

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
              //Navigator.of(context, rootNavigator: true).pop();
              print('home tab');
            }
            if(index==1){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PunchInOUtActivity()));
              //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
              print('Workflow');
            }
           /* if(index==2){
              Navigator.pushNamed(context, MyRoutings.leaveManageReportRoute);
              print('Leave');
            }*/
            if(index==2){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MSSDashboard(DashboardModel()))
              );
              //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
              print('Dashboard');
            }
            if(index==4){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePageNew())
              );
              //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
              print('Profile');
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
              icon: Icon(Icons.manage_accounts_outlined),
              label: 'Workflow',
            ),
           /* BottomNavigationBarItem(
              icon: Icon(Icons.group_off),
              label: 'Leave',
            ),*/
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_customize),
              label: 'Dashboard',
              //backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
              //backgroundColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateHRISDet(String sessionId, String? aadhar, String? bankAcc, String? bankAccName, String? esicNo, String? ifscCode, String? pfNo, String? dateOfBirth) async {
    String conn = ApiDetails.server;
    String apiUrl = ApiDetails.updateHRISApi;
    CommonNotificationPage.showLoaderDialog(this.context);
    var urlapi = Uri.parse("$conn$apiUrl?"
        "sessionId=$sessionId&"
        "aadharNumber=$aadhar&"
        "accountNo=$bankAcc&"
        "bankName=$bankAccName&"
        "esicNumber=$esicNo&"
        "ifscCode=$ifscCode&"
        "pfNumber=$pfNo&"
        "dob=$dateOfBirth"
    );
    final response = await http.post(urlapi);

    print('URL ${response.request}');
    if (response.statusCode == 200) {
      var responseResult = response.body;
      print('success $responseResult');
      Navigator.pop(this.context);
      mapResponse = json.decode(response.body);
      String result = mapResponse['result'].toString();
      String status = mapResponse['status'].toString();
      String reason = mapResponse['reason'].toString();
      print('result both $result $reason');
      print('result${result}');
      if (status.compareToIgnoringCase("success") == 0) {
        showDialgSucess1(
            this.context, result.upperCamelCase + " ", "Success");
      } else if (status.compareToIgnoringCase("error") == 0) {
        showDialgSucess1(
            this.context, result.upperCamelCase, " Error ");
      }
    }
  }

  Future getSharedPrfanceList() async {
    sessionId = await shared!.getSessionId();
  }

  showDialgSucess1(BuildContext context, result, alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          )),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(child: Text(alert)),
        ],
      ),
      content: Text(result),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {

            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pop(context);
          },
          child: Text("Ok"),
        ),
      ],
      elevation: 24.0,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}

class CurvedHeaderContainer extends CustomPainter{

  @override
  void paint(Canvas canvas,Size size ){
    Paint paint=Paint()..color= const Color(0xff00b0ff);
    Path path=Path()
      ..relativeLineTo(0, 130)
      ..quadraticBezierTo(size.width/2, 225, size.width, 130)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);

    @override
    bool shouldRepaint(CustomPainter oldDelegate)=>false;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
