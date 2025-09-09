import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projects_flutter/l10n/app_localizations.dart';

class EmployeeLocationRow extends StatefulWidget {
  final double lat;
  final double lng;

  const EmployeeLocationRow({super.key, required this.lat, required this.lng});

  @override
  State<EmployeeLocationRow> createState() => _EmployeeLocationRowState();
}

class _EmployeeLocationRowState extends State<EmployeeLocationRow> {
  String fullAddress = "جاري التحميل...";

  @override
  void initState() {
    super.initState();
    _getAddress();
  }

  Future<void> _getAddress() async {
    final apiKey = 'AIzaSyBg9qPSH4XtCxt6m85m4tp83S1r9yJpXNI';
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${widget.lat},${widget.lng}&language=ar&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK' &&
          data['results'] != null &&
          data['results'].isNotEmpty) {
        var result = data['results'].firstWhere(
              (r) => !(r['types']?.contains('plus_code') ?? false),
          orElse: () => data['results'][0],
        );

        String street = '';
        String city = '';
        String subAdmin = '';
        String country = '';

        if (result['address_components'] != null) {
          for (var comp in result['address_components']) {
            final types = List<String>.from(comp['types']);
            final name = comp['long_name'] ?? '';

            if (types.contains('route')) street = name;
            else if (types.contains('locality')) city = name;
            else if (types.contains('administrative_area_level_2'))
              city = city.isEmpty ? name : city;
            else if (types.contains('administrative_area_level_1')) subAdmin = name;
            else if (types.contains('country')) country = name;
          }
        }

        final addressParts = [street, city, subAdmin, country].where((e) => e.isNotEmpty).toList();

        setState(() {
          fullAddress = addressParts.isNotEmpty ? addressParts.join(", ") : "Address not available";
        });
      } else {
        setState(() {
          fullAddress = "Address not available";
        });
      }
    } catch (e) {
      print("Error fetching address from Google API: $e");
      setState(() {
        fullAddress = "Address not available";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.location_on_outlined, size: 18, color: Colors.blueAccent),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              loc.location,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullAddress,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Text(
                  'Lat: ${widget.lat}, Lng: ${widget.lng}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
