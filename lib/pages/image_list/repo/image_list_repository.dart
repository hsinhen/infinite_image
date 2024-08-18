import 'dart:convert';

import 'package:infinite_image/api/api_service.dart';

import '../../../models/image_data.dart';

class ImageListRepository {
  static Future<List<ImageData>> fetchImages({
    required int pageNo,
    required int itemPerPage,
  }) async {
    final queryParams = {
      'page': pageNo.toString(),
      'limit': itemPerPage.toString(),
    };
    final endpoint = 'list?${Uri(queryParameters: queryParams).query}';

    final responseBody = await APIService.get(endpoint);
    if (responseBody == null) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(responseBody);
      return jsonList.map((json) => ImageData.fromJson(json)).toList();
    } catch (e) {
      print('Failed to parse images: $e');
      return [];
    }
  }
}
