import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({required this.txt,this.onPressed,super.key});

  final String txt;
  final  Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        foregroundColor: Colors.orange,
      ),
      onPressed: onPressed,
      child: Text(
        txt,
        style: const TextStyle(color: Color(0xff2B475E), fontSize: 25),
      ),
    );
  }
}
