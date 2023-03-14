import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duka/Config/config.dart';
import 'package:duka/Counters/cart_item_counter.dart';
import 'package:duka/Models/item.dart';
import 'package:duka/Store/cart.dart';
import 'package:duka/Store/product_page.dart';
import 'package:duka/Widgets/loading_widget.dart';
import 'package:duka/Widgets/my_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

double? width;
double? height;
// ignore: unused_element
int _count = 0;

class StoreHome extends StatefulWidget {
  const StoreHome({Key? key}) : super(key: key);

  @override
  State<StoreHome> createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
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
            "Shop Now",
            style: TextStyle(
              fontSize: 45.0,
              color: Colors.white,
              fontFamily: "Signatra",
            ),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    try {
                      Route route =
                          MaterialPageRoute(builder: (c) => const CartPage());
                      Navigator.pushReplacement(context, route);
                      // ignore: empty_catches
                    } catch (error) {}
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.orange,
                  ),
                ),
                Positioned(
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.brightness_1,
                        size: 20.0,
                        color: Colors.green,
                      ),
                      Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 4.0,
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, ch) {
                            return Text(
                              ((EcommerceApp.sharedPreferences!
                                              .getStringList(
                                                  EcommerceApp.userCartList)
                                              ?.length ??
                                          0) -
                                      1)
                                  .toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        drawer: const MyDrawer(),
        body: FutureBuilder(
          future: Future.value(FirebaseAuth.instance.currentUser),
          builder: (ctx, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("items")
                  // .limit(15)
                  .orderBy("publishedDate", descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: circularProgress(),
                  );
                } else {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      ItemModel model = ItemModel.fromJson(
                        dataSnapshot.data!.docs[index].data()
                            as Map<String, dynamic>,
                      );
                      return sourceInfo(model, context);
                    },
                    itemCount: dataSnapshot.data!.docs.length,
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color? background, removeCartFunction, int quantityOfItems = 9}) {
  return InkWell(
    onTap: () {
      Route route =
          MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.orange,
    child: Padding(
      padding: const EdgeInsets.all(6.0),
      // ignore: sized_box_for_whitespace
      child: Container(
        // color: Colors.red,
        // height: 190.0,
        // height: height! * 0.34,
        height: 215.0,
        width: width,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: FadeInImage(
                width: width! * 0.25,
                placeholder: const AssetImage("assets/hold.jpeg"),
                image: NetworkImage(model.thumbnailUrl!),
                // fit: BoxFit.scaleDown,
                imageErrorBuilder: (context, obj, trace) {
                  return Image.asset(
                    "assets/hold.jpeg",
                  );
                },
                fit: BoxFit.scaleDown,
              ),
            ),
            //  const SizedBox(width: 4.0),
            // const SizedBox(width: 4.0),
            Expanded(
              flex: 2,
              // ignore: sized_box_for_whitespace
              child: Container(
                width: width! * 0.75,
                // height: height! * 0.34,
                // eeee
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15.0),
                    // SizedBox(height: (height! * 0.05)),
                    // ignore: avoid_unnecessary_containers
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // ignore: sized_box_for_whitespace
                          Container(
                            width: (width! * 0.25),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                model.title!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    // SizedBox(height: (height! * 0.017)),

                    // ignore: avoid_unnecessary_containers
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // ignore: sized_box_for_whitespace
                          Container(
                            width: (width! * 0.25),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                model.shortInfo!,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 13.0),
                    // SizedBox(height: (height! * 0.03)),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.orange,
                            ),
                            alignment: Alignment.topLeft,
                            // width: (width! * 0.25) - 40,
                            // height: (height! * 0.03),
                            width: 40.0,

                            height: 43.0,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "50%",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    "OFF",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(width: 10.0),
                        SizedBox(width: (width! * 0.1)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              // ignore: sized_box_for_whitespace
                              child: Container(
                                width: (width! * 0.35) - 0,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    children: [
                                      // Container(
                                      //   width: (width! * 0.25) - 2,
                                      //   child: const FittedBox(
                                      //     fit: BoxFit.scaleDown,
                                      //     child: Text(
                                      //       "OLD PRICE:Ksh",
                                      //       style: TextStyle(
                                      //         fontSize: 14.0,
                                      //         color: Colors.grey,
                                      //         decoration:
                                      //             TextDecoration.lineThrough,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      const Text(
                                        "OLD PRICE:Ksh",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      // Container(
                                      //   width: (width! * 0.25) - 55,
                                      //   child: FittedBox(
                                      //     fit: BoxFit.scaleDown,
                                      //     child: Text(
                                      //       (model.price! + model.price!)
                                      //           .toString(),
                                      //       style: const TextStyle(
                                      //         fontSize: 15.0,
                                      //         color: Colors.grey,
                                      //         decoration:
                                      //             TextDecoration.lineThrough,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      Text(
                                        (model.price! + model.price!)
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //==new price==
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              // ignore: sized_box_for_whitespace, avoid_unnecessary_containers
                              child: Container(
                                width: (width! * 0.35) - 0,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    children: [
                                      // Container(
                                      //   width: (width! * 0.25) - 2,
                                      //   child: const FittedBox(
                                      //     fit: BoxFit.scaleDown,
                                      //     child: Text(
                                      //       "NEW PRICE:Ksh",
                                      //       style: TextStyle(
                                      //         fontSize: 14.0,
                                      //         color: Colors.blueGrey,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      // Container(
                                      //   width: (width! * 0.25) - 55,
                                      //   child: FittedBox(
                                      //     fit: BoxFit.scaleDown,
                                      //     child: Text(
                                      //       (model.price!).toString(),
                                      //       style: const TextStyle(
                                      //         fontSize: 15.0,
                                      //         color: Colors.pink,
                                      //         fontWeight: FontWeight.bold,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      const Text(
                                        r"NEW PRICE:",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      const Text(
                                        "Ksh ",
                                        // r"$",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        (model.price!).toString(),
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.pink,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Flexible(
                      child: Container(),
                    ),
                    // ==to implement the cart item add/remove feature==
                    Align(
                      alignment: Alignment.centerRight,
                      child: removeCartFunction == null
                          ? IconButton(
                              onPressed: () {
                                checkItemInCart(model.uid!, context);
                              },
                              icon: const Icon(
                                Icons.shopping_cart,
                                color: Colors.orange,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                removeCartFunction();
                                Route route = MaterialPageRoute(
                                    builder: (c) => const StoreHome());

                                Navigator.push(context, route);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.orange,
                              ),
                            ),
                    ),
                    Divider(
                      height: (height! * 0.012),

                      // height: 5.0,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget card({Color primaryColor = Colors.redAccent, String? imgPath}) {
  return Container(
    height: 150.0,
    width: width! * .34,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          offset: const Offset(0, 5),
          blurRadius: 10.0,
          color: Colors.grey.shade200,
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(
        imgPath!,
        height: 150.0,
        width: width! * .34,
        fit: BoxFit.fill,
      ),
    ),
  );
}

void checkItemInCart(String shortInfoAsID, BuildContext context) async {
  EcommerceApp.sharedPreferences!
          .getStringList(EcommerceApp.userCartList)!
          .contains(shortInfoAsID)
      ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Item is already in Cart.', textAlign: TextAlign.center)))
      : addItemToCart(shortInfoAsID, context);
}

addItemToCart(String shortInfoAsID, BuildContext context) {
  List tempCartList =
      EcommerceApp.sharedPreferences!.getStringList(EcommerceApp.userCartList)!;
  tempCartList.add(shortInfoAsID);
  EcommerceApp.firestore!
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
      .update({
    EcommerceApp.userCartList: tempCartList,
  }).then((v) {
    if (tempCartList.length > 8) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Order Is Full,Check Out",
            style: TextStyle(color: Colors.orange),
          ),
          content: const Text("Do you want to close the alert dialog box?"),
          actions: [
            TextButton(
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (c) => const CartPage());
                Navigator.pushReplacement(context, route);
              },
              child: const Text(
                "YES",
                style: TextStyle(color: Colors.orange),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "NO",
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Item Added to Cart Successfully.',
              textAlign: TextAlign.center)));
      EcommerceApp.sharedPreferences!.setStringList(
          EcommerceApp.userCartList, tempCartList as List<String>);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    }
  });
}
