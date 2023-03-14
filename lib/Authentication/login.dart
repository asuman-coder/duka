// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duka/Admin/admin_login.dart';
import 'package:duka/Config/config.dart';
import 'package:duka/DialogBox/error_dialog.dart';
import 'package:duka/DialogBox/loading_dialog.dart';
import 'package:duka/Store/store_home.dart';
import 'package:duka/Widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  bool? _isObsecure = true;

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
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/login.png",
                height: 240.0,
                // width: 240.0,
                width: _screenWidth * 0.65,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Login to your account",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                          Icons.person,
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
                  )
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.orange),
              onPressed: () {
                _emailTextEditingController.text.isNotEmpty &&
                        _passwordTextEditingController.text.isNotEmpty
                    ? loginUser()
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return const ErrorAlertDialog(
                              message: "Please enter  email and password.");
                        });
              },
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 50.0),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.orange,
            ),
            const SizedBox(height: 10.0),
            TextButton.icon(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminSignInPage())),
              icon: const Icon(
                Icons.nature_people,
                color: Colors.orange,
              ),
              label: const Text(
                "I'm Admin",
                style: TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingAlertDialog(
              message: "Authenticating, Please wait...");
        });
    User? firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => const StoreHome());
        Navigator.push(context, route);
      });
    }
  }

  Future readData(User? fUser) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(fUser!.uid)
        .get()
        .then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences!
          .setString("uid", dataSnapshot.data()![EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences!.setString(
          EcommerceApp.userEmail, dataSnapshot.data()![EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences!.setString(
          EcommerceApp.userName, dataSnapshot.data()![EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences!.setString(
          EcommerceApp.userAvatarUrl,
          dataSnapshot.data()![EcommerceApp.userAvatarUrl]);
      List<String> cartList =
          dataSnapshot.data()![EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences!
          .setStringList(EcommerceApp.userCartList, cartList);
    });
  }
}
