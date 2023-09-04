import 'package:chatapp/firebase_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constant/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/showSnackBar.dart';
import 'chat_page.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  static const String routeName = 'RegisterPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPassword = true;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall:isLoading ,
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
                      'Sign Up',
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
                      hintText: 'Email',
                      suffixIcon: const Icon(Icons.email_outlined),
                      controller: emailController),
                  const SizedBox(
                    height: 12,
                  ),
                  const SizedBox(
                    height: 15,
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
                    txt: 'Sign Up',
                    onPressed: () async {
                      await authUser();
                    },
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'I have as account',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Sign In ',
                          // style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> authUser() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading=true;
      });
      try {
        await registerUser();
        navigatorToChatScreen();
      } on FirebaseAuthException catch (e) {
        autException(e);
      } catch (e) {
        showSnackBar(massage:FirebaseError.somethingError,context: context );
      }
      setState(() {
        isLoading=false;
      });
    }
  }

  void autException(FirebaseAuthException e) {
    if (e.code == FirebaseError.weakPasswordError) {
      showSnackBar(massage: FirebaseError.weakPassword,context: context);
    } else if (e.code == FirebaseError.emailAlreadyAnUse) {
      showSnackBar(massage: FirebaseError.emailExists,context: context);
    }
  }

  // void showSnackBar({required String massage}) {
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text(massage)));
  // }
  void navigatorToChatScreen() {
    showSnackBar(massage: FirebaseError.success,context: context);
    Navigator.pushReplacementNamed(context, ChatPage.routeName);
  }

  Future<void> registerUser() async {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    showSnackBar(massage: FirebaseError.success,context: context);
  }
}
