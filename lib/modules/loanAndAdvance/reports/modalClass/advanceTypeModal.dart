class AdvanceTypeListModal {
  List<Advancedata>? advancedata;

  AdvanceTypeListModal({this.advancedata});

  AdvanceTypeListModal.fromJson(Map<String, dynamic> json) {
    if (json['advancedata'] != null) {
      advancedata = <Advancedata>[];
      json['advancedata'].forEach((v) {
        advancedata!.add(Advancedata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.advancedata != null) {
      data['advancedata'] = this.advancedata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Advancedata {
  String? advanceId;
  String? advanceName;
  String? status;

  Advancedata({this.advanceId, this.advanceName, this.status});

  Advancedata.fromJson(Map<String, dynamic> json) {
    advanceId = json['advanceId'];
    advanceName = json['advanceName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['advanceId'] = this.advanceId;
    data['advanceName'] = this.advanceName;
    data['status'] = this.status;
    return data;
  }
}
