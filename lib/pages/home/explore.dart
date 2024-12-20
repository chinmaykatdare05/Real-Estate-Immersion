import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Try "Apartment in Mumbai"',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'What can we help you find?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 120,
                  color: Colors.white,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      CategoryTile(title: "Flats", icon: Icons.house),
                      CategoryTile(title: "Bungalows", icon: Icons.bungalow),
                      CategoryTile(title: "Apartments", icon: Icons.apartment),
                      CategoryTile(title: "Cottages", icon: Icons.cottage),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Recommended for you',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // StreamBuilder for Firestore data
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('properties').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading data'));
                    }

                    final properties = snapshot.data?.docs ?? [];

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        final property = properties[index];
                        final title = property['title'] ?? 'No Title';
                        final price = property['price'] ?? 'No Price';
                        final imageUrl = property['imageUrl']?.isNotEmpty == true 
                            ? property['imageUrl'] 
                            : 'assets/images.jpg'; // Fallback to a default image

                        return PropertyTile(title: title, price: price, imageUrl: imageUrl);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Modify PropertyTile to accept title, price, and imageUrl
class PropertyTile extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;

  const PropertyTile({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Icon(Icons.error)); // Handle image loading errors
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(price),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.yellow, size: 18),
                    SizedBox(width: 4),
                    Text('4.8'), // You can replace this with a dynamic rating as well
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// CategoryTile - represents individual categories
class CategoryTile extends StatelessWidget {
  final String title;
  final IconData icon;

  const CategoryTile({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 120,
        height: 100, // Adjust height for better visibility
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}
