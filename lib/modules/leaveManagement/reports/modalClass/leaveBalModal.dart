class LeaveBalModal {
  LeaveData? leaveData;

  LeaveBalModal({this.leaveData});

  factory LeaveBalModal.fromJson(Map<String, dynamic> json) {
    return LeaveBalModal(
      leaveData: json['leaveData'] != null
          ? LeaveData.fromJson(json['leaveData'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (leaveData != null) {
      data['leaveData'] = leaveData!.toJson();
    }
    return data;
  }
}


class LeaveData {
  Map<String, LeaveDetail>? leaveDetails;
  LeaveTypeList? leaveTypeList;

  LeaveData({this.leaveDetails, this.leaveTypeList});

  factory LeaveData.fromJson(Map<String, dynamic> json) {
    final leaveDetails = <String, LeaveDetail>{};
    LeaveTypeList? leaveTypeList;

    json.forEach((key, value) {
      if (key == 'leaveTypeList') {
        leaveTypeList = LeaveTypeList.fromJson(value);
      } else if (value is Map<String, dynamic>) {
        leaveDetails[key] = LeaveDetail.fromJson(value);
      }
    });

    return LeaveData(
      leaveDetails: leaveDetails,
      leaveTypeList: leaveTypeList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (leaveDetails != null) {
      data.addAll(leaveDetails!.map((key, value) => MapEntry(key, value.toJson())));
    }
    if (leaveTypeList != null) {
      data['leaveTypeList'] = leaveTypeList!.toJson();
    }
    return data;
  }

  /// ✅ Function to parse & return clean leave balances map
  Map<String, dynamic> getParsedBalances() {
    final leaveBalances = <String, dynamic>{};

    final leaveTypeItems = leaveTypeList?.leaveTypelist ?? [];
    print("🧩 Final leaveDataMap keys: ${leaveDetails?.keys.toList()}");

    for (var typeItem in leaveTypeItems) {
      // Example: "Casual Leave-CL-789"
      final parts = typeItem.split('-');
      if (parts.length >= 3) {
        final typeCode = parts[1]; // e.g. "CL"
        final typeId = parts[2];   // e.g. "789"
        final matchedKey = "$typeCode-$typeId";

        print("🔍 Matching type=$typeCode -> matchedKey=$matchedKey");

        final data = leaveDetails?[matchedKey];

        leaveBalances[typeCode] = {
          "lwp": data?.lwp ?? 0.0,
          "leavesTaken": data?.leavesTaken ?? 0.0,
          "totalLeavesPending": data?.totalLeavesPending ?? 0.0,
          "currentYearLeaves": data?.currentYearLeaves ?? 0.0,
          "lastYearLeaves": data?.lastYearLeaves ?? 0.0,
        };
      }
    }

    print("✅ Final leaveBalances: $leaveBalances");
    return leaveBalances;
  }
}

class LeaveTypeList {
  List<String>? leaveTypelist;

  LeaveTypeList({this.leaveTypelist});

  factory LeaveTypeList.fromJson(Map<String, dynamic> json) {
    return LeaveTypeList(
      leaveTypelist: List<String>.from(json['leaveTypelist'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leaveTypelist': leaveTypelist,
    };
  }
}

class LeaveDetail {
  double? lwp;
  double? leavesTaken;
  double? totalLeavesPending;
  double? currentYearLeaves;
  double? lastYearLeaves;

  LeaveDetail({
    this.lwp,
    this.leavesTaken,
    this.totalLeavesPending,
    this.currentYearLeaves,
    this.lastYearLeaves,
  });

  factory LeaveDetail.fromJson(Map<String, dynamic> json) {
    return LeaveDetail(
      lwp: (json['lwp'] ?? 0).toDouble(),
      leavesTaken: (json['leavesTaken'] ?? 0).toDouble(),
      totalLeavesPending: (json['totalLeavesPending'] ?? 0).toDouble(),
      currentYearLeaves: (json['currentYearLeaves'] ?? 0).toDouble(),
      lastYearLeaves: (json['lastYearLeaves'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lwp': lwp,
      'leavesTaken': leavesTaken,
      'totalLeavesPending': totalLeavesPending,
      'currentYearLeaves': currentYearLeaves,
      'lastYearLeaves': lastYearLeaves,
    };
  }
}