import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService2 {
  final String apiKey = '// API KEYY';
  final String postApiUrl =
      '//';
  final String getApiUrl =
      '//';

  /// İş akışını tetikler ve `trigger_id` döner.
  Future<String?> triggerWorkflow({
    required String audioUrl,
    required String language,
    required String summarizeRules,
    String outputFormat = 'json',
  }) async {
    final Map<String, dynamic> requestBody = {
      'parameters': {
        'url': audioUrl,
        'language': language,
        'rules': summarizeRules,
        'output': outputFormat,
      },
      'webhook_url': '',
    };

    try {
      print("Trigger Workflow - Sending POST Request...");
      print("Request Body: $requestBody");

      final response = await http.post(
        Uri.parse(postApiUrl),
        headers: {
          'X-API-Key': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('trigger_id')) {
          print("Trigger ID Retrieved: ${data['trigger_id']}");
          return data['trigger_id'] as String?;
        } else {
          throw Exception('API response is missing trigger_id.');
        }
      } else {
        throw Exception(
            "Failed to trigger workflow: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Error in triggerWorkflow: $e");
      return null;
    }
  }
  
  /// Belirtilen `trigger_id` ile iş akışının durumunu kontrol eder.
  Future<Map<String, dynamic>?> getExecutionStatus(String triggerId) async {
  final String getUrl = '$getApiUrl$triggerId';

  try {
    print("Fetching Execution Status for Trigger ID: $triggerId");

    final response = await http.get(
      Uri.parse(getUrl),
      headers: {
        'X-API-Key': apiKey,
        'Content-Type': 'application/json',
      },
    );

    print("Execution Status Response - Status Code: ${response.statusCode}");
    print("Execution Status Response - Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // Adım sonuçlarını yazdır
      if (data.containsKey('step_results')) {
        for (var step in data['step_results']) {
          print("Step ${step['step_name']} - Status: ${step['status']}");
        }
      }

      return data;
    } else {
      throw Exception(
          "Failed to fetch execution status: ${response.statusCode}");
    }
  } catch (e) {
    print("Error in getExecutionStatus: $e");
    return null;
  }
}

  /// İş akışının durumunu düzenli aralıklarla kontrol eder (polling).
  Future<Map<String, dynamic>> pollExecutionStatus(
    String triggerId, {
    int interval = 2,
    int timeout = 200,
  }) async {
    Map<String, dynamic>? executionResult;

    try {
      print("Polling Execution Status Started - Trigger ID: $triggerId");

      await Future(() async {
        while (true) {
          executionResult = await getExecutionStatus(triggerId);

          if (executionResult == null) {
            throw Exception('Execution result is null.');
          }

          print("Current Execution Status: ${executionResult?['status']}");

          if (executionResult?['status'] == 'succeeded') {
            print("Execution Succeeded!");
            break;
          }

          if (executionResult?['status'] == 'failure') {
            throw Exception(
                'Workflow failed: ${executionResult?['error_message'] ?? 'Unknown error'}');
          }

          await Future.delayed(Duration(seconds: interval));
        }
      }).timeout(Duration(seconds: timeout));

      if (executionResult != null) {
        print("Polling Completed - Final Result: $executionResult");
        return executionResult!;
      } else {
        throw Exception('No valid output found.');
      }
    } catch (e) {
      if (e is TimeoutException) {
        print("Polling operation timed out after $timeout seconds.");
        throw Exception('Operation timed out. Please try again later.');
      } else {
        print("An error occurred in polling: $e");
        throw e;
      }
    }
  }

  /// İş akışını tetikler ve sonuçları döndürür.
  Future<Map<String, dynamic>> getRecordingSummary({
  required String audioUrl,
  required String language,
  required String summarizeRules,
}) async {
  print("Starting Recording Summary Process...");
  print("Audio URL: $audioUrl, Language: $language, Summarize Rules: $summarizeRules");

  final triggerId = await triggerWorkflow(
    audioUrl: audioUrl,
    language: language,
    summarizeRules: summarizeRules,
    outputFormat: 'json',
  );

  if (triggerId == null) {
    throw Exception('Trigger ID could not be retrieved.');
  }

  final result = await pollExecutionStatus(triggerId);
  print("Full API Response: ${jsonEncode(result)}");  // API'den dönen sonucu detaylı görmek için

  if (result.containsKey('step_results')) {
    final stepResults = result['step_results'] as List<dynamic>;

    // Transkripsiyon aşamasını kontrol et
    final transcriptionStep = stepResults.firstWhere(
      (step) => step['step_name'] == 'Incredibly Fast Fhisper',
      orElse: () => null,
    );

    // Özetleme aşamasını kontrol et
    final summarizationStep = stepResults.firstWhere(
      (step) => step['step_name'] == 'ChatGPT',
      orElse: () => null,
    );

    if (transcriptionStep != null && transcriptionStep['status'] == 'succeeded' &&
        summarizationStep != null && summarizationStep['status'] == 'succeeded') {
      
      final transcript = transcriptionStep['output']?.replaceAll(RegExp(r'^"|"$'), '') ?? 'No Transcript Available';
      final summary = summarizationStep['output']?.replaceAll(RegExp(r'^"|"$'), '') ?? 'No Summary Available';

      return {
        'title': result['flow_name'] ?? 'Generated Title',
        'timestamp': '',
        'summary': summary,
        'transcript': transcript,
      };
    } else {
      throw Exception('No valid step results found.');
    }
  } else {
    throw Exception('No step_results found in the API response.');
  }
}


}
