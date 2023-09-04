import 'package:chatapp/firebase_error.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/pages/register_page.dart';
import 'package:chatapp/widgets/custom_button.dart';
import 'package:chatapp/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constant/colors.dart';
import '../widgets/showSnackBar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String routeName = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Image.asset('assets/images/scholar.png'),
                  const Text(
                    'Scholar Chat',
                    style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 40,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'sign in',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  CustomTextFormField(
                      validator: (value) {
                        if (value?.trim() == '' || value!.isEmpty) {
                          return 'enter email';
                        }
                        final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!emailValid) {
                          return 'correct email';
                        }
                      },
                      controller: emailController,
                      hintText: 'Email',
                      suffixIcon: const Icon(Icons.email_outlined)),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextFormField(
                    isPassword: isPassword,
                    validator: (value) {
                      if (value?.trim() == '' || value!.isEmpty) {
                        return 'enter password';
                      }
                    },
                    controller: passwordController,
                    hintText: 'Password',
                    suffixIcon: IconButton(
                        onPressed: () {
                          isPassword = !isPassword;
                          setState(() {
                            print(isPassword);
                          });
                        },
                        icon: isPassword
                            ? const Icon(Icons.remove_red_eye_outlined)
                            : const Icon(Icons.remove_red_eye)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomButton(
                    txt: 'Sign In',
                    onPressed: () async{
                     await loginUser();
                    },
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'don\'t have as account',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterPage.routeName);
                        },
                        child: const Text(
                          'Sign up ',
                          // style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  loginUser()async {
    if(formKey.currentState!.validate()){

      setState(() {
        isLoading=true;
      });
      try {
        await authDone();
        navigatorToChatScreen();
      } on FirebaseAuthException catch (e) {
        authError(e);
      }
      setState(() {
        isLoading=false;
      });

    }



  }

  void navigatorToChatScreen() {
        showSnackBar(massage: FirebaseError.success,context: context);
    Navigator.pushReplacementNamed(context, ChatPage.routeName,arguments:emailController.text );
  }

  Future<void> authDone() async {
     final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
    );
  }

  void authError(FirebaseAuthException e) {
      if (e.code == FirebaseError.userNotFound) {
        showSnackBar(massage:  FirebaseError.noUserFound,context: context);

    } else if (e.code == FirebaseError.wrongPassword) {
        showSnackBar(massage: FirebaseError.wrongPasswordMassage, context: context);
    }
  }

}
