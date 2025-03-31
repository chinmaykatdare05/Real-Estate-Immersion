import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> getLatLngPincode(String address) async {
  const apiKey = "AIzaSyCQghbrbSPfhZ0GC5fZ5eGhPSofstkt1vU";
  const baseUrl = "https://maps.googleapis.com/maps/api/geocode/json";

  final uri = Uri.parse(baseUrl).replace(queryParameters: {
    'address': address,
    'key': apiKey,
  });

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (data["status"] == "OK") {
      final results = data["results"][0];
      final latitude = results["geometry"]["location"]["lat"];
      final longitude = results["geometry"]["location"]["lng"];

      String? pincode;
      for (var component in results["address_components"]) {
        if (component["types"].contains("postal_code")) {
          pincode = component["long_name"];
          break;
        }
      }

      return {
        'latitude': latitude,
        'longitude': longitude,
        'pincode': pincode,
      };
    }
  }

  return null;
}
