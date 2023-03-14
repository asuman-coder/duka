import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duka/Config/config.dart';
import 'package:duka/Counters/cart_item_counter.dart';
import 'package:duka/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage(
      {Key? key, required this.addressId, required this.totalAmount})
      : super(key: key);
  final String addressId;
  final double totalAmount;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/cash.png",
                      width: MediaQuery.of(context).size.width * 0.85),
                ),
                const SizedBox(height: 15.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    padding: const EdgeInsets.all(8.0),
                  ),
                  onPressed: () => addOrderDetails(),
                  child: const Text(
                    "Place Order",
                    style: TextStyle(color: Colors.white, fontSize: 30.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  addOrderDetails() {
    writeOrderDetailsForUser({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy":
          EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences!
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash on Delivery",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
    });
    writeOrderDetailsForAdmin({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy":
          EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences!
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash on Delivery",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
    }).whenComplete(() => {
          emptyCartNow(),
        });
  }

  emptyCartNow() {
    EcommerceApp.sharedPreferences!
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
    List tempList = EcommerceApp.sharedPreferences!
        .getStringList(EcommerceApp.userCartList)!;
    FirebaseFirestore.instance
        .collection("users")
        .doc(EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
        .update({
      EcommerceApp.userCartList: tempList,
    }).then((value) {
      EcommerceApp.sharedPreferences!
          .setStringList(EcommerceApp.userCartList, tempList as List<String>);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Congratulations, your Order has been placed successfully',
            textAlign: TextAlign.center)));

    Route route = MaterialPageRoute(builder: (c) => const SplashScreen());

    Navigator.push(context, route);
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    CollectionReference ref =
        FirebaseFirestore.instance.collection(EcommerceApp.collectionOrders);

    String productId = ref.doc().id;
    await EcommerceApp.firestore!
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(
          productId,
        )
        .set(data);
  }

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async {
    CollectionReference ref =
        FirebaseFirestore.instance.collection(EcommerceApp.collectionOrders);

    String productId = ref.doc().id;
    await EcommerceApp.firestore!
        .collection(EcommerceApp.collectionOrders)
        .doc(
          productId,
        )
        .set(data);
  }
}
