class ReasonForLeavingModal {
  List<ListData>? list;

  ReasonForLeavingModal({this.list});

  ReasonForLeavingModal.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ListData>[];
      json['list'].forEach((v) {
        list!.add(ListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListData {
  String? code;
  String? name;
  String? description;
  int? id;

  ListData({this.code, this.name, this.description, this.id});

  ListData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    description = json['description'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['description'] = description;
    data['id'] = id;
    return data;
  }
}
