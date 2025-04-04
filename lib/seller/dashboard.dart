// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_property.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  _SellerDashboardState createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> fetchUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return await _firestore.collection('Users').doc(uid).get();
  }

  Future<void> _changePrice(String propertyId, String newPrice) async {
    try {
      await _firestore
          .collection('Properties')
          .doc(propertyId)
          .update({'Price': newPrice});
    } catch (e) {
      debugPrint('Error updating price: $e');
    }
  }

  Future<void> _deleteProperty(String propertyId) async {
    try {
      await _firestore.collection('Properties').doc(propertyId).delete();
    } catch (e) {
      debugPrint('Error deleting property: $e');
    }
  }

  Future<String?> _showPriceDialog(
      BuildContext context, String currentPrice) async {
    TextEditingController priceController =
        TextEditingController(text: currentPrice.toString());
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Change Price'),
        content: TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter new price',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              String? newPrice = priceController.text;
              Navigator.pop(context, newPrice);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyList(String sellerName) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Properties')
          .where('Seller Name', isEqualTo: sellerName)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No properties found.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    data['Address'] ?? 'Property',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Price: ₹ ${data['Price']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () async {
                          String? newPrice =
                              await _showPriceDialog(context, data['Price']);
                          if (newPrice != null) {
                            _changePrice(
                                snapshot.data!.docs[index].id, newPrice);
                            setState(() {});
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () =>
                            _deleteProperty(snapshot.data!.docs[index].id),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          // Show loading indicator while fetching user data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Display error message if there's an error or data doesn't exist
          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(
              child: Text('Error loading user data.'),
            );
          }
          // Get the seller name from the user data. Fallback to email if Name is null.
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          final String sellerName =
              userData['Name'] ?? FirebaseAuth.instance.currentUser!.email!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Welcome, $sellerName!',
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              // const Divider(thickness: 1),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Your Listed Properties',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child: _buildPropertyList(sellerName)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProperty()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
