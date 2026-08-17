class OnboardBranchListModal {
  List<Data>? data;

  OnboardBranchListModal({this.data});

  OnboardBranchListModal.fromJson(Map<String, dynamic> json) {
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

  Data({this.isCheck, this.name, this.id});

  Data.fromJson(Map<String, dynamic> json) {
    isCheck = json['isCheck'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isCheck'] = isCheck;
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
