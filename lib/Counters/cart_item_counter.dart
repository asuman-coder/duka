import 'package:duka/Config/config.dart';
import 'package:flutter/material.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter = (EcommerceApp.sharedPreferences!
              .getStringList(EcommerceApp.userCartList)
              ?.length ??
          0) -
      1;
  int get count => _counter;

  Future<void> displayResult() async {
    _counter = ((EcommerceApp.sharedPreferences!
                .getStringList(EcommerceApp.userCartList)
                ?.length ??
            0) -
        1);

    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
// as List<String>