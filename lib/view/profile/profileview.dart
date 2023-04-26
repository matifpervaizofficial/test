// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mandala/models/authmodels.dart';
import 'package:mandala/widgets/mybutton.dart';

import '../../models/usermodel.dart';
import '../../providers/userprovider.dart';
import '../../utils/mycolors.dart';
import 'editprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String username = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  // adddata() async {
  //   UserProvider _userprovider = Provider.of(context, listen: false);
  //   _userprovider.refreshUser();
  // }

  getUser() async {
    var snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Map data = snap.data() as Map<String, dynamic>;
    print(snap);
    setState(() {
//      username = (snap.data() as Map<String, dynamic>)['fname'];
      username = data['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
//    UserModel? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        backgroundColor: appbar,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appbar,
          leading: const Icon(
            CupertinoIcons.left_chevron,
            color: Colors.black,
            size: 30,
          ),
          title: const Text(
            "Hi, Abc",
            style: TextStyle(fontSize: 26, color: appbartitle),
          ),
          actions: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                CupertinoIcons.settings,
                color: Colors.black,
                size: 30,
              ),
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Stack(children: [
                      const CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage('assets/dp.jpg'),
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1 / 40,
                  ),
                  Text(
                    username,
                    //                   user!.email,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1 / 20,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.email),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        '',
                        // user.email.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.phone),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        //user.mobilenum,
                        '',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1 / 7.5,
                  ),
                  MyCustomButton(
                      title: "Edit Profile",
                      borderrad: 25,
                      onaction: () {
                        Get.to(() => EditProfile());
                      },
                      color1: gd2,
                      color2: gd1,
                      width: MediaQuery.of(context).size.width - 40),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            // FirebaseAuthMethod().signOut();
                          },
                          icon: Icon(
                            Icons.logout_rounded,
                            color: red,
                            size: 40,
                          )),
                      const Text(
                        "Log out",
                        style: TextStyle(
                            color: red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ],
              ),
            )));
  }
}
