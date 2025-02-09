// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'home_details_page.dart';

class ExplorePage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed AppBar as requested.
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 10),
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
                        return PropertyTile(property: property);
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
  final QueryDocumentSnapshot property;

  const PropertyTile({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final String landmark = property['landmark'] ?? 'No Landmark';
    final String price = property['price'] ?? 'No Price';
    final String imageUrl = property['imageUrl']?.isNotEmpty == true
        ? property['imageUrl']
        : 'assets/images/images.png';
    final String area = property['area'] ?? 'Unknown Area';
    final String hostName = property['hostName'] ?? 'Unknown Host';
    final String guests = property['guests']?.toString() ?? 'N/A';
    final String bedrooms = property['bedrooms']?.toString() ?? 'N/A';
    final String beds = property['beds']?.toString() ?? 'N/A';
    final String bathrooms = property['bathrooms']?.toString() ?? 'N/A';
    final String address = property['address'] ?? 'No Address';
    final Map<String, dynamic> amenities = property['amenities'] ?? {};

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeDetailsPage(
              imageUrl: imageUrl,
              landmark: landmark,
              area: area,
              price: price,
              hostName: hostName,
              guests: guests,
              bedrooms: bedrooms,
              beds: beds,
              bathrooms: bathrooms,
              address: address,
              amenities: amenities,
              //location: 'Kodaikanal, Tamil Nadu',
              //distance: '2.5 km from city center',
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: landmark,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 40),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(landmark,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('₹$price',
                      style: const TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeDetailsPage extends StatefulWidget {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
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
                  Text(widget.landmark,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(widget.area,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(color: Color.fromARGB(255, 255, 255, 255)),
                  Text('Hosted by ${widget.hostName}',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 212, 11, 11))),
                  const SizedBox(height: 16),
                  const Divider(color: Color.fromARGB(255, 255, 255, 255)),
                  Text(
                      '${widget.guests} guests • ${widget.bedrooms} bedrooms • ${widget.beds} beds • ${widget.bathrooms} bathrooms',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  Text(widget.address, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  // const SizedBox(height: 16),
                  // const Text('The Glasshouse! This charming glass room offers cosy furnishings and beautiful French windows, as well as access to modern amenities and an expansive outdoor space.', style: TextStyle(fontSize: 16)),
                  // const SizedBox(height: 16),
                  //const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Amenities Available',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  const Text('Cancellation Policy',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text(
                      'This reservation is non-refundable. Review the host’s cancellation policy.'),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('House Rules',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text('Check-in: 3:00 PM - 6:00 PM'),
                  const Text('Checkout: Before 11:00 AM'),
                  const Text('No smoking, No pets, 9 guests maximum'),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Safety & Property',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text('Smoke alarm, Security cameras, No noise alarm'),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Color.fromARGB(255, 231, 229, 229), width: 2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₹${widget.price}',
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 243, 61, 70),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Reserve',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
