// // ignore_for_file: annotate_overrides

import 'package:duka/Config/config.dart';
import 'package:duka/Counters/cart_item_counter.dart';
import 'package:duka/Store/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  MyAppBar({Key? key, this.bottom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (c) => const CartPage());
                Navigator.pushReplacement(context, route);
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
                        builder: (context, counter, _) {
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
                          // fontWeight: FontWeight.w500,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ignore: unnecessary_null_comparison, annotate_overrides
  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
