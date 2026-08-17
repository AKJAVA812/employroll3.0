class WorkdoneReportModel {
  List<DataNew>? data;

  WorkdoneReportModel({this.data});

  WorkdoneReportModel.fromJson(Map<String, dynamic> json) {
    final source = json['content'] ?? json['data'];
    if (source is List) {
      data = <DataNew>[];
      for (var v in source) {
        if (v is Map) data!.add(DataNew.fromJson(Map<String, dynamic>.from(v)));
      }
    } else {
      data = <DataNew>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataNew {
  String? date;
  String? image;
  String? cMailId;
  String? cAddress;
  String? cName;
  String? cNumber;
  String? remark;
  String? time;

  DataNew(
      {this.date,
        this.image,
        this.cMailId,
        this.cAddress,
        this.cName,
        this.cNumber,
        this.remark,
        this.time});

  DataNew.fromJson(Map<String, dynamic> json) {
    final parsedTaskTime = DateTime.tryParse(json['taskTime']?.toString() ?? '');
    final taskTime = parsedTaskTime?.toLocal();
    date = json['date']?.toString() ??
        (taskTime == null
            ? ''
            : '${taskTime.day.toString().padLeft(2, '0')}-${taskTime.month.toString().padLeft(2, '0')}-${taskTime.year}');
    time = json['time']?.toString() ??
        (taskTime == null
            ? ''
            : '${taskTime.hour.toString().padLeft(2, '0')}:${taskTime.minute.toString().padLeft(2, '0')}');
    image = json['imageUrl']?.toString() ?? json['image']?.toString() ?? '';
    cMailId = json['customerEmailId']?.toString() ?? json['cMailId']?.toString() ?? '';
    cAddress = json['address']?.toString() ?? json['cAddress']?.toString() ?? '';
    cName = json['customerName']?.toString() ?? json['cName']?.toString() ?? 'Work Done';
    cNumber = json['customerContactNumber']?.toString() ?? json['cNumber']?.toString() ?? '';
    remark = json['taskDetails']?.toString() ??
        json['remark']?.toString() ??
        json['remarks']?.toString() ??
        json['description']?.toString() ??
        '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['image'] = image;
    data['cMailId'] = cMailId;
    data['cAddress'] = cAddress;
    data['cName'] = cName;
    data['cNumber'] = cNumber;
    data['remark'] = remark;
    data['time'] = time;
    return data;
  }
}
