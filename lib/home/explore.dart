// ignore_for_file: library_private_types_in_public_api, deprecated_member_use
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_details.dart';
import 'event_page.dart';
import 'building.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;
  final List<String> categories = ['Buy', 'Rent'];

  final List<Map<String, dynamic>> propertyTypes = [
    {'name': 'Event', 'icon': Icons.event},
    {'name': 'Building', 'icon': Icons.apartment},
    {'name': 'Pool', 'icon': Icons.pool},
    {'name': 'Garden', 'icon': Icons.park},
    {'name': 'Resort', 'icon': Icons.beach_access},
    {'name': 'Concert', 'icon': Icons.music_note},
    {'name': 'Function', 'icon': Icons.event_seat},
  ];

  final List<Color> pastelColors = [
    Colors.pink.shade50,
    Colors.blue.shade50,
    Colors.orange.shade50,
    Colors.green.shade50,
    Colors.yellow.shade50,
    Colors.purple.shade50,
    Colors.teal.shade50,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Where to?',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: propertyTypes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final property = entry.value;
                      final backgroundColor =
                          pastelColors[index % pastelColors.length];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: InkWell(
                          onTap: () {
                            if (property['name'] == 'Event') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EventPage(),
                                ),
                              );
                            } else if (property['name'] == 'Building') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BuildingPage(),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 85,
                            height: 67,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  property['icon'],
                                  size: 25,
                                  color: Colors.black54,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  property['name'].toString().toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 5),
                const Divider(
                  color: Color.fromARGB(255, 237, 232, 232),
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                const SizedBox(height: 02),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: List.generate(categories.length, (index) {
                        bool isSelected = selectedIndex == index;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color.fromARGB(255, 216, 16, 83)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 5,
                                            )
                                          ]
                                        : [],
                                  ),
                                  margin: isSelected
                                      ? const EdgeInsets.all(3)
                                      : EdgeInsets.zero,
                                ),
                                Text(
                                  categories[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Properties')
                      .where('Sale', isEqualTo: selectedIndex == 0)
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
                        return PropertyCard(property: property);
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

class PropertyCard extends StatelessWidget {
  final QueryDocumentSnapshot property;

  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final bool model3D = property['3D Model'];
    final String address = property['Address'];
    final Map<String, dynamic> amenities = property['Amenities'] ?? {};
    final String ac = amenities['AC']?.toString() ?? '';
    final bool furnish = amenities['Furnish'];
    final bool gas = amenities['Gas'];
    final bool lift = amenities['Lift'];
    final bool parking = amenities['Parking'];
    final String waterSupply = amenities['Water Supply'];
    final bool wifi = amenities['Wifi'];
    final String area = property['Area']?.toString() ?? '';
    final String busStop = property['Bus Stop'];
    final String description = property['Description'];
    final String image = property['Image'] ?? '';
    final String landmark = property['Landmark'];
    final String latitude = property['Latitude']?.toString() ?? '';
    final String longitude = property['Longitude']?.toString() ?? '';
    final String pincode = property['Pincode']?.toString() ?? '';
    final String price = property['Price']?.toString() ?? '';
    final String railwayStn = property['Railway Stn'];
    final String rooms = property['Rooms']?.toString() ?? '';
    final bool sale = property['Sale'];
    final String sellerContact = property['Seller Contact'];
    final String sellerName = property['Seller Name'];
    final String washroom = property['Washroom']?.toString() ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeDetailsPage(
              address: address,
              ac: ac,
              area: area,
              busStop: busStop,
              description: description,
              furnish: furnish,
              gas: gas,
              image: image,
              landmark: landmark,
              latitude: latitude,
              longitude: longitude,
              lift: lift,
              model3D: model3D,
              parking: parking,
              pincode: pincode,
              price: price,
              railwayStn: railwayStn,
              rooms: rooms,
              sale: sale,
              sellerContact: sellerContact,
              sellerName: sellerName,
              waterSupply: waterSupply,
              washroom: washroom,
              wifi: wifi,
              amenities: const {},
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                base64Decode(sanitizeBase64(image)),
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.red, size: 40),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    landmark,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹$price',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

String sanitizeBase64(String base64String) {
  if (base64String.contains(',')) {
    base64String = base64String.split(',').last;
  }
  return base64String.trim();
}
