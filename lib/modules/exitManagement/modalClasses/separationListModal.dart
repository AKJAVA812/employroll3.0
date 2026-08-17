class SeparationListModal {
  List<SeparationItem>? list;

  SeparationListModal({this.list});

  SeparationListModal.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <SeparationItem>[];
      json['list'].forEach((v) {
        list!.add(SeparationItem.fromJson(v));
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

class SeparationItem {
  String? code;
  String? name;
  String? description;
  int? id;

  SeparationItem({this.code, this.name, this.description, this.id});

  factory SeparationItem.fromJson(Map<String, dynamic> json) {
    return SeparationItem(
      code: json['code'],
      name: json['name'],
      description: json['description'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'description': description,
      'id': id,
    };
  }
}