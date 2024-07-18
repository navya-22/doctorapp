import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors/screens/add_screen.dart';
import 'package:doctors/screens/edit_screen.dart';
import 'package:doctors/services/doctor_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _docService = DoctorServices();
  String? selectedGender;
  String? selectedDistrict;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Text(
              'Doctors',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            DropdownButton<String>(
              value: selectedGender,
              items: <String>['male', 'female'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGender =value;
                });
              },
              hint: const Text('Gender'),
            ),
            const SizedBox(
              width: 20,
            ),
            DropdownButton<String>(
              value: selectedDistrict,
              items: <String>['Thiruvananthapuram',
                'Kollam', 'Alappuzha', 'Pathanamthitta',
                'Kottayam', 'Idukki', 'Ernakulam', 'Thrissur',
                'Palakkad', 'Malappuram', 'Kozhikode',
                'Wayanad', 'Kannur', 'Kasaragod'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newvalue) {
                setState(() {
                  selectedDistrict = newvalue;
                });
              },
              hint: Text('District'),
            ),
          ]),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
               stream: _docService.getDoctors(gender: selectedGender,district: selectedDistrict),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: Colors.green,));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                       Align(
                             alignment:  Alignment.center,
                           child: Text('No doctor  found')),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddScreen(),
                                  ),
                                );
                              },

                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                final doctorDataList = snapshot.data!.docs;

                return SizedBox(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: doctorDataList.length,
                          itemBuilder: (context, index) {
                            final doctorData =
                            doctorDataList[index].data() as Map<String, dynamic>;

                            return doctorContainer(
                              image: doctorData['imageUrl'],
                              name: doctorData['name'] ?? 'No Name',
                              position: doctorData['position'] ?? 'No Position',
                              district: doctorData['district'] ?? 'No District',
                              onPress: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return EditScreen(docId: doctorDataList[index].id,
                                      doctorData: doctorData,

                                  );

                                },));
                              },
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddScreen(),
                                  ),
                                );
                              },

                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: TextButton(
              child: Image(image: AssetImage('assess/images/Icon_Home.png')),
              //Image.asset('assess/images/Icon_Home.png'),

              onPressed: () {},
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Image(image: AssetImage('assess/images/Calendar.png')),
              onPressed: () {},
            ),
            label: 'Appointment',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Image(image: AssetImage('assess/images/Icon_News.png')),
              onPressed: () {},
            ),
            label: 'Prescription',
          ),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Image(image: AssetImage('assess/images/Icon_Menu.png')),
                onPressed: () {},
              ),
              label: 'Profile'),
        ],
      ),
    );
  }

  Widget doctorContainer(
          {required String name,
          required String position,
          required String district,
            required VoidCallback onPress,
            required  String  image
          }) =>
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding:  EdgeInsets.all(3.0),
            child: Row(
              children: [

                image.isEmpty  ?
  Container(
                  width: 100,
                  height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),),
                  child: Icon(Icons.person,color: Colors.white,size: 100,),
                ) : Image.network(image,height: 120,width: 120,),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      position,
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      district,
                      style: TextStyle(fontSize: 17),
                    )
                  ],
                ),
                SizedBox(width: 20,),
                ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                      fixedSize: WidgetStatePropertyAll(
                        Size(130, 40),
                      ),
                      backgroundColor:
                          WidgetStatePropertyAll(CupertinoColors.systemGreen),
                    ),
                    onPressed: onPress,
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      );
}
