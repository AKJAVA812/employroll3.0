import 'dart:convert';

class LoginOrganisation {
  const LoginOrganisation({
    required this.found,
    required this.specialLogin,
    required this.loginId,
    required this.orgName,
    required this.roles,
    required this.loginImageUrl,
    required this.orgId,
    required this.logoUrl,
  });

  final bool found;
  final bool specialLogin;
  final String loginId;
  final String orgName;
  final List<String> roles;
  final String loginImageUrl;
  final int orgId;
  final String logoUrl;

  String get initial {
    final value = orgName.trim();
    return value.isEmpty ? 'E' : value.substring(0, 1).toUpperCase();
  }

  bool get hasWorkspace => found && (specialLogin || orgId > 0);

  factory LoginOrganisation.fromResponse(dynamic response) {
    dynamic value = response;
    if (value is String) value = jsonDecode(value);
    if (value is Map) {
      value = value['data'] ?? value['organisation'] ?? value;
    }
    if (value is String) value = jsonDecode(value);
    if (value is! Map) {
      throw const FormatException('Invalid organisation lookup response.');
    }

    final json = Map<String, dynamic>.from(value);
    final foundValue =
        json['found'] ?? json['organisationFound'] ?? json['exists'];
    return LoginOrganisation(
      found: foundValue == null ? true : _asBool(foundValue),
      specialLogin: _asBool(json['specialLogin']),
      loginId: (json['loginId'] ?? '').toString().trim(),
      orgName:
          (json['orgName'] ??
                  json['organisationName'] ??
                  json['name'] ??
                  'Your workspace')
              .toString()
              .trim(),
      roles: (json['roles'] as List? ?? const [])
          .map((role) => role.toString())
          .toList(growable: false),
      loginImageUrl:
          (json['loginImageUrl'] ??
                  json['imageUrl'] ??
                  json['backgroundImageUrl'] ??
                  '')
              .toString()
              .trim(),
      orgId: int.tryParse(
            (json['orgId'] ?? json['organisationId'] ?? json['id'] ?? 0)
                .toString(),
          ) ??
          0,
      logoUrl:
          (json['logoUrl'] ?? json['organisationLogoUrl'] ?? json['logo'] ?? '')
              .toString()
              .trim(),
    );
  }

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value == 1;
    return const {'true', '1', 'yes'}.contains(
      value?.toString().trim().toLowerCase(),
    );
  }
}
