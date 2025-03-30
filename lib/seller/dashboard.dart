// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'add_property.dart';

class SellerDashboard extends StatefulWidget {
  final String sellerId;
  final String sellerName;

  const SellerDashboard(
      {super.key, required this.sellerId, required this.sellerName});

  @override
  _SellerDashboardState createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _changePrice(String propertyId, double newPrice) async {
    await _firestore
        .collection('Properties')
        .doc(propertyId)
        .update({'Price': newPrice});
  }

  Future<void> _deleteProperty(String propertyId, String imagePath) async {
    try {
      await _firestore.collection('Properties').doc(propertyId).delete();
      await _storage.ref(imagePath).delete();
    } catch (e) {
      debugPrint('Error deleting property: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Welcome, ${widget.sellerName}!',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('Properties')
                  .where('sellerId', isEqualTo: widget.sellerId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No properties found.'));
                }
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['Name'] ?? 'Property'),
                      subtitle: Text('Price: \$${data['Price']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              double? newPrice = await _showPriceDialog(
                                  context, data['Price']);
                              if (newPrice != null) {
                                _changePrice(doc.id, newPrice);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _deleteProperty(doc.id, data['Image']),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
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

  Future<double?> _showPriceDialog(
      BuildContext context, double currentPrice) async {
    TextEditingController priceController =
        TextEditingController(text: currentPrice.toString());
    return showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Price'),
        content: TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Enter new price'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              double? newPrice = double.tryParse(priceController.text);
              if (newPrice != null) {
                Navigator.pop(context, newPrice);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
