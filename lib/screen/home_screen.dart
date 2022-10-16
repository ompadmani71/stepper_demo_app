import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int initialStep = 0;

  String? imagePath;

  final ImagePicker _picker = ImagePicker();

  List<String> genderList = ["Male", "Female", "Other"];

  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                end: Alignment.centerRight,
                begin: Alignment.centerLeft,
                colors: [
                  Colors.lightBlue,
                  Colors.greenAccent,
                ]),
          ),
        ),
        title: const Text("Edit Your Profile"),
      ),
      body: Stepper(
        physics: const BouncingScrollPhysics(),
        currentStep: initialStep,
        onStepTapped: (value) {
          setState(() {
            initialStep = value;
          });
        },
        onStepContinue: () {
          setState(() {
            if (initialStep < 10) initialStep++;
          });
        },
        onStepCancel: () {
          setState(() {
            if (initialStep > 0) initialStep--;
          });
        },
        steps: [
          Step(
            isActive: (initialStep >= 0) ? true : false,
            title: const Text("Profile Picture"),
            content: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: (imagePath != null)
                      ? FileImage(File(imagePath!))
                      : null,
                  backgroundColor: Colors.grey.withOpacity(0.5),
                  child: Text((imagePath == null) ? "ADD" : "",style: const TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                  ),)
                ),
                ElevatedButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                            scrollable: true,
                            title: const Text(
                              "Select Source",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  XFile? pickedImage = await _picker.pickImage(
                                      source: ImageSource.gallery);

                                  if (pickedImage != null) {
                                    setState(() {
                                      imagePath = pickedImage.path;
                                    });
                                  }
                                },
                                child: const Text("gallery"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  XFile? pickedImage = await _picker.pickImage(
                                      source: ImageSource.camera);
                                  setState(() {
                                    imagePath = pickedImage!.path;
                                  });
                                },
                                child: const Text("Camera"),
                              ),
                            ],
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Step(
          isActive: (initialStep >= 1) ? true : false,
            title: const Text("Name"),
            content: textField(
              icon: Icons.person_outline, hint: "Enter Your Full Name",
            ),
          ),
          Step(
            isActive: (initialStep >= 2) ? true : false,
            title: const Text("Phone"),
            content: textField(
              icon: Icons.call, hint: "Enter Your Number",
            ),
          ),
          Step(
            isActive: (initialStep >= 3) ? true : false,
            title: const Text("Email"),
            content: textField(icon: Icons.email_outlined, hint: "Enter Your Email",
            ),
          ),
          Step(
            isActive: (initialStep >= 4) ? true : false,
            title: const Text("DOB"),
            content: textField(
              icon: Icons.date_range,hint:  "Enter Your Birth Date"),
          ),
          Step(
            isActive: (initialStep >= 5) ? true : false,
            title: const Text("Gender"),
            content: Row(
              children: <Widget>[
                addButton(0, 'Male'),
                addButton(1, 'Female'),
                addButton(2, 'Others'),
              ],
            ),
          ),
          Step(
            isActive: (initialStep >= 6) ? true : false,
            title: const Text("Current Location"),
            content: textField(icon: Icons.location_on, hint: "Enter Your Address",
            ),
          ),
          Step(
            isActive: (initialStep >= 7) ? true : false,
            title: const Text("Nationality"),
            content: textField(icon: Icons.flag, hint: "Enter Your Nationality",
            ),
          ),
          Step(
            isActive: (initialStep >= 8) ? true : false,
            title: const Text("Religion"),
            content: textField(icon: Icons.adjust_rounded,hint:  "Enter Your Religion",
            ),
          ),
          Step(
            isActive: (initialStep >= 9) ? true : false,
            title: const Text("Languages"),
            content: textField(icon: Icons.language_rounded, hint: "Enter Languages",
            ),
          ),
          Step(
            isActive: (initialStep >= 10) ? true : false,
            title: const Text("Biography"),
            content: textField(icon: Icons.details, hint: "Enter Biography",
            ),
          ),
        ],
      ),
    );
  }

  TextField textField ({required IconData icon, required String hint}){
    return TextField(
      decoration: InputDecoration(
        icon: Icon(icon),
        hintText: hint
      ),
    );
  }

  Row addButton(int genderListIndex, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio<String>(
          activeColor: Theme.of(context).primaryColor,
          value: genderList[genderListIndex],
          groupValue: selectedGender,
          onChanged: (value) {
            setState(() {
              selectedGender = value.toString();
            });
          },
        ),
        Text(title)
      ],
    );
  }
}
