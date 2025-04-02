import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Uploads an image to Firebase Storage. If [isPost] is true, a unique ID is added.
  Future<String> uploadImage(String childName, Uint8List file) async {
    // Reference a location with the current user's uid.
    Reference ref = _storage
        .ref()
        .child(childName)
        .child(_auth.currentUser!.uid)
        .child(const Uuid().v1());
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    return await snap.ref.getDownloadURL();
  }
}
