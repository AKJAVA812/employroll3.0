class DocumentListModal {
  List<MappedData>? mappedData;

  DocumentListModal({this.mappedData});

  DocumentListModal.fromJson(Map<String, dynamic> json) {
    if (json['mappedData'] != null) {
      mappedData = <MappedData>[];
      json['mappedData'].forEach((v) {
        mappedData!.add(new MappedData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mappedData != null) {
      data['mappedData'] = this.mappedData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MappedData {
  var decp;
  String? code;
  String? name;
  String? id;
  String? status;

  MappedData({this.decp, this.code, this.name, this.id, this.status});

  MappedData.fromJson(Map<String, dynamic> json) {
    decp = json['decp'];
    code = json['code'];
    name = json['name'];
    id = json['id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['decp'] = this.decp;
    data['code'] = this.code;
    data['name'] = this.name;
    data['id'] = this.id;
    data['status'] = this.status;
    return data;
  }
}
