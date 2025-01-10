import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = "MP1019D9OOS1BH6K6466G75AG11YBUR4TPA9";
  final String postApiUrl =
      "https://flows.eachlabs.ai/api/v1/8b12dce4-80cd-4389-870d-5beff1db67da/trigger";
  final String getApiUrl =
      "https://flows.eachlabs.ai/api/v1/8b12dce4-80cd-4389-870d-5beff1db67da/executions/";

  Future<String?> triggerWorkflow(String youtubeUrl, String language,
    String rules, String outputFormat) async {
  final Map<String, dynamic> requestBody = {
    'parameters': {
      'url': youtubeUrl,
      'language': language,
      'rules': rules,
      'output': outputFormat,
    },
    'webhook_url': ''
  };

  try {
    final response = await http.post(
      Uri.parse(postApiUrl),
      headers: {
        'X-API-Key': apiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );
    print("Response status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['trigger_id'] as String?;
    } else {
      throw Exception(
          "Failed to trigger workflow: ${response.statusCode} ${response.body}");
    }
  } catch (e) {
    print("Error in triggerWorkflow: $e");
    return null;
  }
}


  Future<Map<String, dynamic>?> getExecutionStatus(String triggerId) async {
    final String getUrl = '$getApiUrl$triggerId'; 

    try {
      final response = await http.get(
        Uri.parse(getUrl),
        headers: {
          'X-API-Key': apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
            "Failed to fetch execution status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in getExecutionStatus: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> pollExecutionStatus(String triggerId,
      {int interval = 2, int timeout = 60}) async {
    Map<String, dynamic>? executionResult;

    try {
      await Future(() async {
        while (true) {
          executionResult = await getExecutionStatus(triggerId);
          if (executionResult == null ||
              executionResult?['status'] == 'succeeded' ||
              executionResult?['status'] == 'failure') {
            break;
          }
          await Future.delayed(Duration(seconds: interval));
        }
      }).timeout(Duration(seconds: timeout));

      if (executionResult != null) {
        return executionResult!;
      } else {
        throw Exception('No valid output found');
      }
    } catch (e) {
      if (e is TimeoutException) {
        print('Polling operation timed out after $timeout seconds.');
        throw Exception('Operation timed out');
      } else {
        print('An error occurred: $e');
        throw e;
      }
    }
  }
}
