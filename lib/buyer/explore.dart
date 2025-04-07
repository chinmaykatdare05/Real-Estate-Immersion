// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously
import 'utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_details.dart';
import 'package:geolocator/geolocator.dart';

int selectedIndex = 0;

Future<List<DocumentSnapshot>> getRecommendedProperties(String address,
    {double maxDistanceKm = 10.0}) async {
  final locationData = await getLatLngPincode(address);
  if (locationData == null) return [];

  final double userLat = locationData["lat"];
  final double userLng = locationData["lng"];

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Properties')
      .where('Sale', isEqualTo: selectedIndex == 0)
      .get();
  List<DocumentSnapshot> allProperties = snapshot.docs;

  List<DocumentSnapshot> recommendedProperties = [];
  for (var doc in allProperties) {
    final property = doc.data() as Map<String, dynamic>;
    final double? propertyLat =
        double.tryParse(property['Latitude']?.toString() ?? "");
    final double? propertyLng =
        double.tryParse(property['Longitude']?.toString() ?? "");
    if (propertyLat != null && propertyLng != null) {
      final double distance =
          calculateDistance(userLat, userLng, propertyLat, propertyLng);
      if (distance <= maxDistanceKm) {
        recommendedProperties.add(doc);
      }
    }
  }
  recommendedProperties.sort((a, b) {
    final Map<String, dynamic> propA = a.data() as Map<String, dynamic>;
    final Map<String, dynamic> propB = b.data() as Map<String, dynamic>;
    final double latA =
        double.tryParse(propA['Latitude']?.toString() ?? "") ?? 0;
    final double lngA =
        double.tryParse(propA['Longitude']?.toString() ?? "") ?? 0;
    final double latB =
        double.tryParse(propB['Latitude']?.toString() ?? "") ?? 0;
    final double lngB =
        double.tryParse(propB['Longitude']?.toString() ?? "") ?? 0;
    final double distA = calculateDistance(userLat, userLng, latA, lngA);
    final double distB = calculateDistance(userLat, userLng, latB, lngB);
    return distA.compareTo(distB);
  });

  return recommendedProperties;
}

