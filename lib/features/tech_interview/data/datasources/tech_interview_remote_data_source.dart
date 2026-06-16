import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/tech_interview_session_model.dart';
import '../models/tech_stage_models.dart';

abstract class TechInterviewRemoteDataSource {
  Future<TechInterviewSessionModel> fetchActiveSession();
  Future<String> submitCode(String code, String language);
  Future<TechStageResponseDto> startTechStage(String id);
  Future<TechStageResponseDto> completeTechStage(String id);
}

class TechInterviewRemoteDataSourceImpl implements TechInterviewRemoteDataSource {
  TechInterviewRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<TechInterviewSessionModel> fetchActiveSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return TechInterviewSessionModel(
      headerTimerLabel: '0:15',
      interviewerName: 'PrepYou AI Code Coach',
      interviewerRole: 'Technical Interviewer',
      questionTitle: 'Two Sum',
      questionDifficulty: 'easy',
      questionLanguage: 'dart',
      questionDescription: '''
Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

You can return the answer in any order.

### Example 1:
```
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
```

### Constraints:
* `2 <= nums.length <= 10^4`
* `-10^9 <= nums[i] <= 10^9`
* `-10^9 <= target <= 10^9`
''',
      questionStarterCode: '''
List<int> twoSum(List<int> nums, int target) {
  // Write your code here
  return [];
}
''',
      messages: const [
        {
          'sender': 'ai',
          'body':
              "Welcome to the technical round. Let's solve the 'Two Sum' problem today. You can code in Dart on the right panel. Let me know if you have any questions before starting.",
          'timestamp': '0:00',
        },
      ],
    );
  }

  @override
  Future<String> submitCode(String code, String language) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    
    if (code.trim().isEmpty || (code.contains('// Write your code here') && code.contains('return [];'))) {
      return '''
[Running] dart main.dart
✗ Test Case 1: nums = [2,7,11,15], target = 9
  Expected: [0,1], Got: []
✗ Test Case 2: nums = [3,2,4], target = 6
  Expected: [1,2], Got: []

1 or more test cases failed. Please refine your solution.
''';
    }

    return '''
[Running] dart main.dart
✓ Test Case 1: nums = [2,7,11,15], target = 9 -> Passed (indices [0, 1])
✓ Test Case 2: nums = [3,2,4], target = 6 -> Passed (indices [1, 2])
✓ Test Case 3: nums = [3,3], target = 6 -> Passed (indices [0, 1])

All tests passed! 🎉
- Execution time: 12ms
- Memory usage: 4.2 MB
- Time Complexity: O(N)
- Space Complexity: O(N)

Your code is fully optimized. Click continue to finish the interview pipeline!
''';
  }

  @override
  Future<TechStageResponseDto> startTechStage(String id) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.techInterviewStage}/$id/start',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TechStageResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      final message = _parseErrorMessage(e);
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<TechStageResponseDto> completeTechStage(String id) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.techInterviewStage}/$id/complete',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TechStageResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      final message = _parseErrorMessage(e);
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  String _parseErrorMessage(DioException e) {
    if (e.response != null && e.response!.data != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'];
        if (message is List) {
          return message.join(', ');
        } else if (message is String) {
          return message;
        }
      }
    }
    return e.message ?? 'An unknown error occurred';
  }
}
