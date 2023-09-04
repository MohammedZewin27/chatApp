import 'package:flutter/services.dart';

class Message{
  final String massage;
  final String id;

  Message({required this.massage,required this.id});


  factory Message.fromJson(json){
    return Message(massage: json[KeyMessage],id: json['id']);
  }
}