class ClientDataListModal {
  List<Data>? data;

  ClientDataListModal({this.data});

  ClientDataListModal.fromJson(Map<String, dynamic> json) {
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
  String? clientMailId;
  int? clientId;
  String? orgName;
  String? clientName;
  String? clientContact;

  Data(
      {this.clientMailId,
        this.clientId,
        this.orgName,
        this.clientName,
        this.clientContact});

  Data.fromJson(Map<String, dynamic> json) {
    clientMailId = json['clientMailId'];
    clientId = json['clientId'];
    orgName = json['orgName'];
    clientName = json['clientName'];
    clientContact = json['clientContact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientMailId'] = clientMailId;
    data['clientId'] = clientId;
    data['orgName'] = orgName;
    data['clientName'] = clientName;
    data['clientContact'] = clientContact;
    return data;
  }
}
