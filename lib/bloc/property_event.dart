abstract class PropertyEvent {
  const PropertyEvent();
}

class FetchProperties extends PropertyEvent {
  final int page;
  final Map<String, dynamic> filters;
  final bool isLoadMore;

  const FetchProperties({
    this.page = 1,
    this.filters = const {},
    this.isLoadMore = false,
  });
}

class ApplyFilters extends PropertyEvent {
  final Map<String, dynamic> filters;

  const ApplyFilters(this.filters);
}

class ClearFilters extends PropertyEvent {
  final Map<String, dynamic> filters;

  const ClearFilters(this.filters);
}
