import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/property_model.dart';

class PropertyDetailView extends StatefulWidget {
  final Properties property;

  const PropertyDetailView({super.key, required this.property});

  @override
  State<PropertyDetailView> createState() => _PropertyDetailViewState();
}

class _PropertyDetailViewState extends State<PropertyDetailView> {
  File? _capturedImage;
  final ImagePicker _picker = ImagePicker();

  int _viewCount = 0;

  @override
  void initState() {
    super.initState();
    _loadAndSetViewCount();
  }

  Future<void> _loadAndSetViewCount() async {
    final prefs = await SharedPreferences.getInstance();
    final rawData = prefs.getString('analytics_log') ?? '[]';

    final events = List<Map<String, dynamic>>.from(jsonDecode(rawData));
    int count = 0;
    final propertyTitle = widget.property.title ?? 'Unknown';

    for (var event in events) {
      if (event['event'] == 'property_viewed') {
        final title = event['params']['title'] ?? 'Unknown';
        if (title == propertyTitle) {
          count++;
        }
      }
    }

    setState(() {
      _viewCount = count;
    });
  }

  Future<void> _captureImage(ImageSource imageSource) async {
    final XFile? pickedFile = await _picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      setState(() {
        _capturedImage = File(pickedFile.path);
      });
    }
  }

  void _retryImage() {
    setState(() {
      _capturedImage = null;
    });
  }

  void _uploadImage() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Image uploaded (mock)!')));
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;
    final agent = property.agent;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Property Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 16),
            Text(
              property.title ?? '',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Viewed $_viewCount times',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              property.description ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                if (property.location?.city != null)
                  Chip(label: Text(property.location!.city!)),
                if (property.status != null)
                  Chip(label: Text(property.status!)),
                if (property.tags != null)
                  ...property.tags!.map((tag) => Chip(label: Text(tag))),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetric(Icons.bed, '${property.bedrooms ?? 'N/A'} Beds'),
                _buildMetric(
                  Icons.bathtub,
                  '${property.bathrooms ?? 'N/A'} Baths',
                ),
                _buildMetric(
                  Icons.square_foot,
                  '${property.areaSqFt ?? 'N/A'} sqft',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${property.currency ?? 'USD'} ${property.price?.toStringAsFixed(0) ?? 'N/A'}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const Divider(height: 32),
            Text(
              'Contact Agent',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: const Icon(Icons.person),
              ),
              title: Text(agent?.name ?? 'Unknown Agent'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(agent?.email ?? ''),
                  Text(agent?.contact ?? ''),
                ],
              ),
            ),
            const Divider(height: 32),
            Text(
              'Upload Image (Camera)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_capturedImage == null) ...[
              ElevatedButton.icon(
                onPressed: () => _captureImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Capture Image'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _captureImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Pick from Gallery'),
              ),
            ] else ...[
              Image.file(
                _capturedImage!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _retryImage,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retake'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _uploadImage,
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: Colors.grey[800])),
      ],
    );
  }
}
