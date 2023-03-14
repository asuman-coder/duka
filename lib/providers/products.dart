// ignore: unused_import
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:duka/Models/item.dart';

// class Products with ChangeNotifier {
//   final List<ItemModel> _items = [];
//   List<ItemModel> get items {
//     // if (_showFavoritesOnly) {
//     //   return _items.where((prodItem) => prodItem.isFavorite).toList();
//     // }
//     return [..._items];
//   }

//   ItemModel findById(String uid) {
//     return _items.firstWhere((prod) => prod.uid == uid);
//   }

//   Future<void> deleteProduct(String uid) async {
//     CollectionReference ref = FirebaseFirestore.instance.collection("items");

//     String productId = ref.doc().id;
//     final itemsRef = FirebaseFirestore.instance.collection("items");
//     final existingProductIndex =
//         _items.indexWhere((prod) => prod.uid == productId);
//     // ItemModel? existingProduct = _items[existingProductIndex];
//     _items.removeAt(existingProductIndex);
//     notifyListeners();

//     await itemsRef.doc().delete();
//     //  final job = await itemsRef.doc().delete();
//     // if (job.statusCode >= 400) {
//     //   _items.insert(existingProductIndex, existingProduct);
//     //   notifyListeners();
//     //   throw const HttpException('Could not delete product.');
//     // }
//     // await itemsRef.doc(productId).delete();
//     // existingProduct = null;

//     // notifyListeners();
//   }
// }
