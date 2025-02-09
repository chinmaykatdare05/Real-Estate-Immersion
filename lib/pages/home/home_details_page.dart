import 'package:flutter/material.dart';

class HomeDetailsPage extends StatelessWidget {
  final String imageUrl;
  final String landmark;
  final String area;
  final String price;
  final String hostName;
  final String guests;
  final String bedrooms;
  final String beds;
  final String bathrooms;
  final String address;
  final Map<String, dynamic> amenities;

  const HomeDetailsPage({
    super.key,
    required this.imageUrl,
    required this.landmark,
    required this.area,
    required this.price,
    required this.hostName,
    required this.guests,
    required this.bedrooms,
    required this.beds,
    required this.bathrooms,
    required this.address,
    required this.amenities,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(landmark)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.error, color: Colors.red, size: 40),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(landmark, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('₹$price', style: const TextStyle(fontSize: 20, color: Colors.blueAccent)),
                  const SizedBox(height: 10),
                  Text('Hosted by $hostName', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 10),
                  Text('$guests guests • $bedrooms bedrooms • $beds beds • $bathrooms bathrooms'),
                  const SizedBox(height: 10),
                  Text('Address: $address'),
                  const SizedBox(height: 10),
                  const Text('Amenities:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: amenities.entries.where((entry) => entry.value == true).map((entry) {
                      return Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(entry.key, style: const TextStyle(fontSize: 16)),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
