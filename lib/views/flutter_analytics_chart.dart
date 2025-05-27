import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsChart extends StatefulWidget {
  const AnalyticsChart({super.key});

  @override
  State<AnalyticsChart> createState() => _AnalyticsChartState();
}

class _AnalyticsChartState extends State<AnalyticsChart> {
  Map<String, int> _viewCounts = {};

  @override
  void initState() {
    super.initState();
    loadChartData();
  }

  Future<Map<String, int>> getPropertyViewCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final rawData = prefs.getString('analytics_log') ?? '[]';
    final events = List<Map<String, dynamic>>.from(jsonDecode(rawData));

    final viewCounts = <String, int>{};

    for (var event in events) {
      if (event['event'] == 'property_viewed') {
        final title = event['params']['title'] ?? 'Unknown';
        viewCounts[title] = (viewCounts[title] ?? 0) + 1;
      }
    }

    return viewCounts;
  }

  Future<void> loadChartData() async {
    final data = await getPropertyViewCounts();
    setState(() {
      _viewCounts = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final titles = _viewCounts.keys.toList();
    final values = _viewCounts.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Graph')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            _viewCounts.isEmpty
                ? const Center(child: Text('No analytics data'))
                : BarChart(
                  BarChartData(
                    barGroups: List.generate(
                      titles.length,
                      (index) => BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: values[index].toDouble(),
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            return Text(
                              titles[idx].length > 6
                                  ? '${titles[idx].substring(0, 6)}...'
                                  : titles[idx],
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
