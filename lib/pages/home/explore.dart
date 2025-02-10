// ignore_for_file: library_private_types_in_public_api
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Helper function to remove the data URL prefix from a Base64 string.
String sanitizeBase64(String base64String) {
  if (base64String.startsWith("data:")) {
    int commaIndex = base64String.indexOf(',');
    if (commaIndex != -1) {
      return base64String.substring(commaIndex + 1);
    }
  }
  return base64String;
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController searchController = TextEditingController();
  int selectedIndex = 0; // 0 for Buy, 1 for Rent
  final List<String> categories = ['Buy', 'Rent'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar removed as requested.
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Slider (Buy / Rent)
                // Search Field
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
                // Slider (Buy / Rent)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
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
                                        ? Colors.blue
                                        : Colors.transparent,
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
                                        : Colors.black87,
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
                // Properties from Firestore filtered by selected type.
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('properties')
                      .where('sale', isEqualTo: selectedIndex == 0)
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
    final Map<String, dynamic> data = property.data() as Map<String, dynamic>;

    final String landmark = property['landmark'] ?? 'No Landmark';
    final String price = property['price'] ?? 'No Price';
    final String description = property['area'] ?? 'Lake and garden views';
    final String hostName = property['hostName'] ?? 'Unknown Host';
    final String guests = property['guests']?.toString() ?? 'N/A';
    final String bedrooms = property['bedrooms']?.toString() ?? 'N/A';
    final String beds = property['beds']?.toString() ?? 'N/A';
    final String bathrooms = property['bathrooms']?.toString() ?? 'N/A';
    final String address = property['address'] ?? 'No Address';
    final Map<String, dynamic> amenities = property['amenities'] ?? {};
    final String imageBase64 =
        data.containsKey('imageBase64') ? data['imageBase64'] as String : "";
    final String imageUrl =
        data.containsKey('imageUrl') ? data['imageUrl'] as String : "";
    final bool useBase64 = imageBase64.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeDetailsPage(
              imageUrl: imageUrl,
              landmark: landmark,
              area: description,
              price: price,
              hostName: hostName,
              guests: guests,
              bedrooms: bedrooms,
              beds: beds,
              bathrooms: bathrooms,
              address: address,
              amenities: amenities,
              imageData: useBase64 ? imageBase64 : imageUrl,
              useBase64: useBase64,
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
              child: useBase64
                  ? Image.memory(
                      base64Decode(sanitizeBase64(imageBase64)),
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: const Center(
                            child:
                                Icon(Icons.error, color: Colors.red, size: 40),
                          ),
                        );
                      },
                    )
                  : (imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.error,
                                    color: Colors.red, size: 40),
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/images.png',
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                        )),
            ),
            // Property details.
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    landmark,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
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
                  const SizedBox(height: 25),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// HomeDetailsPage displays the detailed view of the property.
class HomeDetailsPage extends StatefulWidget {
  final bool useBase64;
  final String imageData;
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
    required this.useBase64,
    required this.imageData,
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
    required String imageUrl,
  });

  @override
  _HomeDetailsPageState createState() => _HomeDetailsPageState();
}

class _HomeDetailsPageState extends State<HomeDetailsPage> {
  DateTimeRange? selectedDates;
  Future<void> _selectDates(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != selectedDates) {
      setState(() {
        selectedDates = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (widget.useBase64) {
      imageWidget = Image.memory(
        base64Decode(sanitizeBase64(widget.imageData)),
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 250,
            color: Colors.grey[200],
            child: const Center(
                child: Icon(Icons.error, color: Colors.red, size: 40)),
          );
        },
      );
    } else {
      if (widget.imageData.isNotEmpty) {
        imageWidget = Image.network(
          widget.imageData,
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 250,
              color: Colors.grey[200],
              child: const Center(
                  child: Icon(Icons.error, color: Colors.red, size: 40)),
            );
          },
        );
      } else {
        imageWidget = Image.asset(
          'assets/images/images.png',
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      }
    }
    return Scaffold(
      // Detailed property view.
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageWidget,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.landmark,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.area,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Hosted by ${widget.hostName}',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                  Text(
                    '${widget.guests} guests • ${widget.bedrooms} bedrooms • ${widget.beds} beds • ${widget.bathrooms} bathrooms',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.address, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Amenities Available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.amenities.entries
                        .where((entry) => entry.value == true)
                        .map((entry) {
                      return Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(entry.key, style: const TextStyle(fontSize: 16)),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Select Dates',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectDates(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDates == null
                                ? 'Choose your dates'
                                : '${selectedDates!.start.day}/${selectedDates!.start.month}/${selectedDates!.start.year} - ${selectedDates!.end.day}/${selectedDates!.end.month}/${selectedDates!.end.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.calendar_today, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Cancellation Policy',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'This reservation is non-refundable. Review the host’s cancellation policy.',
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'House Rules',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text('Check-in: 3:00 PM - 6:00 PM'),
                  const Text('Checkout: Before 11:00 AM'),
                  const Text('No smoking, No pets, 9 guests maximum'),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Safety & Property',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text('Smoke alarm, Security cameras, No noise alarm'),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom bar with price and Reserve button.
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 231, 229, 229),
              width: 2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${widget.price}',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 243, 61, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Reserve',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
