import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duka/Admin/upload_items.dart';
import 'package:duka/Authentication/authentication.dart';
import 'package:duka/DialogBox/error_dialog.dart';
import 'package:duka/DialogBox/loading_dialog.dart';
import 'package:duka/Widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  const AdminSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.lightGreenAccent],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text(
          "shop now",
          style: TextStyle(
            fontSize: 45.0,
            color: Colors.white,
            fontFamily: "Signatra",
          ),
        ),
        centerTitle: true,
      ),
      body: const AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  const AdminSignInScreen({Key? key}) : super(key: key);

  @override
  State<AdminSignInScreen> createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _adminIDTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  bool? _isObsecure = true;
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    double _screenWidth = MediaQuery.of(context).size.width,
        // ignore: no_leading_underscores_for_local_identifiers
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.lightGreenAccent],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        // color: Colors.teal.shade100,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/admin.png",
                height: 240.0,
                // width: 240.0,
                width: _screenWidth * 0.65,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Admin",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDTextEditingController,
                    data: Icons.person,
                    hintText: "id",
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
                  )
                ],
              ),
            ),
            const SizedBox(height: 25.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.orange),
              onPressed: () {
                _adminIDTextEditingController.text.isNotEmpty &&
                        _passwordTextEditingController.text.isNotEmpty
                    ? loginAdmin()
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
            const SizedBox(height: 20.0),
            TextButton.icon(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AuthenticScreen())),
              icon: const Icon(
                Icons.nature_people,
                color: Colors.orange,
              ),
              label: const Text(
                "I'm not Admin",
                style: TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  void loginAdmin() async {
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingAlertDialog(
              message: "Signing In, Please Wait...");
        });
    await FirebaseFirestore.instance
        .collection("admins")
        .get()
        .then((snapshot) {
      // ignore: avoid_function_literals_in_foreach_calls
      snapshot.docs.forEach((result) {
        if (result.data()["id"] != _adminIDTextEditingController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "your id is not correct",
              textAlign: TextAlign.center,
            ),
          ));
        } else if (result.data()["password"] !=
            _passwordTextEditingController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "your password is not correct",
              textAlign: TextAlign.center,
            ),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              // ignore: prefer_interpolation_to_compose_strings
              "Welcome Dear Admin, " + result.data()["name"],
              textAlign: TextAlign.center,
            ),
          ));
          setState(() {
            _adminIDTextEditingController.text = "";
            _passwordTextEditingController.text = "";
          });
          Route route = MaterialPageRoute(builder: (c) => const UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
