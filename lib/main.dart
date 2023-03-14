import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duka/Authentication/authentication.dart';
import 'package:duka/Config/config.dart';
import 'package:duka/Counters/cart_item_counter.dart';
import 'package:duka/Counters/change_address.dart';
import 'package:duka/Counters/item_quantity.dart';
import 'package:duka/Counters/total_money.dart';
import 'package:duka/Store/store_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) => const Scaffold(
        body: Center(
          child: Text(
            "Something Went Wrong.",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = FirebaseFirestore.instance;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => ItemQuantity()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
        // ChangeNotifierProvider(create: (c) => Products()),
      ],
      child: MaterialApp(
        builder: (context, widget) => ResponsiveWrapper.builder(
          ClampingScrollWrapper.builder(context, widget!),
          breakpoints: [
            const ResponsiveBreakpoint.resize(350, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(600, name: TABLET),
            const ResponsiveBreakpoint.resize(800, name: DESKTOP),
            const ResponsiveBreakpoint.autoScale(1700, name: "XL"),
          ],
        ),
        title: 'shop now',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    displaySplash();
  }

  displaySplash() {
    Timer(const Duration(seconds: 5), () async {
      if (EcommerceApp.auth!.currentUser != null) {
        Route route = MaterialPageRoute(builder: (_) => const StoreHome());
        Navigator.pushReplacement(context, route);
      } else {
        Route route =
            MaterialPageRoute(builder: (_) => const AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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

        // color: Colors.black45,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/welcome.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  // width: 300,
                  // cacheWidth: (300 * devicePixelRatio).round(),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Welcome To The Online Shop",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
