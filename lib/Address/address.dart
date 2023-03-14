import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duka/Address/add_address.dart';
import 'package:duka/Config/config.dart';
import 'package:duka/Counters/change_address.dart';
import 'package:duka/Models/address.dart';
import 'package:duka/Orders/place_order_payment.dart';
import 'package:duka/Widgets/custom_app_bar.dart';
import 'package:duka/Widgets/loading_widget.dart';
import 'package:duka/Widgets/wide_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Address extends StatefulWidget {
  const Address({Key? key, required this.totalAmount}) : super(key: key);
  final double totalAmount;

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Select Address",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Consumer<AddressChanger>(builder: (context, address, c) {
              return Flexible(
                child: StreamBuilder<QuerySnapshot>(
                    stream: EcommerceApp.firestore!
                        .collection(EcommerceApp.collectionUser)
                        .doc(EcommerceApp.sharedPreferences!
                            .getString(EcommerceApp.userUID))
                        .collection(EcommerceApp.subCollectionAddress)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(
                              child: circularProgress(),
                            )
                          // ignore: prefer_is_empty
                          : snapshot.data!.docs.length == 0
                              ? noAddressCard()
                              : ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return AddressCard(
                                      currentIndex: address.count,
                                      value: index,
                                      addressId: snapshot.data!.docs[index].id,
                                      totalAmount: widget.totalAmount,
                                      model: AddressModel.fromJson(
                                          snapshot.data!.docs[index].data()
                                              as Map<String, dynamic>),
                                    );
                                  },
                                );
                    }),
              );
            }),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AddAddress());
            Navigator.pushReplacement(context, route);
          },
          label: const Text("Add New Address"),
          backgroundColor: Colors.orange,
          icon: const Icon(Icons.add_location),
        ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.orange.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add_location,
              color: Colors.white,
            ),
            Text("No shipment address has been saved."),
            Text(
                "Please add your shipment Address so that we can deliver product."),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  const AddressCard({
    Key? key,
    required this.model,
    required this.addressId,
    required this.totalAmount,
    required this.currentIndex,
    required this.value,
  }) : super(key: key);
  final AddressModel model;
  final String addressId;
  final double totalAmount;
  final int currentIndex;
  final int value;

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(context, listen: false)
            .displayResult(widget.value);
      },
      child: Card(
        color: Colors.orangeAccent.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.orange,
                  onChanged: (int? val) {
                    Provider.of<AddressChanger>(context, listen: false)
                        .displayResult(val!);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      width: screenWidth * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              const KeyText(msg: "Name"),
                              Text(widget.model.name!),
                            ],
                          ),
                          TableRow(
                            children: [
                              const KeyText(msg: "Phone Number"),
                              Text(widget.model.phoneNumber!),
                            ],
                          ),
                          TableRow(
                            children: [
                              const KeyText(msg: "Flat Number"),
                              Text(widget.model.flatNumber!),
                            ],
                          ),
                          TableRow(
                            children: [
                              const KeyText(msg: "City"),
                              Text(widget.model.city!),
                            ],
                          ),
                          TableRow(
                            children: [
                              const KeyText(msg: "State"),
                              Text(widget.model.state!),
                            ],
                          ),
                          TableRow(
                            children: [
                              const KeyText(msg: "Pin Code"),
                              Text(widget.model.pincode!),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).count
                ? WideButton(
                    message: "Proceed",
                    onPressed: () {
                      Route route = MaterialPageRoute(
                          builder: (c) => PaymentPage(
                                addressId: widget.addressId,
                                totalAmount: widget.totalAmount,
                              ));
                      Navigator.push(context, route);
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
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
