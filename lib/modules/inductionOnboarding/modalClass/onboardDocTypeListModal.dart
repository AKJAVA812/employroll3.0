class OnboardDocTypeListModal {
  List<Data>? data;

  OnboardDocTypeListModal({this.data});

  OnboardDocTypeListModal.fromJson(Map<String, dynamic> json) {
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
  String? decp;
  String? name;
  String? id;

  Data({this.decp, this.name, this.id});

  Data.fromJson(Map<String, dynamic> json) {
    decp = json['decp'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['decp'] = decp;
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
