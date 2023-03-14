// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duka/Config/config.dart';
import 'package:duka/DialogBox/error_dialog.dart';
import 'package:duka/DialogBox/loading_dialog.dart';
import 'package:duka/Store/store_home.dart';
import 'package:duka/Widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cPasswordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool? _isObsecure = true;
  String userImageUrl = "";
  File? _imageFile;
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      // ignore: avoid_unnecessary_containers
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10.0),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile!),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: _screenWidth * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 8.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: _passwordTextEditingController,
                      obscureText: _isObsecure!,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isObsecure = !_isObsecure!;
                            });
                          },
                          child: Icon(
                            _isObsecure!
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        focusColor: Theme.of(context).primaryColor,
                        hintText: "Password",
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: _cPasswordTextEditingController,
                      obscureText: _isObsecure!,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isObsecure = !_isObsecure!;
                            });
                          },
                          child: Icon(
                            _isObsecure!
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        focusColor: Theme.of(context).primaryColor,
                        hintText: "Confirm Password",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                uploadAndSaveImage();
              },
              style: ElevatedButton.styleFrom(primary: Colors.orange),
              child: const Text(
                "Sign up",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.orange,
            ),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _imageFile = File(image!.path);
    });
  }

  Future<void> uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
        context: context,
        builder: (c) {
          return const ErrorAlertDialog(
              message: "Please select an image file.");
        },
      );
    } else {
      _passwordTextEditingController.text ==
              _cPasswordTextEditingController.text
          ? _emailTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty &&
                  _cPasswordTextEditingController.text.isNotEmpty &&
                  _nameTextEditingController.text.isNotEmpty
              //===then upload===
              ? uploadToStorage()
              //===else if there is error display msg===
              : displayDialog("Please fill  the registration form...")
          : displayDialog("Passwords do not match.");
    }
  }

  displayDialog(String msg) {
    showDialog(
      context: context,
      builder: (c) {
        return ErrorAlertDialog(message: msg);
      },
    );
  }

  uploadToStorage() async {
    showDialog(
      context: context,
      builder: (c) {
        return const LoadingAlertDialog(
            message: 'Registering, Please wait.....');
      },
    );
    //==give unique name to given image==
    CollectionReference ref = FirebaseFirestore.instance.collection("img");

    String imgId = ref.doc().id;
    String imageFileName = imgId;
    Reference storageReference =
        FirebaseStorage.instance.ref().child(imageFileName);
    UploadTask uploadTask = storageReference.putFile(File(_imageFile!.path));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;
      _registerUser();
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _registerUser() async {
    User? firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(message: error.message.toString());
          });
    });
    // ignore: unnecessary_null_comparison
    if (firebaseUser != null) {
      saveUserInfoToFirestore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => const StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoToFirestore(User? fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser!.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "url": userImageUrl,
      EcommerceApp.userCartList: ["garbageValue"],
    });
    await EcommerceApp.sharedPreferences!.setString("uid", fUser.uid);
    await EcommerceApp.sharedPreferences!
        .setString(EcommerceApp.userEmail, fUser.email!);
    await EcommerceApp.sharedPreferences!
        .setString(EcommerceApp.userName, _nameTextEditingController.text);
    await EcommerceApp.sharedPreferences!
        .setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences!
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }
}
