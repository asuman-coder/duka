import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duka/Config/config.dart';
import 'package:duka/Models/address.dart';
import 'package:duka/Store/store_home.dart';
import 'package:duka/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {
  AddAddress({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final model = AddressModel(
                name: cName.text.trim(),
                state: cState.text.trim(),
                pincode: cPinCode.text,
                phoneNumber: cPhoneNumber.text,
                flatNumber: cFlatHomeNumber.text,
                city: cCity.text.trim(),
              ).toJson();
              // ==add to firestore the address infor==
              CollectionReference ref = FirebaseFirestore.instance
                  .collection(EcommerceApp.subCollectionAddress);

              String productId = ref.doc().id;
              EcommerceApp.firestore!
                  .collection(EcommerceApp.collectionUser)
                  .doc(EcommerceApp.sharedPreferences!
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.subCollectionAddress)
                  .doc(productId)
                  .set(model)
                  .then((value) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("New Address added successfully",
                        textAlign: TextAlign.center)));
                FocusScope.of(context).requestFocus(FocusNode());
                formKey.currentState!.reset();
              });
              Route route =
                  MaterialPageRoute(builder: (c) => const StoreHome());
              Navigator.push(context, route);
            }
          },
          label: const Text("Done"),
          backgroundColor: Colors.orange,
          icon: const Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Add New Address",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Name",
                      controller: cName,
                    ),
                    MyTextField(
                      hint: "Phone Number",
                      controller: cPhoneNumber,
                    ),
                    MyTextField(
                      hint: "Flat Number/House Number",
                      controller: cFlatHomeNumber,
                    ),
                    MyTextField(
                      hint: "City",
                      controller: cCity,
                    ),
                    MyTextField(
                      hint: "State/Country",
                      controller: cState,
                    ),
                    MyTextField(
                      hint: "Pin Code",
                      controller: cPinCode,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({Key? key, required this.hint, required this.controller})
      : super(key: key);
  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val!.isEmpty ? "Field can not be empty." : null,
      ),
    );
  }
}