Future<List<DocumentSnapshot>> getRecommendedPropertiesByLocation(
    double userLat, double userLng,
    {double maxDistanceKm = 10.0}) async {
  debugPrint("User Lat: $userLat, User Lng: $userLng");
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Properties')
      .where('Sale', isEqualTo: selectedIndex == 0)
      .get();
  List<DocumentSnapshot> allProperties = snapshot.docs;

  List<DocumentSnapshot> recommendedProperties = [];
  for (var doc in allProperties) {
    final property = doc.data() as Map<String, dynamic>;
    final double? propertyLat =
        double.tryParse(property['Latitude']?.toString() ?? "");
    final double? propertyLng =
        double.tryParse(property['Longitude']?.toString() ?? "");
    if (propertyLat != null && propertyLng != null) {
      final double distance =
          calculateDistance(userLat, userLng, propertyLat, propertyLng);
      if (distance <= maxDistanceKm) {
        recommendedProperties.add(doc);
      }
    }
  }
  recommendedProperties.sort((a, b) {
    final Map<String, dynamic> propA = a.data() as Map<String, dynamic>;
    final Map<String, dynamic> propB = b.data() as Map<String, dynamic>;
    final double latA =
        double.tryParse(propA['Latitude']?.toString() ?? "") ?? 0;
    final double lngA =
        double.tryParse(propA['Longitude']?.toString() ?? "") ?? 0;
    final double latB =
        double.tryParse(propB['Latitude']?.toString() ?? "") ?? 0;
    final double lngB =
        double.tryParse(propB['Longitude']?.toString() ?? "") ?? 0;
    final double distA = calculateDistance(userLat, userLng, latA, lngA);
    final double distB = calculateDistance(userLat, userLng, latB, lngB);
    return distA.compareTo(distB);
  });

  return recommendedProperties;
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController searchController = TextEditingController();
  final List<String> categories = ['Buy', 'Rent'];
  List<DocumentSnapshot> searchSuggestions = [];

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(30),
                              child: TextField(
                                controller: searchController,
                                onChanged: (value) async {
                                  if (value.isNotEmpty) {
                                    final recommendedProperties =
                                        await getRecommendedProperties(value);
                                    setState(() {
                                      searchSuggestions = recommendedProperties;
                                    });
                                  } else {
                                    setState(() {
                                      searchSuggestions = [];
                                    });
                                  }
                                },
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
                          const SizedBox(width: 8),
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(30),
                            child: IconButton(
                              icon: const Icon(Icons.my_location),
                              onPressed: () async {
                                final position =
                                    await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.high,
                                );
                                final recommendedPropertiesByLocation =
                                    await getRecommendedPropertiesByLocation(
                                        position.latitude, position.longitude);
                                setState(() {
                                  searchSuggestions =
                                      recommendedPropertiesByLocation;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      if (searchSuggestions.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: searchSuggestions.length,
                            itemBuilder: (context, index) {
                              final property = searchSuggestions[index];
                              final propertyData =
                                  property.data() as Map<String, dynamic>;
                              return ListTile(
                                title: Text(
                                    propertyData['Address'] ?? 'No Address'),
                                subtitle:
                                    Text('₹${propertyData['Price'] ?? 'N/A'}'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeDetailsPage(
                                        address: propertyData['Address'] ?? '',
                                        ac: propertyData['Amenities']?['AC']
                                                ?.toString() ??
                                            '',
                                        area:
                                            propertyData['Area']?.toString() ??
                                                '',
                                        busStop: propertyData['Bus Stop'] ?? '',
                                        description:
                                            propertyData['Description'] ?? '',
                                        furnish: propertyData['Amenities']
                                                ?['Furnish'] ??
                                            false,
                                        gas: propertyData['Amenities']
                                                ?['Gas'] ??
                                            false,
                                        image: propertyData['Image'] ?? '',
                                        landmark:
                                            propertyData['Landmark'] ?? '',
                                        latitude: propertyData['Latitude']
                                                ?.toString() ??
                                            '',
                                        longitude: propertyData['Longitude']
                                                ?.toString() ??
                                            '',
                                        lift: propertyData['Amenities']
                                                ?['Lift'] ??
                                            false,
                                        model3D:
                                            propertyData['3D Model'] ?? false,
                                        parking: propertyData['Amenities']
                                                ?['Parking'] ??
                                            false,
                                        pincode: propertyData['Pincode']
                                                ?.toString() ??
                                            '',
                                        price:
                                            propertyData['Price']?.toString() ??
                                                '',
                                        railwayStn:
                                            propertyData['Railway Stn'] ?? '',
                                        rooms:
                                            propertyData['Rooms']?.toString() ??
                                                '',
                                        sale: propertyData['Sale'] ?? false,
                                        sellerContact:
                                            propertyData['Seller Contact'] ??
                                                '',
                                        sellerName:
                                            propertyData['Seller Name'] ?? '',
                                        waterSupply: propertyData['Amenities']
                                                    ?['Water Supply']
                                                ?.toString() ??
                                            '',
                                        washroom: propertyData['Washroom']
                                                ?.toString() ??
                                            '',
                                        wifi: propertyData['Amenities']
                                                ?['Wifi'] ??
                                            false,
                                        amenities:
                                            propertyData['Amenities'] ?? {},
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
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
                                    gradient: isSelected
                                        ? const LinearGradient(
                                            colors: [
                                              Color.fromARGB(255, 248, 6, 6),
                                              Color.fromARGB(255, 240, 102, 102)
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                    color: isSelected ? null : Colors.white,
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
                const Divider(
                  color: Color.fromARGB(255, 237, 232, 232),
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
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
              child: Image.network(
                image,
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
