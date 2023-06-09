// ignore_for_file: prefer_const_literals_to_create_immutables, unused_field, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mandala/utils/mycolors.dart';
import 'package:flutter/cupertino.dart';
import 'package:mandala/view/authview/forgotpassword.dart';
import 'package:mandala/view/authview/signup.dart';
import 'package:mandala/view/dashboard.dart';
import 'package:mandala/widgets/mybutton.dart';
import 'package:mandala/widgets/textformfield.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../methods/authmodels.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passController = TextEditingController();

  bool _isChecked = false;
  String _textFieldValue = '';
//function to handle checkbox
  void _handleCheckboxChanged(bool? checkboxState) {
    setState(() {
      _isChecked = checkboxState ?? true;
    });
  }

//function to store value in database
  void _handleTextFieldChanged(String value) {
    setState(() {
      _textFieldValue = value;
    });
  }

  void _showetoast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appbar,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              CupertinoIcons.left_chevron,
              color: Colors.black,
              size: 30,
            ),
          ),
          title: Text(
            "Sign In ",
            style: TextStyle(fontSize: 26, color: appbartitle),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: formGlobalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                ),
                TextFieldInput(
                    validator: (value) {
                      if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onChanged: _handleTextFieldChanged,
                    action: TextInputAction.next,
                    textEditingController: _emailController,
                    hintText: "Email",
                    textInputType: TextInputType.emailAddress),
                SizedBox(
                  height: 16,
                ),
                TextFieldInput(
                    validator: (value) {
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    onChanged: _handleTextFieldChanged,
                    action: TextInputAction.next,
                    textEditingController: _passController,
                    hintText: "Password",
                    textInputType: TextInputType.emailAddress),

                SizedBox(
                  height: 30,
                ),
                //remember me sec
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: _handleCheckboxChanged,
                        ),
                        Text(
                          "Remember Me ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ForgitPassword());
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),

                MyCustomButton(
                    title: "Sign In ",
                    borderrad: 25,
                    onaction: () {
                      if (formGlobalKey.currentState!.validate()) {
                        // FirebaseAuthMethod().loginuser(
                        //   email: _emailController.text,
                        //   pass: _passController.text,
                        // );
                        Get.to(() => Home());
                        _showetoast("Sigin Successfully");
                      } else
                        _showetoast("Please enter valid pass or email");
                    },
                    color1: gd2,
                    color2: gd1,
                    width: MediaQuery.of(context).size.width - 40),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Or"),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                        fit: BoxFit.cover,
                        height: 50,
                        width: 50,
                        image: AssetImage('assets/facebook.png')),
                    SizedBox(
                      width: 50,
                    ),
                    Image(
                        fit: BoxFit.cover,
                        height: 60,
                        width: 60,
                        image: AssetImage('assets/google.png'))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an Accound?",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => SignupPage());
                        },
                        child: Text(
                          "Create new one",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
