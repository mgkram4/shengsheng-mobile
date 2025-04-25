import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/api_service.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<Alert> _alerts = [];
  late TabController _tabController;
  final List<String> _tabTitles = ['All', 'Madrid', 'Barcelona'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAlerts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAlerts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, you would get this from your API
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay

      _alerts = _generateMockAlerts();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load alerts: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Alert> _generateMockAlerts() {
    return [
      Alert(
        id: '1',
        title: '5 new properties in Sol',
        description:
            'New listings match your criteria in Madrid (Sol, Gran Vía, Callao)',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        city: 'Madrid',
        type: AlertType.newListings,
        count: 5,
        stations: ['Sol', 'Gran Vía', 'Callao'],
      ),
      Alert(
        id: '2',
        title: 'Price drop in Barcelona',
        description:
            'Price decreased on 3 properties in Barcelona (Catalunya, Diagonal)',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        city: 'Barcelona',
        type: AlertType.priceChange,
        count: 3,
        stations: ['Catalunya', 'Diagonal'],
      ),
      Alert(
        id: '3',
        title: 'Daily Madrid update',
        description: 'Your daily summary for Madrid metro zones',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        city: 'Madrid',
        type: AlertType.dailySummary,
        count: 12,
        stations: ['Sol', 'Gran Vía', 'Callao', 'Plaza de España'],
      ),
      Alert(
        id: '4',
        title: 'Weekly report ready',
        description: 'Your weekly market report is available',
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        city: 'Madrid',
        type: AlertType.weeklyReport,
        count: 0,
        stations: [],
      ),
    ];
  }

  List<Alert> _getFilteredAlerts(String filter) {
    if (filter == 'All') {
      return _alerts;
    } else {
      return _alerts.where((alert) => alert.city == filter).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('Alerts'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: _tabTitles.map((title) {
                final filteredAlerts = _getFilteredAlerts(title);
                return filteredAlerts.isEmpty
                    ? _buildEmptyState(title)
                    : _buildAlertsList(filteredAlerts);
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Automation page
          Navigator.pushNamed(
            context,
            '/automation',
            arguments: {
              'selectedStations': const [
                'Sol',
                'Gran Vía',
                'Callao',
                'Plaza de España',
              ],
              'centralStation': 'Sol',
            },
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add_alert),
        tooltip: 'Configure Alerts',
      ),
    );
  }

  Widget _buildEmptyState(String filter) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No alerts for $filter',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              // Navigate to Automation page
              Navigator.pushNamed(
                context,
                '/automation',
                arguments: {
                  'selectedStations': const [
                    'Sol',
                    'Gran Vía',
                    'Callao',
                    'Plaza de España',
                  ],
                  'centralStation': 'Sol',
                },
              );
            },
            child: const Text('Set up alerts'),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsList(List<Alert> alerts) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return _buildAlertCard(alert);
      },
    );
  }

  Widget _buildAlertCard(Alert alert) {
    final formatter = DateFormat('MMM d, yyyy • h:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAlertTypeIcon(alert.type),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alert.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (alert.stations.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: alert.stations.map((station) {
                            return Chip(
                              label: Text(
                                station,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.all(0),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatter.format(alert.timestamp),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          if (alert.type == AlertType.newListings ||
                              alert.type == AlertType.priceChange) ...[
                            OutlinedButton(
                              onPressed: () {
                                // Navigate to property results
                                Navigator.pushNamed(context, '/results');
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Theme.of(context).primaryColor,
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 0),
                                minimumSize: const Size(0, 36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text('View Properties'),
                            ),
                          ] else if (alert.type == AlertType.weeklyReport) ...[
                            OutlinedButton(
                              onPressed: () {
                                // Show report
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Theme.of(context).primaryColor,
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 0),
                                minimumSize: const Size(0, 36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text('View Report'),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertTypeIcon(AlertType type) {
    IconData icon;
    Color color;

    switch (type) {
      case AlertType.newListings:
        icon = Icons.new_releases;
        color = Colors.green;
        break;
      case AlertType.priceChange:
        icon = Icons.trending_down;
        color = Colors.blue;
        break;
      case AlertType.dailySummary:
        icon = Icons.summarize;
        color = Colors.orange;
        break;
      case AlertType.weeklyReport:
        icon = Icons.bar_chart;
        color = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: 28,
      ),
    );
  }
}

enum AlertType {
  newListings,
  priceChange,
  dailySummary,
  weeklyReport,
}

class Alert {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final String city;
  final AlertType type;
  final int count;
  final List<String> stations;

  Alert({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.city,
    required this.type,
    required this.count,
    required this.stations,
  });
}
