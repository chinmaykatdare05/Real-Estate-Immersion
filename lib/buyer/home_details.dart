// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, use_super_parameters
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'payment.dart';

class HomeDetailsPage extends StatefulWidget {
  final String ac;
  final Map<String, dynamic> amenities;
  final String area;
  final String address;
  final String busStop;
  final String description;
  final bool furnish;
  final bool gas;
  final String image;
  final String landmark;
  final String latitude;
  final bool lift;
  final String longitude;
  final bool model3D;
  final bool parking;
  final String pincode;
  final String price;
  final String railwayStn;
  final String rooms;
  final bool sale;
  final String sellerContact;
  final String sellerName;
  final String washroom;
  final String waterSupply;
  final bool wifi;

  const HomeDetailsPage({
    super.key,
    required this.ac,
    required this.address,
    required this.amenities,
    required this.area,
    required this.busStop,
    required this.description,
    required this.furnish,
    required this.gas,
    required this.image,
    required this.landmark,
    required this.latitude,
    required this.lift,
    required this.longitude,
    required this.model3D,
    required this.parking,
    required this.pincode,
    required this.price,
    required this.railwayStn,
    required this.rooms,
    required this.sale,
    required this.sellerContact,
    required this.sellerName,
    required this.waterSupply,
    required this.washroom,
    required this.wifi,
  });

  @override
  _HomeDetailsPageState createState() => _HomeDetailsPageState();
}

class _HomeDetailsPageState extends State<HomeDetailsPage> {
  void _show3DModel(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Model Viewer',
                style: TextStyle(color: Colors.black)),
            centerTitle: true,
          ),
          body: const ModelViewer(
            backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
            src: 'assets/home.glb',
            alt: 'A 3D model of my living room',
            ar: true,
            autoRotate: true,
            disableZoom: false,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.image.isNotEmpty)
              Stack(
                children: [
                  Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.address,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.landmark,
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.rooms} rooms, ${widget.washroom} washrooms, ${widget.area} sqft',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pincode: ${widget.pincode}',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'What this place offers',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      if (widget.ac != '0')
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(FontAwesomeIcons.snowflake,
                              color: Colors.blue),
                          title: const Text('Air Conditioning'),
                          subtitle: Text(widget.ac),
                        ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(FontAwesomeIcons.couch,
                            color: Colors.blue),
                        title: const Text('Living Room'),
                        subtitle:
                            Text(widget.furnish ? 'Furnished' : 'Unfurnished'),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(FontAwesomeIcons.fire,
                            color: Colors.blue),
                        title: const Text('Kitchen'),
                        subtitle:
                            Text(widget.gas ? 'Gas Stove' : 'No Gas Stove'),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(FontAwesomeIcons.elevator,
                            color: Colors.blue),
                        title: const Text('Building Facilities'),
                        subtitle:
                            Text(widget.lift ? 'Lift available' : 'No Lift'),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(FontAwesomeIcons.car,
                            color: Colors.blue),
                        title: const Text('Parking'),
                        subtitle: Text(widget.parking
                            ? 'Parking available'
                            : 'No Parking'),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(FontAwesomeIcons.water,
                            color: Colors.blue),
                        title: const Text('Water Supply'),
                        subtitle: Text("Water Supply - ${widget.waterSupply}"),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(FontAwesomeIcons.wifi,
                            color: Colors.blue),
                        title: const Text('Internet'),
                        subtitle:
                            Text(widget.wifi ? 'Wifi available' : 'No Wifi'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nearest Transit',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(FontAwesomeIcons.busAlt,
                            color: Colors.blue),
                        title: const Text('Bus Stop'),
                        subtitle: Text(widget.busStop),
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(FontAwesomeIcons.train,
                            color: Colors.blue),
                        title: const Text('Train Station'),
                        subtitle: Text(widget.railwayStn),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Meet your Host',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.deepOrange,
                        child: Text(
                          widget.sellerName[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.sellerName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.sellerContact,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Where you'll be",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.address,
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 300,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  double.parse(widget.latitude),
                                  double.parse(widget.longitude),
                                ),
                                zoom: 14,
                              ),
                              markers: {
                                Marker(
                                  markerId: const MarkerId('location'),
                                  position: LatLng(
                                    double.parse(widget.latitude),
                                    double.parse(widget.longitude),
                                  ),
                                ),
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
              color: Color.fromARGB(255, 231, 229, 229),
              width: 2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 15, 15, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹ ${widget.price}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (widget.model3D) {
                    _show3DModel(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                ),
                child: widget.model3D
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.threed_rotation, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            '3D Model',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'Reserve',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              if (widget.model3D)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentScreen(propertyData: {
                                'Price': widget.price,
                              })),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 12),
                  ),
                  child: const Text(
                    'Reserve',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
