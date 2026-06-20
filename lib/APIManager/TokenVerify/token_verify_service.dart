// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pixievet_app/APIManager/TokenVerify/token_verify_request_model.dart';
import 'package:pixievet_app/APIManager/TokenVerify/token_verify_response_model.dart';

class TokenVerifyService {
  static const String _url = 'https://pixievet.vercel.app/auth/token/expiry';

  Future<TokenVerifyResponseModel> verifyToken(
    TokenVerifyRequestModel request,
  ) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return TokenVerifyResponseModel.fromJson(jsonDecode(response.body));
    } else {
      return TokenVerifyResponseModel(
        status: false,
        message: "Token verification failed",
      );
    }
  }
}
