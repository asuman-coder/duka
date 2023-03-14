import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  const WideButton({Key? key, required this.message, required this.onPressed})
      : super(key: key);
  final String message;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Center(
        child: InkWell(
          onTap: onPressed,
          child: Container(
            decoration: const BoxDecoration(color: Colors.orange),
            width: MediaQuery.of(context).size.width * 0.85,
            height: 50.0,
            child: Center(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
