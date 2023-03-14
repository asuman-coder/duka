import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duka/Admin/admin_order_details.dart';
import 'package:duka/Models/item.dart';
import 'package:duka/Widgets/order_card.dart';
import 'package:flutter/material.dart';

int counter = 0;

class AdminOrderCard extends StatelessWidget {
  const AdminOrderCard(
      {Key? key,
      required this.itemmCount,
      required this.data,
      this.orderID,
      required this.addressID,
      required this.orderBy})
      : super(key: key);
  final int itemmCount;
  final List<DocumentSnapshot> data;
  final String? orderID;
  final String addressID;
  final String orderBy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Route route;
        if (counter == 0) {
          counter = counter + 1;
          route = MaterialPageRoute(
              builder: (c) => AdminOrderDetails(
                    orderID: orderID!,
                    orderBy: orderBy,
                    addressID: addressID,
                  ));
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
