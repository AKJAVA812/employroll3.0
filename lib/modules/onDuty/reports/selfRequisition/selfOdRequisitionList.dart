import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../adminPage/mssDashboard.dart';
import '../../../../commanScreen/allAPIList.dart';
import '../../../../commanScreen/punchInOutScreen.dart';
import '../../../../commanScreen/routes.dart';
import '../../../../ess/myAllReports.dart';
import '../../../../main.dart';
import '../../../../themes/empThemes.dart';
import 'package:er_flutter_project/services/mobile_api_foundation.dart';
import '../../../timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import 'modalClass/selfOdReqListModal.dart';

class SelfODRequisitionList extends StatefulWidget {
  final String startDate;
  final String endDate;

  const SelfODRequisitionList({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<SelfODRequisitionList> createState() =>
      _SelfODRequisitionListState(startDate, endDate);
}

class _SelfODRequisitionListState extends State<SelfODRequisitionList>
    with RouteAware {
  String startDate;
  String endDate;
  SelfOdReqListModal? selfOdReqListLabel;
  bool isLoading = false;
  var length;

  _SelfODRequisitionListState(this.startDate, this.endDate);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    // âœ… Called when coming back from Form Page
    _loadReport();
    super.didPopNext();
  }

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _date = startDate.isEmpty
        ? DateTime(today.year, today.month, 1)
        : DateTime.tryParse(startDate) ?? DateTime(today.year, today.month, 1);
    _newdate = endDate.isEmpty
        ? today
        : DateTime.tryParse(endDate) ?? today;
    startDate = DateFormat('yyyy-MM-dd').format(_date);
    endDate = DateFormat('yyyy-MM-dd').format(_newdate);
    _fromDateController.text = DateFormat('dd-MM-yyyy').format(_date);
    _toDateController.text = DateFormat('dd-MM-yyyy').format(_newdate);
    changeDates = false;
    changeNewDate = false;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadReport());
  }

  Future<void> _loadReport() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    final value = await getSelfOdReqList(startDate, endDate);
    if (!mounted) return;
    setState(() {
      selfOdReqListLabel = value;
      isLoading = false;
    });
  }

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  DateTime _date = DateTime.now();

  bool changeDates = true;
  bool changeNewDate = true;

  Future<Null> _selectDate(BuildContext context) async {
    DateTime? datePicker = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1947),
      lastDate: DateTime.now().add(Duration(days: 0)),
    );

    if (datePicker != null && datePicker != _date) {
      setState(() {
        changeDates = false;
        _date = datePicker;
        startDate = DateFormat('yyyy-MM-dd').format(_date);
        setState(() {
          //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
          _fromDateController.text = DateFormat("dd-MM-yyyy").format(_date);
        });
      });
    }
  }

  DateTime _newdate = (DateTime.now());
  Future<Null> _selectToDate(BuildContext context) async {
    DateTime? newDatePicker = await showDatePicker(
      context: context,
      initialDate: _newdate,
      firstDate: DateTime(1947),
      lastDate: DateTime.now().add(Duration(days: 0)),
    );

    if (newDatePicker != null && newDatePicker != _newdate) {
      setState(() {
        changeNewDate = false;
        _newdate = newDatePicker;
        endDate = DateFormat('yyyy-MM-dd').format(_newdate);
        setState(() {
          //singleDateString = DateFormat('dd-MM-yyyy').format(date!);
          _toDateController.text = DateFormat("dd-MM-yyyy").format(_newdate);
        });
      });
    }
  }

  Future<SelfOdReqListModal> getSelfOdReqList(
    String fromDate,
    String toDate,
  ) async {
    final foundation = MobileApiFoundation.instance;
    try {
      final response = await foundation.get(
        ApiDetails.mobileOdReport,
        queryParameters: <String, Object?>{
          'fromDate': fromDate,
          'toDate': toDate,
          'page': 0,
          'size': 100,
        },
        headers: await foundation.authHeaders(),
        tag: 'OD_REQUISITION_REPORT',
      );
      final body = foundation.decodeMap(response.body);
      if (!foundation.isSuccess(response)) {
        throw MobileApiException(
          'OD_REQUISITION_REPORT_FAILED',
          message: body['message']?.toString(),
          statusCode: response.statusCode,
        );
      }
      return SelfOdReqListModal.fromJson(body);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is MobileApiException
                  ? (error.message ?? 'Unable to load OD requests.')
                  : 'Unable to load OD requests.',
            ),
          ),
        );
      }
      return SelfOdReqListModal(result: 'error', listdata: <Listdata>[]);
    }
  }

  showNodata(BuildContext buildContext, result, reason) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Text(result),
        ],
      ),
      content: Text(reason),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(buildContext, rootNavigator: true).pop();
            //Navigator.pop(buildContext);
          },
          child: Text("Ok"),
        ),
      ],
      elevation: 24.0,
    );
    showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  int pageIndex = 0;
  int currentIndex = 3;
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(title: "My OD Requests".text.make()),
        body: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child:
                        TextFormField(
                          onTap: () async {
                            _selectDate(context);
                          },
                          readOnly: true,
                          enabled: true,
                          controller: _fromDateController,
                          // initialValue: "Head Office",
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.calendar_month, size: 18),
                            enabledBorder: UnderlineInputBorder(
                              //<-- SEE HERE
                              borderSide: BorderSide(
                                width: 1,
                                color: Mythemes.blackishade,
                              ),
                            ),
                            labelText: "From Date",
                            hintStyle: TextStyle(fontSize: 12),
                            contentPadding: EdgeInsets.all(5),
                            /*border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(8))),*/
                            // labelText: "Location",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Mythemes.blackish,
                            ),
                          ),
                        ).p8(),
                  ),

                  Expanded(
                    child:
                        TextFormField(
                          onTap: () async {
                            _selectToDate(context);
                          },
                          readOnly: true,
                          enabled: true,
                          controller: _toDateController,
                          // initialValue: "Head Office",
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.calendar_month, size: 18),
                            enabledBorder: UnderlineInputBorder(
                              //<-- SEE HERE
                              borderSide: BorderSide(
                                width: 1,
                                color: Mythemes.blackishade,
                              ),
                            ),
                            labelText: "To Date",
                            hintStyle: TextStyle(fontSize: 12),
                            contentPadding: EdgeInsets.all(5),
                            /*border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(8))),*/
                            // labelText: "Location",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Mythemes.blackish,
                            ),
                          ),
                        ).p8(),
                  ),
                ],
              ).pLTRB(0, 0, 0, 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_date.compareTo(_newdate) > 0) {
                        return setState(() {
                          AlertDialog(
                            content:
                                "Please select valid date range".text.make(),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please Select Valid Date Range "),
                            ),
                          );
                        });
                      }

                      if (changeDates == false && changeNewDate == false) {
                        bool result =
                            await InternetConnectionChecker().hasConnection;
                        if (result == false) {
                          setState(() {
                            AlertDialog(
                              content:
                                  "Please check your internet connection".text
                                      .make(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Please check your Internet connection.",
                                ),
                              ),
                            );
                          });
                        } else {
                          await _loadReport();
                        }
                      } else {
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please Select Date Range "),
                            ),
                          );
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Mythemes.lightBluishColor,
                      ),
                    ),
                    child: "Submit".text.make(),
                  ).wh(120, 45).py(12),
                ],
              ),
              Expanded(
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : selfOdReqListLabel == null
                        ? Center(child: "Please select date range.".text.make())
                        : getSelfOdRequisitionList(selfOdReqListLabel!),
              ),
            ],
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          iconSize: 25,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          onTap: (index) {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PunchInOUtActivity(selectedIndex: 0),
                ),
              );
              //Navigator.pop(context);
            }
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PunchInOUtActivity(selectedIndex: 1),
                ),
              );
              //Navigator.pushNamed(context, MyRoutings.timeAttRoute);
            }
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GetAttendanceDet(showAppBar: true),
                ),
              );
            }
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyAllReportsPage(showAppBar: true),
                ),
              );

              //Navigator.pushNamed(context, MyRoutings.mssDashboardRoute);
            }
            if (index == 4) {
              Navigator.pushNamed(
                context,
                MyRoutings.essDashboardNavigateRoute,
              );

              //Navigator.pushNamed(context, MyRoutings.profilePageHeadRoute);
            }
            /*if(index==3){
                title="Notifications";
              }*/
            setState(() => currentIndex = index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts_outlined),
              label: 'Workflow',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.app_badge_fill),
              label: 'My Requests',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.doc_chart),
              label: 'My Reports',
              //backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
              //backgroundColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  var statusColor;
  showNullDialog(BuildContext buildContext, result, alert) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      title: Row(
        children: [
          //Icon(Icons.warning),
          Expanded(child: Text(alert, style: TextStyle(fontSize: 18))),
        ],
      ),
      content: Text(result, style: TextStyle(fontSize: 14)),
      titlePadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      buttonPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(buildContext, rootNavigator: true).pop();
            //Navigator.pop(buildContext);
          },
          child: Container(child: Text("Ok")),
        ),
      ],
      elevation: 24.0,
    );
    showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  Future<void> _showImagePreview(String imageUrl) async {
    if (imageUrl.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image is available for this OD request.')),
      );
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.sizeOf(dialogContext).height * 0.72,
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) => progress == null
                      ? child
                      : const Center(child: CircularProgressIndicator()),
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Text('Unable to load this image.'),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: IconButton.filled(
                tooltip: 'Close',
                onPressed: () => Navigator.of(dialogContext).pop(),
                icon: const Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getSelfOdRequisitionList(SelfOdReqListModal selfOdReqListModal) {
    if (selfOdReqListModal.listdata == null ||
        selfOdReqListModal.listdata!.isEmpty) {
      return const Center(child: Text('No OD requests found.'));
    }
    return ListView.builder(
      padding: EdgeInsets.all(5.0),
      itemCount:
          selfOdReqListModal.listdata != null
              ? selfOdReqListModal.listdata!.length
              : 0,
      shrinkWrap: true,
      itemBuilder: (context, itemCount) {
        length = selfOdReqListModal.listdata!.length;
        var statusCheck =
            selfOdReqListModal.listdata![itemCount].approvalstatus;
        if (statusCheck == 'Approved') {
          statusColor = Mythemes.successColor;
        } else if (statusCheck == 'DisApproved') {
          statusColor = Mythemes.dangerColor;
        } else {
          statusColor = Mythemes.alertColor;
        }
        if (length == null) {
          return showNullDialog(
            context,
            "${"There is no data avialable.".upperCamelCase} ",
            "Alert Message",
          );
        }

        return InkWell(
          onTap: () {
            length = selfOdReqListModal.listdata!.length;
            if (length == null) {
              return showNullDialog(
                context,
                "${"There is no data avialable.".upperCamelCase} ",
                "Alert Message",
              );
            }
            /* Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                  OdApproveDisapproveReq(pendingOdReqList, itemCount)));*/
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: Avatar | Name + address | Status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      GestureDetector(
                        onTap: () => _showImagePreview(
                          selfOdReqListModal.listdata![itemCount].image ?? '',
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey.shade200,
                          child: ClipOval(
                            child: Image.network(
                              selfOdReqListModal.listdata![itemCount].image ?? "",
                              fit: BoxFit.cover,
                              width: 56,
                              height: 56,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/avtar7.png',
                                  fit: BoxFit.cover,
                                  width: 56,
                                  height: 56,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Name + address (left, expandable)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            Text(
                              selfOdReqListModal.listdata![itemCount].name
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Address row with icon. The Expanded text prevents overflow and ellipsizes.
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    selfOdReqListModal
                                        .listdata![itemCount]
                                        .odaddress
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.chat_bubble_outline,
                                  size: 16,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    selfOdReqListModal
                                        .listdata![itemCount]
                                        .remark
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Status (right aligned, stays vertically at the top)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            selfOdReqListModal
                                .listdata![itemCount]
                                .approvalstatus
                                .toString(),
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Remark row
                  /*Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.teal),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            foundDataNewMSS![itemCount].remark.toString(),
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),*/
                  const SizedBox(height: 12),
                  const Divider(height: 1),

                  const SizedBox(height: 10),

                  // Bottom icons row (In/Out + Date)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Left block - In/Out and time
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.touch_app,
                              size: 32,
                              color: Mythemes.lightBluishColor,
                            ),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selfOdReqListModal.listdata![itemCount].odtype
                                      .toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  selfOdReqListModal.listdata![itemCount].odtime
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Right block - Date
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.date_range,
                              size: 32,
                              color: Mythemes.lightBluishColor,
                            ),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  DateFormat("dd-MM-yyyy").format(
                                    DateTime.parse(
                                      selfOdReqListModal
                                          .listdata![itemCount]
                                          .date
                                          .toString(),
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SearchItems extends SearchDelegate {
  List<String> searchTerms = [];

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(title: Text(result));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(title: Text(result));
      },
    );
  }
}
