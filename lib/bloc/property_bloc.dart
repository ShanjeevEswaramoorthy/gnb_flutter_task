import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnb_flutter_task/api/property_service.dart';
import 'package:gnb_flutter_task/bloc/property_event.dart';
import 'package:gnb_flutter_task/bloc/property_state.dart';
import 'package:gnb_flutter_task/models/property_model.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final PropertyApiService _propertyApi = PropertyApiService();

  final List<Properties> _allProperties = [];
  int _currentPage = 1;
  int _totalPages = 1;
  Map<String, dynamic> _currentFilters = {};

  PropertyBloc() : super(PropertyInitial()) {
    on<FetchProperties>(_onFetchProperties);
    on<ApplyFilters>(_onApplyFilters);
  }

  Future<void> _onFetchProperties(
    FetchProperties event,
    Emitter<PropertyState> emit,
  ) async {
    final isLoadMore = event.isLoadMore;

    if (!isLoadMore) {
      emit(PropertyLoading());
      _allProperties.clear();
      _currentPage = 1;
    }

    try {
      final response = await _propertyApi.fetchProperties(
        page: event.page,
        pageSize: 20,
        minPrice: event.filters['min_price'],
        maxPrice: event.filters['max_price'],
        location: event.filters['location'],
        status: event.filters['status'],
        tags:
            event.filters['tags'] != null
                ? List<String>.from(event.filters['tags'])
                : null,
      );

      _currentPage = response.page ?? event.page;
      _totalPages = response.totalPages ?? 1;
      _currentFilters = event.filters;

      if (isLoadMore) {
        _allProperties.addAll(response.properties ?? []);
      } else {
        _allProperties
          ..clear()
          ..addAll(response.properties ?? []);
      }

      emit(
        PropertyLoaded(
          properties: List.unmodifiable(_allProperties),
          currentPage: _currentPage,
          totalPages: _totalPages,
          isLoadingMore: isLoadMore,
        ),
      );
    } catch (e) {
      emit(PropertyError('Failed to load properties: $e'));
    }
  }

  void _onApplyFilters(ApplyFilters event, Emitter<PropertyState> emit) {
    _currentFilters = event.filters;
    add(FetchProperties(page: _currentPage, filters: _currentFilters));
  }
}
