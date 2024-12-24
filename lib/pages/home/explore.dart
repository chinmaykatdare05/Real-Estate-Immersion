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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Where to?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                // Horizontal List of Categories
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('Amazing Views');
                        },
                        child: categoryIcon(Icons.landscape, "Amazing views"),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Icons');
                        },
                        child: categoryIcon(Icons.star, "Icons"),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Amazing Pools');
                        },
                        child: categoryIcon(Icons.pool, "Amazing pools"),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Farm Houses');
                        },
                        child: categoryIcon(Icons.agriculture, "Farms"),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Mansions');
                        },
                        child: categoryIcon(Icons.house, "Mansions"),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Camping Sites');
                        },
                        child: categoryIcon(Icons.fireplace, "Camping"),
                      ),
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
                  stream: FirebaseFirestore.instance
                      .collection('properties')
                      .snapshots(),
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
                        final imageUrl = property['imageUrl']?.isNotEmpty ==
                                true
                            ? property['imageUrl']
                            : 'assets/images.jpg'; // Fallback to a default image

                        return PropertyTile(
                            title: title, price: price, imageUrl: imageUrl);
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailsPage(
              title: title,
              price: price,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Card(
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
                return const Center(
                    child: Icon(Icons.error)); // Handle image loading errors
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(price),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 18),
                      SizedBox(width: 4),
                      Text('4.8'), // Replace with dynamic rating if needed
                    ],
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

class PropertyDetailsPage extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;

  const PropertyDetailsPage({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Icon(Icons.error));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Property Description:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This is a placeholder description for the property. '
                  'You can update this text to include dynamic content fetched from Firestore.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Action for booking or viewing a 3D model
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('3D Model or Booking Action!')),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.blue,
          ),
          child: const Text('View 3D Model', style: TextStyle(fontSize: 18)),
        ),
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

Widget categoryIcon(IconData icon, String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Column(
      children: [
        Icon(icon, size: 30),
        Text(title),
      ],
    ),
  );
}
