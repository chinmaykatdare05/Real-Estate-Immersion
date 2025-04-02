// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter03/seller/storage_methods.dart';
import 'package:flutter03/seller/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);

class AddProperty extends StatefulWidget {
  const AddProperty({super.key});

  @override
  _AddPropertyState createState() => _AddPropertyState();
}

class _AddPropertyState extends State<AddProperty> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<DocumentSnapshot> _userData;
  String? sellerName;
  String? sellerContact;
  String imageUrl = '';
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    _userData = fetchUserData();
  }

  Future<DocumentSnapshot> fetchUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  }

  Future<void> selectAndUploadImage(ImageSource source) async {
    // Pick the image using our utility function.
    Uint8List? pickedImage = await pickImage(source);
    if (pickedImage != null) {
      setState(() {
        imageBytes = pickedImage;
        imageController.text = "Image selected";
      });
    }
  }

  /// Displays a dialog to let the user choose the image source.
  Future<ImageSource?> chooseImageSource() async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose Image Source"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text("Camera"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text("Gallery"),
          ),
        ],
      ),
    );
  }

  Future<String> handleImageUpload() async {
    // Upload the image.
    String imageUrl =
        await StorageMethods().uploadImage('property_images', imageBytes!);
    if (imageUrl.isEmpty) {
      showSnackBar("Failed to upload image.", context);
      return '';
    }

    // Show a success message.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Image uploaded successfully!")),
    );

    return imageUrl;
  }

  // Future<String?> uploadImage(String address, pickedFile) async {
  //   //Get a reference to storage root
  //   Reference referenceRoot = FirebaseStorage.instance.ref();
  //   Reference referenceDirImages = referenceRoot.child(address);
  //   //Create a reference for the image to be stored
  //   Reference referenceImageToUpload = referenceDirImages.child('name');
  //   //Handle errors/success
  //   try {
  //     //Store the file
  //     await referenceImageToUpload.putFile(File(pickedFile!.path));
  //     //Success: get the download URL
  //     imageUrl = await referenceImageToUpload.getDownloadURL();
  //     return imageUrl;
  //   } catch (error) {
  //     //Handle any errors
  //     print('Error occurred while uploading image: $error');
  //     return null;
  //   }
  // }

  // Controllers for property fields
  final TextEditingController addressController = TextEditingController();
  final TextEditingController acController = TextEditingController();
  final TextEditingController waterSupplyController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController busStopController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController railwayStnController = TextEditingController();
  final TextEditingController roomsController = TextEditingController();
  final TextEditingController washroomController = TextEditingController();

  // Boolean fields for property and amenities
  bool model3D = false;
  bool furnish = false;
  bool gas = false;
  bool lift = false;
  bool parking = false;
  bool wifi = false;
  bool sale = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF757575)),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    "Add Property",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // 3D Model Switch
                        SwitchListTile(
                          title: const Text("3D Model"),
                          value: model3D,
                          onChanged: (value) {
                            setState(() {
                              model3D = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        // Address Field
                        TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                            hintText: "Enter property address",
                            labelText: "Address",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide:
                                  const BorderSide(color: Color(0xFFFF7643)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Address is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // Amenities Section Title
                        Text(
                          "Amenities",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        // AC Field (Int input)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Number of AC units",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  final currentValue =
                                      int.tryParse(acController.text) ?? 0;
                                  if (currentValue > 0) {
                                    acController.text =
                                        (currentValue - 1).toString();
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: acController
                                  ..text = acController.text.isEmpty
                                      ? '0'
                                      : acController.text,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  final currentValue =
                                      int.tryParse(acController.text) ?? 0;
                                  acController.text =
                                      (currentValue + 1).toString();
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Furnish Switch
                        SwitchListTile(
                          title: const Text("Furnished"),
                          value: furnish,
                          onChanged: (value) {
                            setState(() {
                              furnish = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        // Gas Switch
                        SwitchListTile(
                          title: const Text("Gas"),
                          value: gas,
                          onChanged: (value) {
                            setState(() {
                              gas = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        // Lift Switch
                        SwitchListTile(
                          title: const Text("Lift"),
                          value: lift,
                          onChanged: (value) {
                            setState(() {
                              lift = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        // Parking Switch
                        SwitchListTile(
                          title: const Text("Parking"),
                          value: parking,
                          onChanged: (value) {
                            setState(() {
                              parking = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        // Water Supply Field
                        TextFormField(
                          controller: waterSupplyController,
                          decoration: InputDecoration(
                            hintText:
                                "Enter water supply timing (eg. 24/7, 6-8pm)",
                            labelText: "Water Supply",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide:
                                  const BorderSide(color: Color(0xFFFF7643)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Water Supply is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // Wifi Switch
                        SwitchListTile(
                          title: const Text("Wifi"),
                          value: wifi,
                          onChanged: (value) {
                            setState(() {
                              wifi = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: areaController
                            ..text = areaController.text.isEmpty
                                ? '0'
                                : areaController.text,
                          decoration: InputDecoration(
                            hintText: "Enter property area",
                            labelText: "Area",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide:
                                  const BorderSide(color: Color(0xFFFF7643)),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Area is required';
                            }
                            if (int.tryParse(value) == null ||
                                int.parse(value) < 0) {
                              return 'Area must be a non-negative integer';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: busStopController,
                          decoration: InputDecoration(
                            hintText: "Enter nearby bus stop",
                            labelText: "Bus Stop",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide:
                                  const BorderSide(color: Color(0xFFFF7643)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bus Stop is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            hintText: "Enter property description",
                            labelText: "Description",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide:
                                  const BorderSide(color: Color(0xFFFF7643)),
                            ),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // Image Input Field
                        TextFormField(
                          controller: imageController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "Upload property image",
                            labelText: "Image",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide:
                                  const BorderSide(color: Color(0xFFFF7643)),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.upload_file,
                                  color: Color(0xFF757575)),
                              onPressed: () async {
                                final ImageSource? source =
                                    await chooseImageSource();
                                if (source == null) return;
                                await selectAndUploadImage(source);
                                // Validate the image selection.
                                if (imageBytes == null) {
                                  showSnackBar(
                                      "Please select an image", context);
                                  return;
                                }
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Image is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: landmarkController,
                          decoration: InputDecoration(
                            hintText: "Enter nearby landmark",
                            labelText: "Landmark",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide:
                                  const BorderSide(color: Color(0xFFFF7643)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Landmark is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: priceController
                            ..text = priceController.text.isEmpty
                                ? '0'
                                : priceController.text,
                          decoration: InputDecoration(
                            hintText: "Enter property price",
                            labelText: "Price",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide:
                                  const BorderSide(color: Color(0xFFFF7643)),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Price is required';
                            }
                            if (int.tryParse(value) == null ||
                                int.parse(value) < 0) {
                              return 'Price must be a non-negative integer';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: railwayStnController,
                          decoration: InputDecoration(
                            hintText: "Enter nearby railway station",
                            labelText: "Railway Stn",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide:
                                  const BorderSide(color: Color(0xFFFF7643)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Railway Station is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Number of Rooms",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  final currentValue =
                                      int.tryParse(roomsController.text) ?? 0;
                                  if (currentValue > 0) {
                                    roomsController.text =
                                        (currentValue - 1).toString();
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: roomsController
                                  ..text = roomsController.text.isEmpty
                                      ? '0'
                                      : roomsController.text,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  final currentValue =
                                      int.tryParse(roomsController.text) ?? 0;
                                  roomsController.text =
                                      (currentValue + 1).toString();
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Property Type"),
                            ToggleButtons(
                              isSelected: [sale, !sale],
                              onPressed: (index) {
                                setState(() {
                                  sale = index == 0;
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              selectedColor: Colors.white,
                              fillColor: const Color.fromARGB(255, 216, 16, 83),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text("Sale"),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text("Rent"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Number of Washrooms",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  final currentValue =
                                      int.tryParse(washroomController.text) ??
                                          0;
                                  if (currentValue > 0) {
                                    washroomController.text =
                                        (currentValue - 1).toString();
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: washroomController
                                  ..text = washroomController.text.isEmpty
                                      ? '0'
                                      : washroomController.text,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  final currentValue =
                                      int.tryParse(washroomController.text) ??
                                          0;
                                  washroomController.text =
                                      (currentValue + 1).toString();
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: constraints.maxHeight * 0.05),
                        // Submit Button
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                FutureBuilder<DocumentSnapshot>(
                                  future: _userData,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text(
                                          'Error loading user data.',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }
                                    if (!snapshot.hasData ||
                                        !snapshot.data!.exists) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text(
                                          'No user data found.',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }
                                    var userData = snapshot.data!.data()
                                        as Map<String, dynamic>;
                                    sellerName = userData['Seller Name'];
                                    sellerContact = userData['Seller Contact'];
                                    return const SizedBox
                                        .shrink(); // Placeholder widget
                                  },
                                );
                                String latitude = '';
                                String longitude = '';
                                String pincode = '';

                                getLatLngPincode(addressController.text.trim())
                                    .then((result) {
                                  if (result != null) {
                                    setState(() {
                                      latitude = result['latitude'].toString();
                                      longitude =
                                          result['longitude'].toString();
                                      pincode = result['pincode'] ?? '';
                                    });
                                  }
                                });
                                imageUrl = handleImageUpload() as String;
                                final property = {
                                  '3D Model': model3D,
                                  'Address': addressController.text.trim(),
                                  'Amenities': {
                                    'AC': acController.text.trim(),
                                    'Furnish': furnish,
                                    'Gas': gas,
                                    'Lift': lift,
                                    'Parking': parking,
                                    'Water Supply':
                                        waterSupplyController.text.trim(),
                                    'Wifi': wifi,
                                  },
                                  'Area': areaController.text.trim(),
                                  'Bus Stop': busStopController.text.trim(),
                                  'Description':
                                      descriptionController.text.trim(),
                                  'Image': imageUrl,
                                  'Landmark': landmarkController.text.trim(),
                                  'Latitude': latitude,
                                  'Longitude': longitude,
                                  'Pincode': pincode,
                                  'Price': priceController.text.trim(),
                                  'Railway Stn':
                                      railwayStnController.text.trim(),
                                  'Rooms': roomsController.text.trim(),
                                  'Sale': sale,
                                  'Seller Contact': sellerContact,
                                  'Seller Name': sellerName,
                                  'Washroom': washroomController.text.trim(),
                                };
                                debugPrint(property.toString());
                                log(property.toString());
                                // Connect to Firebase and add propertys
                                await FirebaseFirestore.instance
                                    .collection('Properties')
                                    .add(property);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Property added successfully!")),
                                );
                                _formKey.currentState!.reset();
                              } catch (e) {
                                debugPrint("Error adding property: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Failed to add property. Please try again.")),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color.fromARGB(255, 216, 16, 83),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Add Property"),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.05),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
