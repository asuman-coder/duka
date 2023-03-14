import 'package:duka/Address/add_address.dart';
import 'package:duka/Authentication/authentication.dart';
import 'package:duka/Config/config.dart';
import 'package:duka/Orders/my_orders.dart';
import 'package:duka/Store/cart.dart';
import 'package:duka/Store/search.dart';
import 'package:duka/Store/store_home.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.lightGreenAccent],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80.0)),
                  elevation: 8.0,
                  // ignore: sized_box_for_whitespace
                  child: Container(
                    height: 160.0,
                    width: 160.0,
                    child: CircleAvatar(
                      // radius: 160,
                      backgroundImage: NetworkImage(
                        EcommerceApp.sharedPreferences
                            ?.getString(EcommerceApp.userAvatarUrl) as String,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                // ignore: sized_box_for_whitespace
                Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      EcommerceApp.sharedPreferences
                          ?.getString(EcommerceApp.userName) as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontFamily: "Signatra",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.lightGreenAccent],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                //==FIRST LISTILE==
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => const StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                const Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                //==2ND LISTILE==
                ListTile(
                  leading: const Icon(
                    Icons.reorder,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "My Orders",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => const MyOrders());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                const Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                //==3RD LISTILE==
                ListTile(
                  leading: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "My Cart",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => const CartPage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                const Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                //==4TH LISTILE==
                ListTile(
                  leading: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Search",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(
                        builder: (c) => const SearchProduct());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                const Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                //==5TH LISTILE==
                ListTile(
                  leading: const Icon(
                    Icons.add_location,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Add New Address",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => AddAddress());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                const Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                //==6TH LISTILE==
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    EcommerceApp.auth!.signOut().then((c) {
                      Route route = MaterialPageRoute(
                          builder: (c) => const AuthenticScreen());
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),
                const Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
