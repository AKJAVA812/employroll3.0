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
        data!.add(new Data.fromJson(v));
      });
    }
    distance = json['distance'];

    if (json['taskData'] != null) {
      taskData = <TaskData>[];
      json['taskData'].forEach((v) {
        taskData!.add(new TaskData.fromJson(v));
      });
    }
    dist = json['dist'];
    if (json['attData'] != null) {
      attData = <AttData>[];
      json['attData'].forEach((v) {
        attData!.add(new AttData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['distance'] = this.distance;

    if (this.taskData != null) {
      data['taskData'] = this.taskData!.map((v) => v.toJson()).toList();
    }
    data['dist'] = this.dist;
    if (this.attData != null) {
      data['attData'] = this.attData!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['tdate'] = this.tdate;
    data['lng'] = this.lng;
    data['tTime'] = this.tTime;
    data['lat'] = this.lat;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taskendTime'] = this.taskendTime;
    data['taskPhoto'] = this.taskPhoto;
    data['address'] = this.address;
    data['tasklat'] = this.tasklat;
    data['taskDate'] = this.taskDate;
    data['taskstartTime'] = this.taskstartTime;
    data['comment'] = this.comment;
    data['tasklng'] = this.tasklng;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inTime'] = this.inTime;
    data['outlat'] = this.outlat;
    data['inlat'] = this.inlat;
    data['outDate'] = this.outDate;
    data['outPhoto'] = this.outPhoto;
    data['outAddress'] = this.outAddress;
    data['inPhoto'] = this.inPhoto;
    data['outlng'] = this.outlng;
    data['inDate'] = this.inDate;
    data['inlng'] = this.inlng;
    data['inAddress'] = this.inAddress;
    data['outTime'] = this.outTime;
    return data;
  }
}
