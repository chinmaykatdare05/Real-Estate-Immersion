import 'dart:convert';
import 'package:flutter/material.dart';

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

  // Note: The required 'imageUrl' parameter is kept as in the original code.
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
          padding: const EdgeInsets.all(15.0), // Decreased padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${widget.price}',
                style: const TextStyle(
                  fontSize: 20, // Decreased font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 140, // Decreased width
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 243, 61, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12), // Decreased padding
                  ),
                  child: const Text(
                    'Reserve',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white), // Decreased font size
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
