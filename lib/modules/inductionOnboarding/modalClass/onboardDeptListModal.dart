class OnboardDeptListModal {
  List<Data>? data;

  OnboardDeptListModal({this.data});

  OnboardDeptListModal.fromJson(Map<String, dynamic> json) {
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
  bool? isCheck;
  String? name;
  int? id;
  String? status;

  Data({this.isCheck, this.name, this.id, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    isCheck = json['isCheck'];
    name = json['name'];
    id = json['id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isCheck'] = isCheck;
    data['name'] = name;
    data['id'] = id;
    data['status'] = status;
    return data;
  }
}
