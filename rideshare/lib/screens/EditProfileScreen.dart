import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rideshare/models/user.dart' as model;
import 'package:rideshare/resources/AuthService.dart';

import '../components/myButton.dart';
import '../components/myTextField.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bioController = TextEditingController();
  final authUser = FirebaseAuth.instance.currentUser!;
  final ImagePicker imagePicker = ImagePicker();
  XFile? image;
  bool isLoading = false;

  String uid = "";
  String email = "";
  String firstName = "";
  String lastName = "";
  String bio = "";
  String photoUrl = "";
  bool emailVerified = false;
  bool phoneVerified = false;
  bool hasPhoto = false;
  List listings = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .get();

      model.User user = model.User.fromSnap(userSnap);
      uid = user.uid;
      email = user.email;
      bio = user.bio;
      firstName = user.firstName;
      lastName = user.lastName;
      photoUrl = user.photoUrl;
      listings = user.listings;

      if (photoUrl.isEmpty) {
        hasPhoto = false;
      } else {
        hasPhoto = true;
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
      firstNameController.text = firstName;
      lastNameController.text = lastName;
      bioController.text = bio;
    });
  }

  bool firstnameFormatCorrect() {
    if (firstNameController.text.trim().isNotEmpty &&
        firstNameController.text.trim().length >= 2 &&
        firstNameController.text.trim().length < 10) {
      return true;
    } else {
      return false;
    }
  }

  bool lastnameFormatCorrect() {
    if (lastNameController.text.trim().isNotEmpty &&
        lastNameController.text.trim().length >= 2 &&
        lastNameController.text.trim().length < 10) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> saveChanges() async {
    String result = "There has been some issues, please try again later.";
    if (image != null) {
      Reference ref =
          FirebaseStorage.instance.ref().child("Profile Images").child(uid);
      await ref.putFile(File(image!.path));
      photoUrl = await ref.getDownloadURL();
    }
    if (firstnameFormatCorrect() && lastnameFormatCorrect()) {
      result = await AuthService().updateUserDetails(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        bio: bioController.text.trim(),
        photoUrl: photoUrl,
      );
    }
    return result;
  }

  void showMessage(String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          contentPadding: const EdgeInsets.all(10.0),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      image = await imagePicker.pickImage(
                        source: ImageSource.gallery,
                        maxHeight: 512,
                        maxWidth: 512,
                        imageQuality: 75,
                      );
                      setState(() {});
                    },
                    child: SizedBox(
                      width: 120.0,
                      height: 120.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: hasPhoto
                            ? Image.network(
                                photoUrl,
                                fit: BoxFit.cover,
                              )
                            : image != null
                                ? Image.file(
                                    File(image!.path),
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'lib/images/default_photo.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const SizedBox(height: 25),
                  //First Name Field
                  MyTextField(
                    controller: firstNameController,
                    hintText: 'First Name',
                    obscureText: false,
                    inputType: TextInputType.name,
                  ),
                  //Last Name Field
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: lastNameController,
                    hintText: 'Last Name',
                    obscureText: false,
                    inputType: TextInputType.name,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: bioController,
                    hintText: 'Bio',
                    obscureText: false,
                    inputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    text: "Save Changes",
                    onTap: () async {
                      String result = await saveChanges();
                      if (result != "success") {
                        showMessage(result);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
