class ShiftListModal {
  List<Data>? data;

  ShiftListModal({this.data});

  ShiftListModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
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

class Data {
  String? shiftName;
  int? shiftId;
  int? branchId;

  Data({this.shiftName, this.shiftId, this.branchId});

  Data.fromJson(Map<String, dynamic> json) {
    shiftName = json['shiftName'];
    shiftId = json['shiftId'];
    branchId = json['branchId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shiftName'] = shiftName;
    data['shiftId'] = shiftId;
    data['branchId'] = branchId;
    return data;
  }
}
