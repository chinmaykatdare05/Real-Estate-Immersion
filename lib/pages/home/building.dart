import 'package:flutter/material.dart';

class BuildingPage extends StatefulWidget {
  const BuildingPage({super.key});

  @override
  _BuildingPageState createState() => _BuildingPageState();
}

class _BuildingPageState extends State<BuildingPage> {
  bool showDetails = false; // Toggle variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!showDetails) ...[
              // 🏠 Card View
              GestureDetector(
                onTap: () {
                  setState(() {
                    showDetails = true; // Show detailed UI when tapped
                  });
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/building.jpg',
                              width: double.infinity,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.favorite_border, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Flat in Downtown Dubai',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Modern Haven Near Burj Khalifa',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Text(
                              'Free cancellation',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  '₹11,804',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(' night · '),
                                Text(
                                  '₹1,10,973 total',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                  ),
                                ),
                                Spacer(),
                                Icon(Icons.star, color: Colors.black, size: 18),
                                Text(' 4.75 (4)'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // 📜 Detailed UI View
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        showDetails = false; // Go back to card view
                      });
                    },
                  ),
                  Text(
                    'Mountainview Paradise',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.share, color: Colors.black),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite_border, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/building.jpg',
                    width: 350,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entire rental unit in Karjat, India',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '6 guests · 1 bedroom · 1 bed · 2 bathrooms',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.black, size: 18),
                        Text(' 4.94 (51 reviews) · Guest Favourite'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.ac_unit, color: Colors.blue),
                      title: Text('Designed for staying cool'),
                      subtitle: Text('A/C, portable fan, and ceiling fan'),
                    ),
                    ListTile(
                      leading: Icon(Icons.laptop_mac, color: Colors.blue),
                      title: Text('Dedicated workspace'),
                      subtitle: Text('A room with WiFi that’s well suited for working'),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Text(
                            '₹3,440 ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text('/ night'),
                          Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {},
                            child: Text('3D Tour', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
