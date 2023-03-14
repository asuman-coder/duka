import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duka/Models/item.dart';
import 'package:duka/Orders/order_details_page.dart';
import 'package:flutter/material.dart';

int counter = 0;
double? width;
double? height;

class OrderCard extends StatelessWidget {
  const OrderCard({
    Key? key,
    required this.itemmCount,
    required this.data,
    this.orderID,
  }) : super(key: key);
  final int itemmCount;
  final List<DocumentSnapshot> data;
  final String? orderID;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route;
        if (counter == 0) {
          counter = counter + 1;
          route = MaterialPageRoute(
              builder: (c) => OrderDetails(orderID: orderID as String));
          Navigator.push(context, route);
        }
      },
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
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(10.0),
        height: itemmCount * 190.0,
        child: ListView.builder(
          itemCount: itemmCount,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (c, index) {
            ItemModel model =
                ItemModel.fromJson(data[index].data() as Map<String, dynamic>);
            return sourceOrderInfo(model, context);
          },
        ),
      ),
    );
  }
}

Widget sourceOrderInfo(ItemModel model, BuildContext context,
    {Color? background}) {
  width = MediaQuery.of(context).size.width;
  height = MediaQuery.of(context).size.height;

  return Container(
    color: Colors.grey.shade100,
    height: 170.0,
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
                    SizedBox(width: (width! * 0.1)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                  const Text(
                                    r"TOTAL PRICE:",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  const Text(
                                    "Ksh",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16.0),
                                  ),
                                  Text(
                                    (model.price!).toString(),
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.pink,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Container(
                                  //   width: (width! * 0.25) - 60,
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
  );
}
