import 'package:flutter/material.dart';

class FilterSection extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;
  final Function() onClearFilters;
  final Map<String, dynamic> initialFilters;

  const FilterSection({
    super.key,
    required this.onApplyFilters,
    required this.onClearFilters,
    required this.initialFilters,
  });

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  late final TextEditingController _locationController;

  String? _selectedStatus;
  List<String> _selectedTags = [];

  final List<String> _statuses = ['Sold', 'Available', 'Upcoming'];
  final List<String> _tags = ['New', 'Furnished', 'Available'];
  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController(
      text: widget.initialFilters['min_price']?.toString() ?? '',
    );
    _maxPriceController = TextEditingController(
      text: widget.initialFilters['max_price']?.toString() ?? '',
    );
    _locationController = TextEditingController(
      text: widget.initialFilters['location']?.toString() ?? '',
    );
    _selectedStatus = widget.initialFilters['status'] as String?;
    _selectedTags = List<String>.from(
      widget.initialFilters['tags'] ?? <String>[],
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Min Price'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Max Price'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              items:
                  _statuses
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
              decoration: const InputDecoration(labelText: 'Status'),
              onChanged: (value) => setState(() => _selectedStatus = value),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  _tags.map((tag) {
                    return FilterChip(
                      label: Text(tag),
                      selected: _selectedTags.contains(tag),
                      onSelected: (selected) {
                        setState(() {
                          selected
                              ? _selectedTags.add(tag)
                              : _selectedTags.remove(tag);
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _minPriceController.clear();
                      _maxPriceController.clear();
                      _locationController.clear();
                      _selectedStatus = null;
                      _selectedTags = [];
                      widget.initialFilters.clear();
                    });
                    widget.onClearFilters();
                  },
                  icon: const Icon(Icons.clear, color: Colors.red),
                  label: const Text(
                    'Clear Filters',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final filters = {
                      if (_minPriceController.text.isNotEmpty)
                        'min_price': int.tryParse(_minPriceController.text),
                      if (_maxPriceController.text.isNotEmpty)
                        'max_price': int.tryParse(_maxPriceController.text),
                      if (_locationController.text.isNotEmpty)
                        'location': _locationController.text,
                      if (_selectedStatus != null) 'status': _selectedStatus,
                      if (_selectedTags.isNotEmpty) 'tags': _selectedTags,
                    };
                    widget.onApplyFilters(filters);
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
