import 'package:duka/Admin/upload_items.dart';
import 'package:flutter/material.dart';

import 'package:duka/Admin/admin_shift_orders.dart';
import 'package:duka/Admin/admin_store_home.dart';

import 'package:duka/main.dart';

class AppDrawerAdmin extends StatelessWidget {
  const AppDrawerAdmin({Key? key}) : super(key: key);

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
            child: const DrawerHeader(
              child: Center(
                  child: Text(
                "ADMIN",
                style: TextStyle(
                  fontSize: 45.0,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              )),
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
                ListTile(
                  leading: const Icon(Icons.border_color, color: Colors.white),
                  title: const Text(
                    'Shift Orders',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(
                        builder: (c) => const AdminShiftOrders());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                const Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: const Icon(Icons.shop, color: Colors.white),
                  title: const Text(
                    'Shop',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(
                        builder: (c) => const AdminStoreHome());
                    // Navigator.pushReplacement(context, route);
                    Navigator.push(context, route);
                  },
                ),
                const Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.white),
                  title: const Text(
                    'Add Item',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => const UploadPage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                const Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.white),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => const SplashScreen());
                    Navigator.pushReplacement(context, route);
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
