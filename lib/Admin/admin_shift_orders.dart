import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duka/Admin/admin_order_card.dart';
import 'package:duka/Config/config.dart';
import 'package:duka/Widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminShiftOrders extends StatefulWidget {
  const AdminShiftOrders({Key? key}) : super(key: key);

  @override
  State<AdminShiftOrders> createState() => _AdminShiftOrdersState();
}

class _AdminShiftOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
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
          centerTitle: true,
          title: const Text(
            "My Orders",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              icon: const Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("orders").snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("items")
                              .where("uid",
                                  whereIn: snapshot.data!.docs[index]
                                      [EcommerceApp.productID])
                              .get(),
                          builder: (c, snap) {
                            return snap.hasData
                                ? AdminOrderCard(
                                    itemmCount: snap.data!.docs.length,
                                    data: snap.data!.docs,
                                    orderID: snapshot.data!.docs[index].id,
                                    orderBy: snapshot.data!.docs[index]
                                        ["orderBy"],
                                    addressID: snapshot.data!.docs[index]
                                        ["addressID"],
                                  )
                                : Center(
                                    child: circularProgress(),
                                  );
                          });
                    },
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
