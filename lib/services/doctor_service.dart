
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DoctorServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getDoctors(
      {required String? gender, required String? district}) {
    Query _collection = _firestore.collection('doctors');

    return _collection
        .where('gender', isEqualTo: gender)
        .where('district', isEqualTo: district)
        .snapshots();
  }

  Future<void> addDoctor({
    required String name,
    required String position,
    required String district,
    required String phoneNumber,
    required XFile? imageFile,
    required String email,
    required String gender,
    required BuildContext context,
  }) async {
    try {
      String imageUrl = '';
      if(imageFile != null){

        imageUrl = await addImage(imageFile);

      }

      await _firestore.collection('doctors').add({
        'name': name,
        'position': position,
        'district': district,
        'phoneNumber': phoneNumber,
        'imageUrl': imageUrl,
        'email': email,
        'gender': gender,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('added successfuly')));
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Somthing went wrong')));
    }
  }

  Future<void> updateDoctor({
    required String docId,
    required String name,
    required String position,
    required String district,
    required String phoneNumber,
    required XFile? imageFile,
    required String email,
    required String gender,
    required BuildContext context,
  }) async {
    try {

      String imageUrl = '';
      if(imageFile != null){

        imageUrl = await addImage(imageFile);

      }
      CollectionReference doctor = _firestore.collection('doctors');
      Navigator.pop(context);
      await doctor.doc(docId).update({
        'name': name,
        'position': position,
        'district': district,
        'phoneNumber': phoneNumber,
        'imageUrl': imageUrl,
        'email': email,
        'gender': gender,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Updated successfully')));

      Navigator.pop(context);
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong')));
    }
  }

  Future<void> DeletDoctor(
    DocId, {
    required BuildContext context,
  }) async {
    try {
      await _firestore.collection('doctors').doc(DocId).delete();
      Navigator.pop(context);
    } catch (e) {}
  }

  Stream<QuerySnapshot> getDoctorsFiltered(String? gender, String? district) {
    Query query = _firestore.collection('doctors');

    return query.snapshots();
  }



  Future<String> addImage(imageFile) async{

    String imageUrl = '';

    if (kIsWeb) {
      Uint8List data = await imageFile!.readAsBytes();
      var snapshot = await _storage
          .ref('doctors/${imageFile.name}')
          .putData(data, SettableMetadata(contentType: 'image/jpeg'));
      imageUrl = await snapshot.ref.getDownloadURL();

    } else {

      print('hhhh');
      File file = File(imageFile!.path);
      var snapshot = await _storage
          .ref('doctors/${imageFile.name}')
          .putFile(file);
      imageUrl = await snapshot.ref.getDownloadURL();


    }

    return imageUrl;
  }
}



