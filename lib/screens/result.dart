import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPage extends StatelessWidget {
  final int resultCount;
  final List<String> selectedStations;
  final List<PropertyResult> results;
  final String centralStation;

  const ResultPage({
    Key? key,
    required this.resultCount,
    required this.selectedStations,
    required this.results,
    this.centralStation = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
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
                  children: const [
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                    Text(
                      'PyIdealista',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF28A745),
                      ),
                    ),
                    Text(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Property Count Summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F8F1),
                        borderRadius: BorderRadius.circular(8),
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF27AE60),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Button container with count and automate button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Found $resultCount properties in the selected area',
                                style: const TextStyle(fontSize: 14),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/automation',
                                    arguments: {
                                      'selectedStations': selectedStations,
                                      'centralStation': centralStation,
                                    },
                                  );
                                },
                                icon: const Icon(Icons.schedule, size: 16),
                                label: const Text('Automate Search'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF007BFF),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                          const Text(
                            'Searching in stations:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),

                          // List of stations
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: selectedStations.map((station) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('• ',
                                        style: TextStyle(fontSize: 14)),
                                    Expanded(
                                      child: Text(
                                        station,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const Divider(
                      height: 40,
                      thickness: 2,
                      color: Color(0xFFDDDDDD),
                    ),

                    const Text(
                      'Found Properties:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Property grid
                    PropertyGrid(properties: results),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Property Grid Widget
class PropertyGrid extends StatelessWidget {
  final List<PropertyResult> properties;

  const PropertyGrid({
    Key? key,
    required this.properties,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        return PropertyCard(property: properties[index]);
      },
    );
  }
}

// Property Card Widget
class PropertyCard extends StatelessWidget {
  final PropertyResult property;

  const PropertyCard({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Property image
          if (property.images.isNotEmpty)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: Image.network(
                  property.images.first,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            )
          else
            AspectRatio(
              aspectRatio: 1.5,
              child: Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.home, color: Colors.grey),
                ),
              ),
            ),

          // Property details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    property.address,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Price: ${property.price}',
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Rooms: ${property.rooms}',
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Size: ${property.size}',
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'District: ${property.district}',
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Phone: ${property.phone}',
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // View property button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final Uri url = Uri.parse(property.url);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007BFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        textStyle: const TextStyle(fontSize: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text('View Property'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Data model for property results
class PropertyResult {
  final String address;
  final String price;
  final String rooms;
  final String size;
  final String district;
  final String phone;
  final String url;
  final List<String> images;

  PropertyResult({
    required this.address,
    required this.price,
    required this.rooms,
    required this.size,
    required this.district,
    required this.phone,
    required this.url,
    required this.images,
  });

  // Create a sample property result
  static PropertyResult sample() {
    return PropertyResult(
      address: 'Calle Mayor 23, Madrid',
      price: '€950/month',
      rooms: '2',
      size: '75 m²',
      district: 'Centro',
      phone: '+34 612 345 678',
      url: 'https://example.com/property',
      images: ['https://via.placeholder.com/300x200'],
    );
  }
}
