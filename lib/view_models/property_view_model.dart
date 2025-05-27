import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnb_flutter_task/api/property_service.dart';
import 'package:gnb_flutter_task/models/property_model.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
final propertyProvider = AsyncNotifierProvider<PropertyNotifier, List<Logs>>(
  PropertyNotifier.new,
);

class PropertyNotifier extends AsyncNotifier<List<Logs>> {
  String? _status;
  String? _postcode;

  @override
  Future<List<Logs>> build() async {
    return fetchProperties();
  }

  void updateFilters({String? status, String? postcode}) async {
    _status = status;
    _postcode = postcode;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => fetchProperties());
  }

  Future<List<Logs>> fetchProperties() async {
    final api = ref.read(apiServiceProvider);
    return await api.fetchProperties(status: _status, postcode: _postcode);
  }
}
