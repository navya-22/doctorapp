
import 'dart:io'as io;


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import '../services/doctor_service.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _image;
  Uint8List? _webImage;
  final ImagePicker picker = ImagePicker();
  String? _selectedDistrict = 'Malappuram';
  String? _selectedGender = 'male';
  final _doctorServices = DoctorServices();
  bool _loading = false;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _image = pickedFile;
          _webImage = bytes;
        });
      } else {
        setState(() {
          _image = pickedFile;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'Add Doctor',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 200,
                  width: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          maxRadius: 50,
                          child:Center(
                            child: _image == null
                                ? Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 80,
                            )
                                : kIsWeb
                                ? Image.memory(
                              _webImage!,
                              fit: BoxFit.cover,
                            )
                                : Image.file(
                              io.File(_image!.path),
                              fit: BoxFit.cover,
                            ),
                        ),
                      ),
                      ),
                      Positioned(
                        bottom: 30,
                        right: 70,
                        child: CircleAvatar(
                          maxRadius: 19,
                          backgroundColor: Colors.green,
                          child:  IconButton(
                            onPressed: getImage,
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                        ),
                      ),
                        ),
                      ),
          ]
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '  Enter your Full Name ',
                      style: TextStyle(color: Colors.black45, fontSize: 18),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      //padding: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Text(
                      'Select your  District ',
                      style: TextStyle(color: Colors.black45, fontSize: 18),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      //padding: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please select your district';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        items: <String>['Thiruvananthapuram',
                          'Kollam', 'Alappuzha', 'Pathanamthitta',
                          'Kottayam', 'Idukki', 'Ernakulam', 'Thrissur',
                          'Palakkad', 'Malappuram', 'Kozhikode',
                          'Wayanad', 'Kannur', 'Kasaragod']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          _selectedDistrict = value;
                        },
                        value: _selectedDistrict,
                      ),
                    ),
                    const Text(
                      '  Enter your Position ',
                      style: TextStyle(color: Colors.black45, fontSize: 18),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      //padding: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _positionController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your position';
                          }
                          return null;
                        },
                      ),
                    ),
                    Text(
                      ' Enetr your Email Id',
                      style: TextStyle(color: Colors.black45, fontSize: 18),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      //padding: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        validator: (value) {
                          RegExp regex = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~)]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          } else {
                            if (!regex.hasMatch(value)) {
                              return 'Please enter an valid email';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    const Text(
                      'Enetr your Phone Number',
                      style: TextStyle(color: Colors.black45, fontSize: 18),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      //padding: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        validator: (value) {
                          RegExp regex = RegExp(r'^\d{10}$');
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          } else if (!regex.hasMatch(value)) {
                            return 'Please enter a valid 10-digit phone number';
                          }

                          return null;
                        },
                      ),
                    ),
                    const Text(
                      ' Select your  Gender ',
                      style: TextStyle(color: Colors.black45, fontSize: 18),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      //padding: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your gender';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          // labelText: 'Gender',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        items:
                            <String>['male', '  female'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          _selectedGender = value;
                        },
                        value: _selectedGender,
                      ),
                    ),
                  ],
                ),
              ),
              _loading  ?  Center(
                child:  CircularProgressIndicator(color: Colors.green,),
              )  :  ElevatedButton(
                  style: const ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(
                      Size(200, 40),
                    ),
                    backgroundColor:
                        WidgetStatePropertyAll(CupertinoColors.systemGreen),
                  ),
                  onPressed: ()async {
                    String name = _nameController.text;
                    String position = _positionController.text;
                    String phoneNumber = _phoneController.text ;
                    String email = _emailController.text;
                    if (_formKey.currentState!.validate()) {

                      setState(() {
                        _loading  =  true;
                      });
                     await _doctorServices.addDoctor(
                          name: name,
                          position: position,
                          district: _selectedDistrict!,
                          phoneNumber: phoneNumber,
                          email: email,
                          gender: _selectedGender!,
                          context: context,
                         imageFile: _image );
                      setState(() {
                        _loading  =  false;
                      });
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
