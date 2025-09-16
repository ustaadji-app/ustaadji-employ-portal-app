import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://irex.pk/ustaadjiweb/public/api";

  Future<Map<String, dynamic>> postRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    try {
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "data": jsonDecode(response.body)};
      } else {
        return {
          "success": false,
          "message": jsonDecode(response.body)['message'] ?? "Error",
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getRequest({
    required String endpoint,
    Map<String, String>? queryParams,
    String? token, // <-- token optional
  }) async {
    Uri url;
    if (queryParams != null) {
      url = Uri.parse(
        '$baseUrl/$endpoint',
      ).replace(queryParameters: queryParams);
    } else {
      url = Uri.parse('$baseUrl/$endpoint');
    }

    try {
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return {"success": true, "data": jsonDecode(response.body)};
      } else {
        return {
          "success": false,
          "message": jsonDecode(response.body)['message'] ?? "Error",
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
