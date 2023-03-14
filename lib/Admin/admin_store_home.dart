import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duka/Admin/admin_product_page.dart';
import 'package:duka/Models/item.dart';
import 'package:duka/Widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:duka/Widgets/app_drawer_admin.dart';

double? width;
double? height;

class AdminStoreHome extends StatefulWidget {
  const AdminStoreHome({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminStoreHome> createState() => _AdminStoreHomeState();
}

class _AdminStoreHomeState extends State<AdminStoreHome> {
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
          "shop now",
          style: TextStyle(
            fontSize: 45.0,
            color: Colors.white,
            fontFamily: "Signatra",
          ),
        ),
        centerTitle: true,
      ),
      drawer: const AppDrawerAdmin(),
      body: FutureBuilder(
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: circularProgress());
          }

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("items")
                // .limit(15)b
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
                    return sourceAdminInfo(model, context);
                  },
                  itemCount: dataSnapshot.data!.docs.length,
                );
              }
            },
          );
        },
      ),
      // ]),
    ));
  }
}

Widget sourceAdminInfo(ItemModel model, BuildContext context,
    {Color? background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(
        builder: (c) =>
            // AdminProductPage(itemModel: model),
            AdminProductPage(itemModel: model),
      );
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.orange,
    child: Padding(
      padding: const EdgeInsets.all(6.0),
      // ignore: sized_box_for_whitespace
      child: Container(
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
                                      //       r"NEW PRICE:Ksh",
                                      //       style: TextStyle(
                                      //         fontSize: 14.0,
                                      //         color: Colors.blueGrey,
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
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 16.0),
                                      ),
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
                      child: IconButton(
                        alignment: Alignment.bottomLeft,
                        onPressed: () async {
                          try {
                            final docUser = FirebaseFirestore.instance
                                .collection("items")
                                .doc(model.uid);
                            await docUser.delete().then((value) =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Item deleted Successfully.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ));
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Deleting failed!',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
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
