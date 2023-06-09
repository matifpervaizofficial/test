// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mandala/methods/authmodels.dart';
import 'package:mandala/models/usermodel.dart';
import 'package:mandala/view/dashboard.dart';
import 'package:mandala/widgets/pickimages.dart';
import 'package:mandala/widgets/textformfield.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../controllers/signupcontroller.dart';
import '../../utils/mycolors.dart';
import '../../widgets/mybutton.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  //controllers for managing data
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passController = TextEditingController();

  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _mobilecontroller = TextEditingController();
  Uint8List? _image;
//key for handling auth
  final GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();

  bool _isChecked = false;
  String? _errorMessage;

  void _onCheckboxChanged(bool? value) {
    setState(() {
      _isChecked = value ?? false;
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
    _mobilecontroller.dispose();
    _lastnameController.dispose();
    _fnameController.dispose();
    super.dispose();
  }

  String ErrorMessage = "";

//function to select image of user
  void selectimage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: formGlobalKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Stack(children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  AssetImage('assets/blankimage.jpg'),
                            ),
                      Positioned(
                          bottom: -10,
                          left: 75,
                          child: IconButton(
                              onPressed: () {
                                selectimage();
                              },
                              icon: Icon(
                                Icons.add_a_photo_outlined,
                                size: 30,
                              )))
                    ]),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFieldInput(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter your name";
                      }
                      return null;
                    },
                    //textEditingController: controller.fname,

                    textEditingController: controller.fname,
                    hintText: "First Name*",
                    textInputType: TextInputType.emailAddress,
                    action: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldInput(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your name";
                      }
                      return null;
                    },
                    textEditingController: controller.lname,
                    hintText: "Last Name*",
                    textInputType: TextInputType.emailAddress,
                    action: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 20,
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
                    textEditingController: controller.email,
                    hintText: "Email Address*",
                    textInputType: TextInputType.emailAddress,
                    action: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldInput(
                    validator: (value) {
                      if (value.length < 11) {
                        return "Enter a valid number";
                      }
                      return null;
                    },
                    textEditingController: controller.phone,
                    hintText: "Mobile Number*",
                    textInputType: TextInputType.number,
                    action: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldInput(
                    validator: (value) {
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    textEditingController: controller.pass,
                    hintText: "Password",
                    textInputType: TextInputType.emailAddress,
                    action: TextInputAction.next,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: _onCheckboxChanged,
                      ),
                      Text(
                        "I accept all terms and conditions ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  MyCustomButton(
                      title: "Sign Up ",
                      borderrad: 25,
                      onaction: () {
                        if (formGlobalKey.currentState!.validate()) {
                          if (_isChecked == true) {
                            final user = UserModel(
                                email: controller.email.text.trim(),
                                fname: controller.fname.text.toString(),
                                lname: controller.lname.text.trim(),
                                pass: controller.pass.text.trim(),
                                phone: controller.phone.text.trim());
                            SignupController.instance.registeruser(
                                controller.email.text.trim(),
                                controller.pass.text.trim());
                            SignupController.instance.createUser(user
                                // controller.email.text.trim(),
                                // controller.pass.text.trim()
                                );
                            // FirebaseAuthMethod().signupUser(
                            //     email: _emailController.text,
                            //     fname: _fnameController.text,
                            //     lname: _lastnameController.text,
                            //     mobilenum: _mobilecontroller.text,
                            //     pass: _passController.text,
                            //     file: _image!);
                            Get.to(() => Home());
                            _showetoast("Signup Successfully");
                          } else
                            _showetoast(
                                "Please Accept our terms and conditions");
                        }
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
                      GestureDetector(
                        child: Image(
                            fit: BoxFit.cover,
                            height: 50,
                            width: 50,
                            image: AssetImage('assets/facebook.png')),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      GestureDetector(
                        // onTap: () async {
                        //   User? user =
                        //       await FirebaseAuthMethod().signInWithGoogle();
                        //   if (user != null) {
                        //     await FirebaseAuthMethod().addUserToFirestore(user);
                        //   }

                        //   FirebaseAuthMethod().signInWithGoogle();
                        // },
                        child: Image(
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
                            image: AssetImage('assets/google.png')),
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
}
