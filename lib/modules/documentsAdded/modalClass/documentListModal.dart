class DocumentListModal {
  List<MappedData>? mappedData;

  DocumentListModal({this.mappedData});

  DocumentListModal.fromJson(Map<String, dynamic> json) {
    if (json['mappedData'] != null) {
      mappedData = <MappedData>[];
      json['mappedData'].forEach((v) {
        mappedData!.add(MappedData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mappedData != null) {
      data['mappedData'] = mappedData!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['decp'] = decp;
    data['code'] = code;
    data['name'] = name;
    data['id'] = id;
    data['status'] = status;
    return data;
  }
}
