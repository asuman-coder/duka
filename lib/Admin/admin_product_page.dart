import 'package:duka/Admin/admin_store_home.dart';
import 'package:duka/Models/item.dart';
import 'package:duka/Widgets/app_drawer_admin.dart';

import 'package:flutter/material.dart';

class AdminProductPage extends StatefulWidget {
  const AdminProductPage({Key? key, required this.itemModel}) : super(key: key);
  final ItemModel itemModel;

  @override
  State<AdminProductPage> createState() => _AdminProductPageState();
}

class _AdminProductPageState extends State<AdminProductPage> {
  int quantityOfItems = 1;
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size screenSize = MediaQuery.of(context).size;
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
            "shop now",
            style: TextStyle(
              fontSize: 45.0,
              color: Colors.white,
              fontFamily: "Signatra",
            ),
          ),
        ),
        drawer: const AppDrawerAdmin(),
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(15.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: FadeInImage(
                          placeholder: const AssetImage("assets/hold.jpeg"),
                          image: NetworkImage(widget.itemModel.thumbnailUrl!),
                          imageErrorBuilder: (context, obj, trace) {
                            return Image.asset(
                              "assets/hold.jpeg",
                            );
                          },
                          fit: BoxFit.contain,
                        ),
                        // child: Image.network(widget.itemModel.thumbnailUrl!),
                      ),
                      Container(
                        color: Colors.grey.shade300,
                        child: const SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.itemModel.title!,
                            style: boldTextStyle,
                          ),
                          const SizedBox(height: 10.0),
                          Text(widget.itemModel.longDescription!),
                          const SizedBox(height: 10.0),
                          Text(
                            // ignore: prefer_interpolation_to_compose_strings
                            "Ksh" + widget.itemModel.price.toString(),
                            style: boldTextStyle,
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (c) => const AdminStoreHome());

                          Navigator.push(context, route);
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
                              "OK,CLICK",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const boldTextStyle =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
