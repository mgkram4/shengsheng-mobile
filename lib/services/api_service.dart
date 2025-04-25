import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:5000'; // Flask default port

  // Auth methods
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'username': username,
          'password': password,
        },
      );

      return response.statusCode == 200 || response.statusCode == 302;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/logout'));
      return response.statusCode == 200 || response.statusCode == 302;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  // Metro stations data
  Future<Map<String, List<String>>> getMadridMetroStations() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/metro/madrid'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          final Map<String, dynamic> stationsData = data['data'];

          // Convert the dynamic data to the expected type
          final Map<String, List<String>> result = {};
          stationsData.forEach((key, value) {
            if (value is List) {
              result[key] = List<String>.from(value);
            }
          });

          return result;
        }
      }

      throw Exception('Failed to load Madrid metro stations');
    } catch (e) {
      print('Get Madrid metro stations error: $e');
      throw Exception('Failed to load Madrid metro stations');
    }
  }

  Future<Map<String, List<String>>> getBarcelonaMetroStations() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/api/metro/barcelona'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          final Map<String, dynamic> stationsData = data['data'];

          // Convert the dynamic data to the expected type
          final Map<String, List<String>> result = {};
          stationsData.forEach((key, value) {
            if (value is List) {
              result[key] = List<String>.from(value);
            }
          });

          return result;
        }
      }

      throw Exception('Failed to load Barcelona metro stations');
    } catch (e) {
      print('Get Barcelona metro stations error: $e');
      throw Exception('Failed to load Barcelona metro stations');
    }
  }

  // Property search methods
  Future<List<Property>> searchProperties({
    required String city,
    required String districts,
    String operation = 'rent',
    String? maxPrice,
    String? minPrice,
    String? minRooms,
    List<String>? floorTypes,
    String? elevator,
  }) async {
    try {
      final Map<String, String> body = {
        'city': city,
        'districts': districts,
        'operation': operation,
      };

      if (maxPrice != null) body['max_price'] = maxPrice;
      if (minPrice != null) body['min_price'] = minPrice;
      if (minRooms != null) body['min_rooms'] = minRooms;
      if (elevator != null) body['elevator'] = elevator;

      // For floor types, which is a list, we need special handling
      if (floorTypes != null && floorTypes.isNotEmpty) {
        for (int i = 0; i < floorTypes.length; i++) {
          body['floor_types'] = floorTypes[i];
        }
      }

      final response = await http.post(
        Uri.parse('$baseUrl/result'),
        body: body,
      );

      if (response.statusCode == 200) {
        // Parse the HTML response or JSON if the endpoint is configured to return JSON
        // This is just a placeholder - you'll need to parse the actual response format
        // from your Flask backend
        return []; // Replace with actual parsing
      }

      throw Exception('Failed to search properties');
    } catch (e) {
      print('Search properties error: $e');
      throw Exception('Failed to search properties');
    }
  }

  // Central location search methods
  Future<List<Property>> searchCentralLocation({
    required String city,
    required String centralStation,
    required int numberOfStations,
    String operation = 'rent',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/central-location-${city.toLowerCase()}'),
        body: {
          'central_location': centralStation,
          'number_of_stations': numberOfStations.toString(),
          'operation': operation,
        },
      );

      if (response.statusCode == 200) {
        // Parse the HTML response or JSON if the endpoint is configured to return JSON
        // This is just a placeholder - you'll need to parse the actual response format
        return []; // Replace with actual parsing
      }

      throw Exception('Failed to search central location');
    } catch (e) {
      print('Search central location error: $e');
      throw Exception('Failed to search central location');
    }
  }

  // Automation methods
  Future<bool> setAutomationSettings({
    required List<String> stationsToNotify,
    required String frequency,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'frequency': frequency,
      };

      // Add each station to the body with the same key
      for (int i = 0; i < stationsToNotify.length; i++) {
        body['station_notify'] = stationsToNotify[i];
      }

      final response = await http.post(
        Uri.parse('$baseUrl/save-automation-settings'),
        body: body,
      );

      return response.statusCode == 200 || response.statusCode == 302;
    } catch (e) {
      print('Set automation settings error: $e');
      return false;
    }
  }

  // Get new listings
  Future<List<Property>> getNewListings() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/new-listings'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Property.fromJson(item)).toList();
      }

      throw Exception('Failed to get new listings');
    } catch (e) {
      print('Get new listings error: $e');
      throw Exception('Failed to get new listings');
    }
  }
}

// Property model
class Property {
  final String address;
  final String price;
  final String rooms;
  final String size;
  final String district;
  final String url;
  final String phone;
  final List<String> images;

  Property({
    required this.address,
    required this.price,
    required this.rooms,
    required this.size,
    required this.district,
    required this.url,
    required this.phone,
    required this.images,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    List<String> imagesList = [];

    if (json['images'] != null) {
      if (json['images'] is List) {
        imagesList = List<String>.from(json['images']);
      } else if (json['images'] is String) {
        // Handle case where images might be a comma-separated string
        imagesList = [json['images']];
      }
    }

    return Property(
      address: json['address'] ?? '',
      price: json['price'] ?? '',
      rooms: json['rooms'] ?? '',
      size: json['size'] ?? '',
      district: json['district'] ?? '',
      url: json['url'] ?? '',
      phone: json['phone'] ?? '',
      images: imagesList,
    );
  }
}
