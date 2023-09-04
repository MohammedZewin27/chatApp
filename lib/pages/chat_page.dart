import 'package:chatapp/constant/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widgets/chatBuble.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  static const String routeName = 'ChatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final chatController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final CollectionReference message =
  FirebaseFirestore.instance.collection(kMessageCollections);
  final controller = ScrollController();


  @override
  Widget build(BuildContext context) {
    String mail = ModalRoute
        .of(context)
        ?.settings
        .arguments as String;
    return StreamBuilder<QuerySnapshot>(
      stream: message.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    kLogo,
                    height: 50,
                  ),
                  const Text('Scholar Chat'),
                ],
              ),
              backgroundColor: kPrimaryColor,
            ),
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        reverse: true,
                        controller: controller,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) =>
                        snapshot.data?.docs[index]['id'] == mail
                            ? custom_chatBuble(
                          message: snapshot.data?.docs[index]['message'],
                        ):CustomChatBubleForFriend(
                          message: snapshot.data?.docs[index]['message'],
                        ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: chatController,
                      onSubmitted: (value) async {
                        await message.add({
                          kMessage: value,
                          kCreatedAt: DateTime.now(),
                          'id': mail
                        });
                        chatController.clear();
                        controller.animateTo(
                          0,
                          // controller.position.maxScrollExtent,
                          curve: Curves.easeIn,
                          duration: const Duration(milliseconds: 500),
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Send Message',
                        suffixIcon: IconButton(
                          onPressed: () async {
                            await message.add({"message": chatController.text});
                          },
                          icon: const Icon(Icons.send, color: kPrimaryColor),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: kPrimaryColor,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: kPrimaryColor,
                            )),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: ModalProgressHUD(
              color: kPrimaryColor,

              inAsyncCall: true,
              child: Center(
                  child: Text('Loading')),
            ),
          );
        }
      },
    );
  }
}
