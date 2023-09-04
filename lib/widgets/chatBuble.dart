
import 'package:flutter/material.dart';

import '../constant/colors.dart';

class custom_chatBuble extends StatelessWidget {
  const custom_chatBuble({
    super.key,required this.message
  });
final String message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        padding: const EdgeInsets.only(left: 16,top: 16,bottom: 16,right: 16),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(15),
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15)),
          color: kPrimaryColor,
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
class CustomChatBubleForFriend extends StatelessWidget {
  const CustomChatBubleForFriend({
    super.key,required this.message
  });
  final String message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        padding: const EdgeInsets.only(left: 16,top: 16,bottom: 16,right: 16),

        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15)),
          color: sPrimaryColor,
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}