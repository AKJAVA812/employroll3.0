class HistoryTrackingModal {
  List<Data>? data;
  String? distance;
  List<Null>? geofencedata;
  List<TaskData>? taskData;
  double? dist;
  List<AttData>? attData;

  HistoryTrackingModal(
      {this.data,
        this.distance,
        this.geofencedata,
        this.taskData,
        this.dist,
        this.attData});

  HistoryTrackingModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    distance = json['distance'];

    if (json['taskData'] != null) {
      taskData = <TaskData>[];
      json['taskData'].forEach((v) {
        taskData!.add(TaskData.fromJson(v));
      });
    }
    dist = json['dist'];
    if (json['attData'] != null) {
      attData = <AttData>[];
      json['attData'].forEach((v) {
        attData!.add(AttData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['distance'] = distance;

    if (taskData != null) {
      data['taskData'] = taskData!.map((v) => v.toJson()).toList();
    }
    data['dist'] = dist;
    if (attData != null) {
      data['attData'] = attData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? date;
  String? tdate;
  double? lng;
  String? tTime;
  double? lat;

  Data({this.date, this.tdate, this.lng, this.tTime, this.lat});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    tdate = json['tdate'];
    lng = json['lng'];
    tTime = json['tTime'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['tdate'] = tdate;
    data['lng'] = lng;
    data['tTime'] = tTime;
    data['lat'] = lat;
    return data;
  }
}

class TaskData {
  String? taskendTime;
  String? taskPhoto;
  String? address;
  var tasklat;
  String? taskDate;
  String? taskstartTime;
  String? comment;
  var tasklng;

  TaskData(
      {this.taskendTime,
        this.taskPhoto,
        this.address,
        this.tasklat,
        this.taskDate,
        this.taskstartTime,
        this.comment,
        this.tasklng});

  TaskData.fromJson(Map<String, dynamic> json) {
    taskendTime = json['taskendTime'];
    taskPhoto = json['taskPhoto'];
    address = json['address'];
    tasklat = json['tasklat'];
    taskDate = json['taskDate'];
    taskstartTime = json['taskstartTime'];
    comment = json['comment'];
    tasklng = json['tasklng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taskendTime'] = taskendTime;
    data['taskPhoto'] = taskPhoto;
    data['address'] = address;
    data['tasklat'] = tasklat;
    data['taskDate'] = taskDate;
    data['taskstartTime'] = taskstartTime;
    data['comment'] = comment;
    data['tasklng'] = tasklng;
    return data;
  }
}

class AttData {
  String? inTime;
  var outlat;
  var inlat;
  String? outDate;
  String? outPhoto;
  String? outAddress;
  String? inPhoto;
  var outlng;
  String? inDate;
  var inlng;
  String? inAddress;
  String? outTime;

  AttData(
      {this.inTime,
        this.outlat,
        this.inlat,
        this.outDate,
        this.outPhoto,
        this.outAddress,
        this.inPhoto,
        this.outlng,
        this.inDate,
        this.inlng,
        this.inAddress,
        this.outTime});

  AttData.fromJson(Map<String, dynamic> json) {
    inTime = json['inTime'];
    outlat = json['outlat'];
    inlat = json['inlat'];
    outDate = json['outDate'];
    outPhoto = json['outPhoto'];
    outAddress = json['outAddress'];
    inPhoto = json['inPhoto'];
    outlng = json['outlng'];
    inDate = json['inDate'];
    inlng = json['inlng'];
    inAddress = json['inAddress'];
    outTime = json['outTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inTime'] = inTime;
    data['outlat'] = outlat;
    data['inlat'] = inlat;
    data['outDate'] = outDate;
    data['outPhoto'] = outPhoto;
    data['outAddress'] = outAddress;
    data['inPhoto'] = inPhoto;
    data['outlng'] = outlng;
    data['inDate'] = inDate;
    data['inlng'] = inlng;
    data['inAddress'] = inAddress;
    data['outTime'] = outTime;
    return data;
  }
}
