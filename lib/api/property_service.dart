import 'package:dio/dio.dart';
import '../models/property_model.dart';
import '../utils/dio_client.dart';

class PropertyApiService {
  final _dioClient = DioClient();

  Future<PropertyModel> fetchProperties({
    int page = 1,
    int pageSize = 20,
    int? minPrice,
    int? maxPrice,
    String? location,
    List<String>? tags,
    String? status,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'page_size': pageSize,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (location != null) 'location': location,
        if (status != null) 'status': status,
        if (tags != null && tags.isNotEmpty) 'tags': tags,
      };

      final response = await _dioClient.dio.get(
        'properties',
        queryParameters: queryParams,
      );

      return PropertyModel.fromJson(response.data);
    } on DioException catch (dioError) {
      throw Exception(dioError.message ?? "Unknown Dio error");
    }
  }
}
