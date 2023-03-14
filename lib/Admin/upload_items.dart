import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duka/Widgets/app_drawer_admin.dart';
import 'package:duka/Widgets/loading_widget.dart';
import 'package:duka/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  @override
  bool get wantKeepAlive => true;
  File? file;
  final TextEditingController _descriptionTextEditingController =
      TextEditingController();
  final TextEditingController _priceTextEditingController =
      TextEditingController();
  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  // ignore: unused_field
  final _form = GlobalKey<FormState>();

  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return file == null
        ? displayAdminHomeScreen()
        : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen() {
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
        actions: [
          TextButton(
            child: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (c) => const SplashScreen());
              Navigator.pushReplacement(context, route);
            },
          ),
        ],
      ),
      drawer: const AppDrawerAdmin(),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.lightGreenAccent],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shop_2,
              color: Colors.white,
              size: 200.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0)),
                  primary: Colors.green,
                ),
                child: const Text(
                  "Add New Items",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => takeImage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (c) {
        return SimpleDialog(
          title: const Text(
            "Item Image",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          children: [
            //==camera choice==
            SimpleDialogOption(
              onPressed: capturePhotoWithCamera,
              child: const Text(
                "Capture with Camera",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
            //==gallery choice==
            SimpleDialogOption(
              onPressed: pickPhotoFromGallery,
              child: const Text(
                "Select from Gallery",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
            //==cancel option==
            SimpleDialogOption(
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  //== implement capturePhotoWithCamera,==
  capturePhotoWithCamera() async {
    Navigator.pop(context);
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 680.0,
      maxWidth: 970.0,
    );
    setState(() {
      file = File(imageFile!.path);
    });
  }

  //== implement pickPhotoFromGallery==
  pickPhotoFromGallery() async {
    Navigator.pop(context);
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      file = File(imageFile!.path);
    });
  }

  displayAdminUploadFormScreen() {
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
        leading: IconButton(
          onPressed: clearFormInfo,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "New Product",
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          //==add button==
          TextButton(
            onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
            // onPressed: () {
            //   uploading ? null : () => uploadImageAndSaveItemInfo();
            // },
            child: const Text(
              "Add",
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading
              ? circularProgress()
              : const Center(
                  child: Text(
                  "Upload",
                  style: TextStyle(color: Colors.orange),
                )),
          // ignore: sized_box_for_whitespace
          Container(
            // color: Colors.grey,
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(file!.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 12.0)),
          // ==1st ListTile==
          ListTile(
            leading: const Icon(
              Icons.perm_device_information,
              color: Colors.orange,
            ),
            // ignore: sized_box_for_whitespace
            title: Container(
              // color: Colors.grey,
              width: 250.0,

              child: TextField(
                style: const TextStyle(color: Colors.deepPurpleAccent),
                controller: _shortInfoTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Short Info",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(color: Colors.orange),
          //==2nd ListTile==
          ListTile(
            leading: const Icon(
              Icons.perm_device_information,
              color: Colors.orange,
            ),
            //==whitespace==
            // ignore: sized_box_for_whitespace
            title: Container(
              // color: Colors.grey,
              width: 250.0,

              child: TextField(
                style: const TextStyle(color: Colors.deepPurpleAccent),
                controller: _titleTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(color: Colors.orange),
          //==3rd  ListTile
          ListTile(
            leading: const Icon(
              Icons.perm_device_information,
              color: Colors.orange,
            ),
            //==whitespace==
            // ignore: sized_box_for_whitespace
            title: Container(
              // color: Colors.grey,
              width: 250.0,

              child: TextField(
                style: const TextStyle(color: Colors.deepPurpleAccent),
                controller: _descriptionTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(color: Colors.orange),
          //==4th  ListTile==
          ListTile(
            leading: const Icon(
              Icons.perm_device_information,
              color: Colors.orange,
            ),
            //==whitespace==
            // ignore: sized_box_for_whitespace
            title: Container(
              // color: Colors.grey,
              width: 250.0,

              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.deepPurpleAccent),
                controller: _priceTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(color: Colors.orange),
        ],
      ),
    );
  }

  //==implement clearFormInfo==
  clearFormInfo() {
    setState(() {
      file = null;
      // file == null;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
    });
  }

  //==implement uploadImageAndSaveItemInfo()==
  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(file);
    saveItemInfo(imageDownloadUrl);
  }

  //==implement uploadItemImage==
  Future<String> uploadItemImage(mFileImage) async {
    CollectionReference ref = FirebaseFirestore.instance.collection("Items");

    String productId = ref.doc().id;
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("Items");
    UploadTask uploadTask = storageReference
        .child("product_$productId.jpg")
        .putFile(File(mFileImage.path));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //==implement saveItemInfo==
  saveItemInfo(String downloadUrl) {
    CollectionReference ref = FirebaseFirestore.instance.collection("items");

    String productId = ref.doc().id;
    final itemsRef = FirebaseFirestore.instance.collection("items");
    itemsRef.doc(productId).set({
      "uid": productId,
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "title": _titleTextEditingController.text.trim(),
    });
    setState(() {
      file = null;
      uploading = false;
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _priceTextEditingController.clear();
    });
  }
}
