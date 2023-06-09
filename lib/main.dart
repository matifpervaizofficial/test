// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mandala/providers/userprovider.dart';
import 'package:mandala/view/authview/signup.dart';
import 'package:mandala/view/createpannel/drawpage.dart';
import 'package:mandala/widgets/create.dart';
import 'package:mandala/view/profile/profileview.dart';
import 'package:mandala/view/settings/settingsscreen.dart';
import 'package:mandala/view/authview/login.dart';
import 'package:mandala/view/colorpannel/animal.dart';
import 'package:mandala/view/colorpannel/fillcolor.dart';
import 'package:mandala/view/dashboard.dart';
import 'package:provider/provider.dart';

import 'controllers/authenticationmodels.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(() => AuthRepo()));
  // .then((value) => print("connected " + value.options.asMap.toString()))
  // .catchError((e) => print(e.toString()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return DrawingPage();
            }
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('\${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return DrawingPage();
        },
      ),
    );
  }
}
