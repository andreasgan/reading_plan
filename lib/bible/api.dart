import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:reading_plan/dio.dart' as dio_instance;

import 'models/plan.dart';

final api = Api(dio: dio_instance.dio);

class Api {
  final Dio _dio;

  Api({required Dio dio}) : _dio = dio;

  Future<Plan?> fetchPlan(String plan, int day) async {
    final response = await _dio.get(
      'https://plans.youversionapi.com/4.0/plans/$plan/days/$day?together=true',
      options: Options(
        headers: {
          'accept': 'application/json',
          'accept-language': 'no',
          'content-type': 'application/json',
          'origin': 'https://my.bible.com',
          'referer': 'https://my.bible.com/',
          'x-youversion-app-platform': 'web',
          'x-youversion-app-version': '4',
          'x-youversion-client': 'youversion',
        },
      ),
    );
    final statusCode = response.statusCode;

    if (statusCode != null && statusCode >= 200 && statusCode < 400) {
      final Plan plan = Plan.fromJson(response.data);
      return plan;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to fetch plan');
    }
  }
}
