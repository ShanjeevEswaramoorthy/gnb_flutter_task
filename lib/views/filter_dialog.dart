import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String? selectedStatus;
  final List<String> selectedTags = [];
  final tags = ['New', 'Furnished', 'Available'];
  final statuses = ['Sold', 'Available', 'Upcoming'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Properties'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: minPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Min Price'),
            ),
            TextField(
              controller: maxPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Max Price'),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              items:
                  statuses
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
              decoration: const InputDecoration(labelText: 'Status'),
              onChanged: (value) => setState(() => selectedStatus = value),
            ),
            Wrap(
              spacing: 8,
              children:
                  tags
                      .map(
                        (tag) => FilterChip(
                          label: Text(tag),
                          selected: selectedTags.contains(tag),
                          onSelected: (selected) {
                            setState(() {
                              selected
                                  ? selectedTags.add(tag)
                                  : selectedTags.remove(tag);
                            });
                          },
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final filters = {
              if (minPriceController.text.isNotEmpty)
                'min_price': int.tryParse(minPriceController.text),
              if (maxPriceController.text.isNotEmpty)
                'max_price': int.tryParse(maxPriceController.text),
              if (locationController.text.isNotEmpty)
                'location': locationController.text,
              if (selectedStatus != null) 'status': selectedStatus,
              if (selectedTags.isNotEmpty) 'tags': selectedTags,
            };
            Navigator.of(context).pop(filters);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
