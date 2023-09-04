import 'package:flutter/material.dart';

void showSnackBar({required context,required String massage}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(massage)));
}
