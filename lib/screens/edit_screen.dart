import 'dart:io';

import 'package:doctors/screens/home_screen.dart';
import 'package:doctors/services/doctor_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> doctorData;

  const EditScreen({super.key, required this.docId, required this.doctorData});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _positionController;
  final _formKey = GlobalKey<FormState>();
  final _doctorServices = DoctorServices();
  String? _selectedDistrict;
  String? _selectedGender;

  XFile? _image;
  Uint8List? _webImage;
  final ImagePicker picker = ImagePicker();

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
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.doctorData['name']);
    _emailController = TextEditingController(text: widget.doctorData['email']);
    _phoneController =
        TextEditingController(text: widget.doctorData['phoneNumber']);
    _positionController =
        TextEditingController(text: widget.doctorData['position']);
    _selectedDistrict = widget.doctorData['district'].trim();

    _selectedGender = widget.doctorData['gender'].trim();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Edit Doctor'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () =>
                _doctorServices.DeletDoctor(widget.docId, context: context),
          ),
        ],
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
                      _image != null ?

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
                          File(_image!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )


                        :
                        Center(
                          child: widget.doctorData['imageUrl'].isEmpty
                              ? CircleAvatar(
                            backgroundColor: Colors.grey,
                            maxRadius: 50,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 80,
                            ),
                          )
                              : Image.network(
                            widget.doctorData['imageUrl'],
                            height: 120,
                            width: 120,
                          ),
                        ),
                      Positioned(
                        bottom: 30,
                        right: 70,
                        child: CircleAvatar(
                          maxRadius: 19,
                          backgroundColor: Colors.green,
                          child: IconButton(
                            onPressed: () {
                              getImage();
                            },
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildFormContainer(
                      context,
                      'Full Name',
                      TextFormField(
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
                    buildFormContainer(
                      context,
                      'District',
                      DropdownButtonFormField<String>(
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
                        items: <String>[
                          'Thiruvananthapuram',
                          'Kollam',
                          'Alappuzha',
                          'Pathanamthitta',
                          'Kottayam',
                          'Idukki',
                          'Ernakulam',
                          'Thrissur',
                          'Palakkad',
                          'Malappuram',
                          'Kozhikode',
                          'Wayanad',
                          'Kannur',
                          'Kasaragod'
                        ].map((String value) {
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
                    buildFormContainer(
                      context,
                      'Position',
                      TextFormField(
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
                            return 'Please enter your Position';
                          }
                          return null;
                        },
                      ),
                    ),
                    buildFormContainer(
                      context,
                      'Email',
                      TextFormField(
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
                    buildFormContainer(
                      context,
                      'phone',
                      TextFormField(
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
                    buildFormContainer(
                      context,
                      'Gender',
                      DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your gender';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          // labelText: 'Gender',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        items: <String>['male', 'female'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          _selectedGender = value;
                        },
                        value: 'female',
                      ),
                    ),
                  ],
                ),
              ),
              _loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    )
                  : ElevatedButton(
                      style: const ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(
                          Size(200, 40),
                        ),
                        backgroundColor:
                            WidgetStatePropertyAll(CupertinoColors.systemGreen),
                      ),
                      onPressed: () async {
                        String name = _nameController.text;
                        String position = _positionController.text;
                        String district = _selectedDistrict!;
                        String phoneNumber = _phoneController.text;
                        String email = _emailController.text;
                        String gender = _selectedGender!;

                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _loading = true;
                          });
                          await _doctorServices.updateDoctor(
                              docId: widget.docId,
                              name: name,
                              position: position,
                              district: district,
                              phoneNumber: phoneNumber,
                              imageFile: _image,
                              email: email,
                              gender: gender,
                              context: context);

                          setState(() {
                            _loading = false;
                          });
                        }
                      },
                      child: const Text(
                        'SAVE',
                        style: TextStyle(color: Colors.white),
                      ))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFormContainer(
      BuildContext context, String labelText, Widget child) {
    return Container(
      margin: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '  $labelText ',
            style: TextStyle(color: Colors.black45, fontSize: 18),
          ),
          child,
        ],
      ),
    );
  }
}
