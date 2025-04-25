import 'package:flutter/material.dart';

import '../services/api_service.dart';

class AutomationScreen extends StatefulWidget {
  final List<String> selectedStations;
  final String centralStation;

  const AutomationScreen({
    Key? key,
    required this.selectedStations,
    required this.centralStation,
  }) : super(key: key);

  @override
  State<AutomationScreen> createState() => _AutomationScreenState();
}

class _AutomationScreenState extends State<AutomationScreen> {
  final ApiService _apiService = ApiService();
  final Map<String, bool> _stationNotifyMap = {};
  String _frequency = 'daily';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize the station notification map
    for (var station in widget.selectedStations) {
      _stationNotifyMap[station] = false;
    }
  }

  Future<void> _saveNotificationSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the list of stations to notify (those that are toggled on)
      final List<String> stationsToNotify = _stationNotifyMap.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      // Save settings using the API service
      final success = await _apiService.setAutomationSettings(
        stationsToNotify: stationsToNotify,
        frequency: _frequency,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification settings saved successfully!'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Failed to save notification settings. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('Automate Search'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF333333),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCard(
                  child: widget.selectedStations.isNotEmpty
                      ? _buildNotificationForm()
                      : _buildEmptyState(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(30),
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildCardHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notification Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Get updates when new properties match your search criteria',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 15),
        const Divider(color: Color(0xFFEEEEEE)),
      ],
    );
  }

  Widget _buildNotificationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Station toggles
        ...widget.selectedStations
            .map((station) => _buildStationToggle(station)),

        const SizedBox(height: 30),

        // Frequency selection
        const Text(
          'How often would you like to receive notifications?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF444444),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFDDDDDD)),
          ),
          child: DropdownButtonFormField<String>(
            value: _frequency,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
            items: const [
              DropdownMenuItem(value: 'daily', child: Text('Daily Updates')),
              DropdownMenuItem(value: 'hourly', child: Text('Hourly Updates')),
              DropdownMenuItem(
                  value: 'realtime', child: Text('Real-time Updates')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _frequency = value;
                });
              }
            },
          ),
        ),

        const SizedBox(height: 25),

        // Save button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveNotificationSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBackgroundColor: const Color(0xFF4CAF50).withOpacity(0.6),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.notifications_active, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Save Notification Settings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildStationToggle(String station) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              station,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF444444),
              ),
            ),
          ),
          Switch(
            value: _stationNotifyMap[station] ?? false,
            onChanged: (value) {
              setState(() {
                _stationNotifyMap[station] = value;
              });
            },
            activeColor: const Color(0xFF4CAF50),
            activeTrackColor: const Color(0xFF4CAF50).withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search,
            size: 64,
            color: Color(0xFFDDDDDD),
          ),
          const SizedBox(height: 20),
          const Text(
            'No stations selected for automation.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Go back to search results
            },
            child: const Text(
              'Go back to search results and select stations first',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
