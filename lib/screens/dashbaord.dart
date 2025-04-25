import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Form controllers
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtsController = TextEditingController();
  String _operationType = 'rent';

  // Metro stations data - can be loaded from a service in a real app
  final Map<String, List<String>> madridMetroStations = {
    'Line 1': ['Station 1', 'Station 2', 'Station 3'],
    'Line 2': ['Station 4', 'Station 5', 'Station 6'],
  };

  final Map<String, List<String>> barcelonaMetroStations = {
    'Line 1': ['Station 1', 'Station 2', 'Station 3'],
    'Line 2': ['Station 4', 'Station 5', 'Station 6'],
  };

  String? _selectedMadridStation;
  String? _selectedBarcelonaStation;
  int _numberOfStations = 2;
  bool _showResults = false;

  @override
  void dispose() {
    _cityController.dispose();
    _districtsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('PyIdealista'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/alerts');
            },
            tooltip: 'Alerts',
          ),
          IconButton(
            icon: const Icon(Icons.schedule),
            onPressed: () {
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
            tooltip: 'Automation',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                    const Text(
                      'PyIdealista',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF28A745),
                      ),
                    ),
                    const Text(
                      'A simpler solution for your housing needs!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Results Section (conditionally shown)
                    if (_showResults) _buildResultsSection(),

                    // City and District Selection Form
                    _buildFormSection(
                      title: 'City and District Selection',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter the city you want to rent in:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              hintText: 'Madrid, Barcelona, etc.',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Enter the Districts you want to rent in',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            'One per line',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7F8C8D),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _districtsController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: 'Centro\nSalamanca\nChamberí',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Select Operation Type:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'rent',
                                groupValue: _operationType,
                                onChanged: (value) {
                                  setState(() {
                                    _operationType = value!;
                                  });
                                },
                                activeColor: const Color(0xFF28A745),
                              ),
                              const Text('Rent'),
                              const SizedBox(width: 20),
                              Radio<String>(
                                value: 'buy',
                                groupValue: _operationType,
                                onChanged: (value) {
                                  setState(() {
                                    _operationType = value!;
                                  });
                                },
                                activeColor: const Color(0xFF28A745),
                              ),
                              const Text('Buy'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to results page with mock data
                              Navigator.pushNamed(context, '/results');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF28A745),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Search Properties'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Central Location Finder Section
                    _buildFormSection(
                      title: 'Central Location Finder',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Madrid Metro
                          const Text(
                            'Madrid Metro Search',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Select the central metro station:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildMetroDropdown(
                            stations: madridMetroStations,
                            selectedValue: _selectedMadridStation,
                            onChanged: (value) {
                              setState(() {
                                _selectedMadridStation = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          const Text(
                            'Enter the number of stations around it:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildNumberStepper(),
                          const SizedBox(height: 16),

                          const Text(
                            'Select Operation Type:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'rent',
                                groupValue: _operationType,
                                onChanged: (value) {
                                  setState(() {
                                    _operationType = value!;
                                  });
                                },
                                activeColor: const Color(0xFF28A745),
                              ),
                              const Text('Rent'),
                              const SizedBox(width: 20),
                              Radio<String>(
                                value: 'buy',
                                groupValue: _operationType,
                                onChanged: (value) {
                                  setState(() {
                                    _operationType = value!;
                                  });
                                },
                                activeColor: const Color(0xFF28A745),
                              ),
                              const Text('Buy'),
                            ],
                          ),
                          const SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: () {
                              // Navigate to results page with mock data
                              Navigator.pushNamed(context, '/results');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF28A745),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Search Madrid Properties'),
                          ),

                          const SizedBox(height: 24),

                          // Barcelona Metro
                          const Text(
                            'Barcelona Metro Search',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Select the central metro station:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildMetroDropdown(
                            stations: barcelonaMetroStations,
                            selectedValue: _selectedBarcelonaStation,
                            onChanged: (value) {
                              setState(() {
                                _selectedBarcelonaStation = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          const Text(
                            'Enter the number of stations around it:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildNumberStepper(),
                          const SizedBox(height: 16),

                          const Text(
                            'Select Operation Type:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'rent',
                                groupValue: _operationType,
                                onChanged: (value) {
                                  setState(() {
                                    _operationType = value!;
                                  });
                                },
                                activeColor: const Color(0xFF28A745),
                              ),
                              const Text('Rent'),
                              const SizedBox(width: 20),
                              Radio<String>(
                                value: 'buy',
                                groupValue: _operationType,
                                onChanged: (value) {
                                  setState(() {
                                    _operationType = value!;
                                  });
                                },
                                activeColor: const Color(0xFF28A745),
                              ),
                              const Text('Buy'),
                            ],
                          ),
                          const SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: () {
                              // Navigate to results page with mock data
                              Navigator.pushNamed(context, '/results');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF28A745),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Search Barcelona Properties'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF28A745),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildMetroDropdown({
    required Map<String, List<String>> stations,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    List<DropdownMenuItem<String>> items = [];

    stations.forEach((line, stationsList) {
      // Add line header
      items.add(
        DropdownMenuItem<String>(
          enabled: false,
          child: Text(
            line,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      );

      // Add stations under this line
      for (var station in stationsList) {
        items.add(
          DropdownMenuItem<String>(
            value: station,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(station),
            ),
          ),
        );
      }
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        hint: const Text('Choose a station'),
        isExpanded: true,
        underline: const SizedBox(),
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNumberStepper() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _numberOfStations > 1
                ? () {
                    setState(() {
                      _numberOfStations--;
                    });
                  }
                : null,
          ),
          Text(
            '$_numberOfStations',
            style: const TextStyle(fontSize: 16),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _numberOfStations < 5
                ? () {
                    setState(() {
                      _numberOfStations++;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    // Mock data for property results
    final List<Map<String, dynamic>> properties = [
      {
        'address': 'Calle Mayor 23, Madrid',
        'price': '€950/month',
        'rooms': '2',
        'size': '75 m²',
        'district': 'Centro',
        'url': 'https://example.com/property1',
      },
      {
        'address': 'Calle Serrano 45, Madrid',
        'price': '€1200/month',
        'rooms': '3',
        'size': '90 m²',
        'district': 'Salamanca',
        'url': 'https://example.com/property2',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Property Count Summary
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F8F1),
            borderRadius: BorderRadius.circular(4),
            border: const Border(
              left: BorderSide(
                color: Color(0xFF2ECC71),
                width: 5,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Property Search Results',
                style: TextStyle(
                  color: Color(0xFF27AE60),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Found 24 properties in the selected area'),
              const SizedBox(height: 10),
              const Text('Searching in stations:'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('• Centro'),
                  Text('• Salamanca'),
                  Text('• Chamberí'),
                ],
              ),
            ],
          ),
        ),

        // Property Results
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Found Properties:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            ...properties
                .map((property) => _buildPropertyCard(property))
                .toList(),
          ],
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property['address'],
            style: const TextStyle(
              color: Color(0xFF28A745),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 15,
            runSpacing: 5,
            children: [
              Text('Price: ${property['price']}'),
              Text('Rooms: ${property['rooms']}'),
              Text('Size: ${property['size']}'),
              Text('District: ${property['district']}'),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement opening the property URL
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF28A745),
              foregroundColor: Colors.white,
            ),
            child: const Text('View Property'),
          ),
        ],
      ),
    );
  }
}
