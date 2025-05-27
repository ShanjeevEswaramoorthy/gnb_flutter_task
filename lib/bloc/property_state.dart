import 'package:gnb_flutter_task/models/property_model.dart';

abstract class PropertyState {
  const PropertyState();
}

class PropertyInitial extends PropertyState {}

class PropertyLoading extends PropertyState {}

class PropertyLoaded extends PropertyState {
  final List<Properties>? properties;
  final int? currentPage;
  final int? totalPages;
  final bool? isLoadingMore;

  const PropertyLoaded({
    this.properties,
    this.currentPage,
    this.totalPages,
    this.isLoadingMore = false,
  });
}

class PropertyError extends PropertyState {
  final String message;
  const PropertyError(this.message);
}
