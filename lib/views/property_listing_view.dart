import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnb_flutter_task/views/filter_dialog.dart';
import 'package:gnb_flutter_task/views/local_analytics.dart';
import 'package:gnb_flutter_task/views/property_detail_view.dart';
import '../bloc/property_bloc.dart';
import '../bloc/property_event.dart';
import '../bloc/property_state.dart';
import '../models/property_model.dart';

class PropertyListingView extends StatefulWidget {
  const PropertyListingView({super.key});

  @override
  State<PropertyListingView> createState() => _PropertyListingViewState();
}

class _PropertyListingViewState extends State<PropertyListingView> {
  final analytics = SimpleAnalyticsService();
  final Map<String, dynamic> _filters = {};
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();

    _fetchInitialProperties();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isFetchingMore) {
        _fetchMoreProperties();
      }
    });
  }

  void _fetchInitialProperties() {
    _currentPage = 1;
    context.read<PropertyBloc>().add(
      FetchProperties(page: _currentPage, filters: _filters),
    );
  }

  void _fetchMoreProperties() {
    final state = context.read<PropertyBloc>().state;
    if (state is PropertyLoaded && state.currentPage! < state.totalPages!) {
      _isFetchingMore = true;
      _currentPage++;
      context.read<PropertyBloc>().add(
        FetchProperties(
          page: _currentPage,
          filters: _filters,
          isLoadMore: true,
        ),
      );
    }
  }

  void _applyFilters(Map<String, dynamic> filters) {
    _filters.clear();
    _filters.addAll(filters);
    _currentPage = 1;
    context.read<PropertyBloc>().add(ApplyFilters(filters));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Listings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () async {
              final filters = await showDialog<Map<String, dynamic>>(
                context: context,
                builder: (context) => const FilterDialog(),
              );
              if (filters != null) _applyFilters(filters);
            },
          ),
        ],
      ),
      body: BlocConsumer<PropertyBloc, PropertyState>(
        listener: (context, state) {
          // Reseting the fetching flag when done loading
          if (state is PropertyLoaded) {
            _isFetchingMore = false;
          }
        },
        builder: (context, state) {
          if (state is PropertyLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PropertyError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 8),
                  Text(state.message),
                ],
              ),
            );
          } else if (state is PropertyLoaded) {
            if (state.properties == null || state.properties!.isEmpty) {
              return const Center(child: Text('No properties found.'));
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: state.properties!.length,
              itemBuilder: (context, index) {
                if (index == state.properties!.length) {
                  return state.currentPage! < state.totalPages!
                      ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(),
                        ),
                      )
                      : const SizedBox.shrink();
                } else {
                  final property = state.properties?[index];
                  return GestureDetector(
                    onTap: () {
                      analytics.logEvent('property_viewed', {
                        'property_id': property.id ?? '',
                        'title': property.title ?? '',
                        'price': property.price ?? 0,
                        'city': property.location?.city ?? '',
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => PropertyDetailView(property: property),
                        ),
                      );
                    },
                    child: _buildPropertyCard(property!),
                  );
                }
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPropertyCard(Properties property) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (property.images?.isNotEmpty == true)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                property.images!.first,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  property.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    if (property.location?.city != null)
                      Chip(
                        label: Text(property.location!.city!),
                        backgroundColor: Colors.blue.shade50,
                      ),
                    if (property.status != null)
                      Chip(
                        label: Text(property.status!),
                        backgroundColor: Colors.green.shade50,
                      ),
                    if (property.tags != null)
                      ...property.tags!.map(
                        (tag) => Chip(
                          label: Text(tag),
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${property.price?.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
