import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_models/property_view_model.dart';

class PropertyListingView extends ConsumerWidget {
  const PropertyListingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyProvider);
    final notifier = ref.read(propertyProvider.notifier);

    String? selectedStatus;
    String? selectedPostcode;

    return Scaffold(
      appBar: AppBar(title: const Text("Property Listings")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10,
              children: [
                DropdownButton<String>(
                  hint: const Text("Status"),
                  value: selectedStatus,
                  items:
                      ['Available', 'Sold', 'Upcoming']
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    selectedStatus = value;
                    notifier.updateFilters(status: value);
                  },
                ),
                SizedBox(
                  width: 150,
                  child: TextField(
                    decoration: const InputDecoration(labelText: "Postcode"),
                    onSubmitted: (value) {
                      selectedPostcode = value;
                      notifier.updateFilters(postcode: value);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('$error')),
              data: (property) {
                if (property.isEmpty) {
                  return const Center(child: Text("No properties found"));
                }
                return ListView.builder(
                  itemCount: property.length,
                  itemBuilder: (context, index) {
                    final item = property[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: const Icon(Icons.location_city),
                        title: Text("Postcode: ${item.postcode}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Machine ID: ${item.machineId}"),
                            Text("Start At: ${item.startAt}"),
                            Text("End At: ${item.endAt ?? "Ongoing"}"),
                          ],
                        ),
                        trailing: Text(
                          item.status ?? '',
                          style: TextStyle(
                            color:
                                item.status == 'Available'
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
