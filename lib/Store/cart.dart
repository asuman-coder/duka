import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duka/Address/address.dart';
import 'package:duka/Config/config.dart';
import 'package:duka/Counters/cart_item_counter.dart';
import 'package:duka/Counters/total_money.dart';
import 'package:duka/Models/item.dart';
import 'package:duka/Store/store_home.dart';
import 'package:duka/Widgets/custom_app_bar.dart';
import 'package:duka/Widgets/loading_widget.dart';
import 'package:duka/Widgets/my_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double? totalAmount;
  @override
  void initState() {
    // ignore: todo

    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (EcommerceApp.sharedPreferences!
                  .getStringList(EcommerceApp.userCartList)!
                  .length ==
              17) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text('your Cart is empty', textAlign: TextAlign.center)));
            // Fluttertoast.showToast(msg: "your Cart is empty");
          } else {
            Route route = MaterialPageRoute(
                builder: (c) => Address(totalAmount: totalAmount!));
            Navigator.pushReplacement(context, route);
          }
        },
        label: const Text("Check Out"),
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.navigate_next),
      ),
      appBar: MyAppBar(),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Consumer2<TotalAmount, CartItemCounter>(
            builder: (context, amountProvider, cartProvider, c) {
              return Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Center(
                    child: cartProvider.count == 0
                        ? Container()
                        // ignore: prefer_const_constructors, sized_box_for_whitespace
                        : Container(
                            width: (width! * 0.55),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Total Price:Ksh${amountProvider.totalAmount.toString()}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
          FutureBuilder(
            future: Future.value(FirebaseAuth.instance.currentUser),
            builder: (ctx, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return StreamBuilder(
                stream: EcommerceApp.firestore!
                    .collection("items")
                    .where("uid",
                        whereIn: EcommerceApp.sharedPreferences!
                            .getStringList(EcommerceApp.userCartList))
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: circularProgress(),
                    );
                  } else {
                    // ignore: prefer_is_empty
                    if (snapshot.data!.docs.length == 0) {
                      return beginBuildingCart();
                    } else {
                      return Expanded(
                        flex: 10,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            ItemModel model = ItemModel.fromJson(
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>);

                            if (index == 0) {
                              totalAmount = 0;
                              totalAmount = model.price! + totalAmount!;
                            } else {
                              totalAmount = model.price! + totalAmount!;
                            }
                            if (snapshot.data!.docs.length - 1 == index) {
                              WidgetsBinding.instance.addPostFrameCallback((t) {
                                Provider.of<TotalAmount>(
                                  context,
                                  listen: false,
                                ).display(totalAmount!);
                              });
                            }
                            return sourceInfo(model, context,
                                removeCartFunction: () =>
                                    removeItemFromUserCart(model.uid!));
                          },
                          itemCount:
                              snapshot.hasData ? snapshot.data!.docs.length : 0,
                        ),
                      );
                    }
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  beginBuildingCart() {
    return Center(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        // ignore: sized_box_for_whitespace
        child: Container(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.insert_emoticon,
                color: Colors.white,
              ),
              Text("Cart is empty."),
              SizedBox(
                height: 10,
              ),
              Text("Start adding items to your Cart."),
            ],
          ),
        ),
      ),
    );
    // );
  }

  removeItemFromUserCart(String shortInfoAsId) {
    List tempCartList = EcommerceApp.sharedPreferences!
        .getStringList(EcommerceApp.userCartList)!;
    tempCartList.remove(shortInfoAsId);

    EcommerceApp.firestore!
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
        .update({
      EcommerceApp.userCartList: tempCartList,
    }).then((v) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Item Removed Successfully.', textAlign: TextAlign.center)));
      EcommerceApp.sharedPreferences!.setStringList(
          EcommerceApp.userCartList, tempCartList as List<String>);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
      totalAmount = 0;
    });
  }
}
