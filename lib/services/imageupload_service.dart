import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ImageUploadService {
  final Reference storageRef = FirebaseStorage.instance.ref().child('images');

  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = basename(imageFile.path);
      UploadTask uploadTask = storageRef.child(fileName).putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }
}
