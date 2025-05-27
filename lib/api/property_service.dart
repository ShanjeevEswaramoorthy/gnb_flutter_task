import 'package:dio/dio.dart';
import '../models/property_model.dart';
import '../dio_client.dart';

class ApiService {
  final _dioClient = DioClient();

  Future<List<Logs>> fetchProperties({
    int page = 1,
    int limit = 2,
    String? postcode,
    String? status,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        'job_logs.php',
        data: {
          'page': page,
          'limit': limit,
          if (postcode != null) 'postcode': postcode,
          if (status != null) 'status': status,
        },
      );

      final propertyModel = PropertyModel.fromJson(response.data);
      return propertyModel.response?.logs ?? [];
    } on DioException catch (dioError) {
      throw Exception(dioError.error?.toString() ?? "Unknown error");
    }
  }
}
