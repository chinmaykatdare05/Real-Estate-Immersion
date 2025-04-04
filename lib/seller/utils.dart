import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
      try {
        pincode = results["address_components"].firstWhere((component) =>
            component["types"].contains("postal_code"))["long_name"];
      } catch (e) {
        pincode = null;
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

/// Picks an image from the given source and returns its bytes.
Future<Uint8List?> pickImage(ImageSource source) async {
  final XFile? file = await ImagePicker().pickImage(source: source);
  return file?.readAsBytes();
}

/// Shows a snack bar with the provided content.
void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content)),
  );
}