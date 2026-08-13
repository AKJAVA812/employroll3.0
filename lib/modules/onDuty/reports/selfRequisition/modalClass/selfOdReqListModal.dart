class SelfOdReqListModal {
  String? result;
  List<Listdata>? listdata;

  SelfOdReqListModal({this.result, required this.listdata});

  SelfOdReqListModal.fromJson(Map<String, dynamic> json) {
    result = json['result']?.toString();
    final rawList = json['content'] ?? json['listdata'];
    listdata = <Listdata>[];
    if (rawList is List) {
      for (final item in rawList) {
        if (item is Map) {
          listdata!.add(Listdata.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'result': result,
    'listdata': listdata?.map((item) => item.toJson()).toList(),
  };
}

class Listdata {
  String? date;
  String? image;
  String? odtime;
  String? odStatus;
  double? lng;
  String? approvalstatus;
  String? odaddress;
  String? odtype;
  String? remark;
  String? approvaldate;
  String? name;
  String? id;
  double? lat;

  Listdata({
    this.date,
    this.image,
    this.odtime,
    this.odStatus,
    this.lng,
    this.approvalstatus,
    this.odaddress,
    this.odtype,
    this.remark,
    this.approvaldate,
    this.name,
    this.id,
    this.lat,
  });

  Listdata.fromJson(Map<String, dynamic> json) {
    final punchTime = _text(json['punchTime']);
    final parsedPunchTime = DateTime.tryParse(punchTime)?.toLocal();
    date = _text(json['date'], parsedPunchTime?.toIso8601String() ?? punchTime);
    image = _text(json['imageUrl'], _text(json['image']));
    odtime = _text(
      json['odtime'],
      parsedPunchTime == null
          ? ''
          : '${parsedPunchTime.hour.toString().padLeft(2, '0')}:'
              '${parsedPunchTime.minute.toString().padLeft(2, '0')}',
    );
    odStatus = _text(json['status'], _text(json['odStatus']));
    lng = _number(json['longitude'] ?? json['lng']);
    approvalstatus = _approvalLabel(
      _text(json['approvalStatus'], _text(json['approvalstatus'])),
    );
    odaddress = _text(json['address'], _text(json['odaddress']));
    odtype = _text(json['punchAction'], _text(json['odtype']));
    remark = _text(json['remark'], _text(json['Remark']));
    approvaldate = _text(json['receivedAt'], _text(json['approvaldate']));
    name = _text(json['employeeName'], _text(json['name']));
    id = _text(json['id']);
    lat = _number(json['latitude'] ?? json['lat']);
  }

  static String _text(Object? value, [String fallback = '']) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text.toLowerCase() == 'null' ? fallback : text;
  }

  static double? _number(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(_text(value));
  }

  static String _approvalLabel(String value) {
    switch (value.trim().toUpperCase()) {
      case 'APPROVED':
        return 'Approved';
      case 'REJECTED':
      case 'DISAPPROVED':
        return 'DisApproved';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'date': date,
    'image': image,
    'odtime': odtime,
    'odStatus': odStatus,
    'lng': lng,
    'approvalstatus': approvalstatus,
    'odaddress': odaddress,
    'odtype': odtype,
    'Remark': remark,
    'approvaldate': approvaldate,
    'name': name,
    'id': id,
    'lat': lat,
  };
}
