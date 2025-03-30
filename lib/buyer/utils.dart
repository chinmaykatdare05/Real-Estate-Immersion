import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

/// Converts an address string into latitude, longitude, and pincode.
Future<Map<String, dynamic>?> getLatLngPincode(String address) async {
  const String apiKey = "AIzaSyCQghbrbSPfhZ0GC5fZ5eGhPSofstkt1vU";
  const String baseUrl = "https://maps.googleapis.com/maps/api/geocode/json";
  final Uri url =
      Uri.parse("$baseUrl?address=${Uri.encodeComponent(address)}&key=$apiKey");

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data["status"] == "OK") {
      final results = data["results"][0];
      final double lat = results["geometry"]["location"]["lat"];
      final double lng = results["geometry"]["location"]["lng"];
      String? pincode;
      for (var component in results["address_components"]) {
        if ((component["types"] as List).contains("postal_code")) {
          pincode = component["long_name"];
          break;
        }
      }
      return {"lat": lat, "lng": lng, "pincode": pincode};
    }
  }
  return null;
}

double _deg2rad(double deg) => deg * (pi / 180);

/// Calculates the distance between two coordinates in kilometers using the Haversine formula.
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double R = 6371; // Radius of Earth in kilometers
  final double dLat = _deg2rad(lat2 - lat1);
  final double dLon = _deg2rad(lon2 - lon1);
  final double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  final double distance = R * c;
  return distance;
}
