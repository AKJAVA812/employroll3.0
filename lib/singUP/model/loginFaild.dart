class LoginFaild {
  Data? data;

  LoginFaild({this.data});

  LoginFaild.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? result;
  String? reason;

  Data({this.result, this.reason});

  Data.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['result'] = this.result;
    data['reason'] = this.reason;
    return data;
  }
}
