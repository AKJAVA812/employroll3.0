import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../commanScreen/allAPIList.dart';
import '../singUP/model/login_organisation.dart';
import 'mobile_http_client.dart';

class LoginOrganisationException implements Exception {
  const LoginOrganisationException(this.message);

  final String message;

  @override
  String toString() => message;
}

class LoginOrganisationService {
  LoginOrganisationService._();

  static final LoginOrganisationService instance = LoginOrganisationService._();

  Future<LoginOrganisation> lookup(String identifier) async {
    final normalizedIdentifier = identifier.trim();
    if (normalizedIdentifier.isEmpty) {
      throw const LoginOrganisationException(
        'Email, mobile number, or user ID is required.',
      );
    }

    try {
      final response = await MobileHttpClient.instance
          .post(
            Uri.parse(
              '${ApiDetails.server}${ApiDetails.loginOrganisationLookup}',
            ),
            headers: const {
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode({
              'identifier': normalizedIdentifier,
              'email': normalizedIdentifier,
            }),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == HttpStatus.notFound ||
          response.statusCode == HttpStatus.noContent) {
        throw const LoginOrganisationException('User does not exist.');
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw const LoginOrganisationException(
          'Unable to check your workspace. Please try again.',
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['found'] == false) {
        throw LoginOrganisationException(
          (decoded['message'] ?? 'User does not exist.').toString(),
        );
      }

      final organisation = LoginOrganisation.fromResponse(decoded);
      if (!organisation.found) {
        throw const LoginOrganisationException('User does not exist.');
      }
      if (!organisation.hasWorkspace) {
        throw const LoginOrganisationException(
          'Organisation details are not available. Contact your administrator.',
        );
      }
      return organisation;
    } on LoginOrganisationException {
      rethrow;
    } on TimeoutException {
      throw const LoginOrganisationException(
        'Workspace lookup timed out. Please try again.',
      );
    } on SocketException {
      throw const LoginOrganisationException(
        'Please check your internet connection.',
      );
    } on FormatException {
      throw const LoginOrganisationException(
        'Invalid workspace response. Please try again.',
      );
    } catch (_) {
      throw const LoginOrganisationException(
        'Unable to check your workspace. Please try again.',
      );
    }
  }
}
