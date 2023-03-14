import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duka/Admin/upload_items.dart';
import 'package:duka/Config/config.dart';
import 'package:duka/Models/address.dart';
import 'package:duka/Widgets/loading_widget.dart';
import 'package:duka/Widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String getOrderId = "";

class AdminOrderDetails extends StatelessWidget {
  const AdminOrderDetails(
      {Key? key,
      required this.orderID,
      required this.orderBy,
      required this.addressID})
      : super(key: key);
  final String orderID;
  final String orderBy;
  final String addressID;

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore!
                .collection(EcommerceApp.collectionOrders)
                .doc(getOrderId)
                .get(),
            builder: (c, snapshot) {
              Map? dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data!.data() as Map;
              }
              return snapshot.hasData
                  // ignore: avoid_unnecessary_containers, sized_box_for_whitespace
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          AdminStatusBanner(
                            status: dataMap![EcommerceApp.isSuccess],
                          ),
                          const SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              // ignore: avoid_unnecessary_containers
                              child: Container(
                                // width:
                                //     (MediaQuery.of(context).size.width * 0.5) -
                                //         90,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    "Ksh" +
                                        dataMap[EcommerceApp.totalAmount]
                                            .toString(),
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            // ignore: prefer_interpolation_to_compose_strings, avoid_unnecessary_containers
                            child: Container(
                              // width: (MediaQuery.of(context).size.width * 0.6) -
                              //     10,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                // ignore: prefer_interpolation_to_compose_strings
                                child: Text("Order ID: " + getOrderId),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            // ignore: avoid_unnecessary_containers
                            child: Container(
                              // width: (MediaQuery.of(context).size.width * 0.6) -
                              //     10,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  // ignore: prefer_interpolation_to_compose_strings
                                  "Ordered at: " +
                                      DateFormat("dd MMMM, yyyy - hh:mm aa")
                                          .format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dataMap["orderTime"]),
                                        ),
                                      ),
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(height: 2.0),
                          FutureBuilder<QuerySnapshot>(
                            future: EcommerceApp.firestore!
                                .collection("items")
                                .where("uid",
                                    whereIn: dataMap[EcommerceApp.productID])
                                .get(),
                            builder: (c, dataSnapshot) {
                              return dataSnapshot.hasData
                                  ? OrderCard(
                                      itemmCount:
                                          dataSnapshot.data!.docs.length,
                                      data: dataSnapshot.data!.docs,
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                          const Divider(height: 2.0),
                          FutureBuilder<DocumentSnapshot>(
                            future: EcommerceApp.firestore!
                                .collection(EcommerceApp.collectionUser)
                                .doc(orderBy)
                                .collection(EcommerceApp.subCollectionAddress)
                                .doc(addressID)
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? AdminShippingDetails(
                                      model: AddressModel.fromJson(snap.data!
                                          .data() as Map<String, dynamic>),
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: circularProgress(),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class AdminStatusBanner extends StatelessWidget {
  const AdminStatusBanner({Key? key, required this.status}) : super(key: key);
  final bool status;

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;
    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successful" : msg = "UnSuccessful";
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
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              SystemNavigator.pop();
            },
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: const Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 20.0),
          // Text("Order Placed" +msg),
          Text(
            "Order Shipped$msg",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 5.0),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminShippingDetails extends StatelessWidget {
  const AdminShippingDetails({Key? key, required this.model}) : super(key: key);
  final AddressModel model;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20.0),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Shipment Details:",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 90.0,
            vertical: 5.0,
          ),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(
                children: [
                  const KeyText(msg: "Name"),
                  Text(model.name!),
                ],
              ),
              TableRow(
                children: [
                  const KeyText(msg: "Phone Number"),
                  Text(model.phoneNumber!),
                ],
              ),
              TableRow(
                children: [
                  const KeyText(msg: "Flat Number"),
                  Text(model.flatNumber!),
                ],
              ),
              TableRow(
                children: [
                  const KeyText(msg: "City"),
                  Text(model.city!),
                ],
              ),
              TableRow(
                children: [
                  const KeyText(msg: "State"),
                  Text(model.state!),
                ],
              ),
              TableRow(
                children: [
                  const KeyText(msg: "Pin Code"),
                  Text(model.pincode!),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                confirmParcelShifted(context, getOrderId);
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
                width: MediaQuery.of(context).size.width - 40.0,
                height: 50.0,
                child: const Center(
                  child: Text(
                    "Confirm Parcel Shifted",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  confirmParcelShifted(BuildContext context, String myOrderId) {
    EcommerceApp.firestore!
        .collection(EcommerceApp.collectionOrders)
        .doc(myOrderId)
        .delete();
    getOrderId = "";

    Route route = MaterialPageRoute(builder: (c) => const UploadPage());
    Navigator.pushReplacement(context, route);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Parcel has been Shifted.Confirmed.',
            textAlign: TextAlign.center)));
  }
}

class KeyText extends StatelessWidget {
  const KeyText({Key? key, required this.msg}) : super(key: key);
  final String msg;
  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
