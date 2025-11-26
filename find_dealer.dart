import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class FindDealerScreen extends StatefulWidget {
  const FindDealerScreen({super.key});

  @override
  State<FindDealerScreen> createState() => _FindDealerScreenState();
}

class _FindDealerScreenState extends State<FindDealerScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _loading = false;
  List<dynamic> _places = [];
  String? _errorMessage;

  // 🗝️ Replace this with your actual Geoapify API Key
  final String geoapifyApiKey = "dc02d1ac7b834f5c9084a257ff0637e7";

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable them.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied. Please enable them from settings.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  ///  Search nearby dealers using Geoapify Places API
  Future<void> _searchDealers(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
      _places = [];
    });

    try {
      Position position = await _determinePosition();

      final categoryMap = {
        "cement": "commercial.houseware_and_hardware.building_materials",
        "steel": "commercial.houseware_and_hardware.building_materials",
        "paint": "commercial.houseware_and_hardware.building_materials.paint",
        "tiles": "commercial.houseware_and_hardware.building_materials.tiles",
        "tools": "commercial.houseware_and_hardware.hardware_and_tools",
        "wood": "commercial.houseware_and_hardware.building_materials",
        "plumbing": "commercial.houseware_and_hardware.building_materials",
        "sand": "commercial.houseware_and_hardware.building_materials",
        "aggregate": "commercial.houseware_and_hardware.building_materials",
      };

      // Primary category
      String selectedCategory =
          categoryMap[query.toLowerCase()] ??
          "commercial.houseware_and_hardware";

      // Function to fetch places with given category
      Future<List> fetchPlaces(String category) async {
        final url = Uri.parse(
          'https://api.geoapify.com/v2/places?categories=$category'
          '&filter=circle:${position.longitude},${position.latitude},200000'
          '&bias=proximity:${position.longitude},${position.latitude}'
          '&limit=50&apiKey=$geoapifyApiKey',
        );

        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return data["features"] ?? [];
        }
        return [];
      }

      // Try main category first
      List results = await fetchPlaces(selectedCategory);

      // If no results, broaden the search
      if (results.isEmpty) {
        results = await fetchPlaces("commercial");
      }

      if (results.isEmpty) {
        setState(() => _errorMessage = "No dealers found nearby.");
      } else {
        setState(() => _places = results);
      }
    } catch (e) {
      setState(() => _errorMessage = "Error: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  ///    Open location in Google Maps
  Future<void> _openInMaps(double lat, double lon) async {
    final Uri googleMapsUri = Uri.parse(
      'geo:$lat,$lon?q=$lat,$lon(Google Maps)',
    );

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      // fallback to web version if the app fails
      final Uri webUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lon',
      );
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to open Google Maps.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Find Dealer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onSubmitted: _searchDealers,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: "Search dealers e.g. cement, steel...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                      child: Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : _places.isEmpty
                  ? const Center(
                      child: Text(
                        "Search for nearby dealers.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _places.length,
                      itemBuilder: (context, index) {
                        final place = _places[index];
                        final props = place["properties"];
                        final name =
                            props["name"] ?? "${_searchController.text} dealer";
                        final lat = props["lat"];
                        final lon = props["lon"];
                        final address = props["formatted"];

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(address ?? 'No address'),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.map,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () => _openInMaps(lat, lon),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
