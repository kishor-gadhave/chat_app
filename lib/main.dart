import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:massagingapp/pages/HomePage.dart';
import 'package:massagingapp/pages/LoginPage.dart';
import 'package:uuid/uuid.dart';

import 'models/FirebaseHelper.dart';
import 'models/UserModel.dart';


var uuid =  Uuid();

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyAfrYYSMZE3m_A9mpuTfdkobuV-wpAhKV8', // paste your api key here
        appId: "1:285683176277:android:7a964ba336a0829cbd95dc", //paste your app id here
        messagingSenderId:'285683176277', //paste your messagingSenderId here
        projectId: "chat-app-bf250",
        storageBucket:"chat-app-bf250.appspot.com" //paste your project id here
    ),
  );
  await FirebaseAppCheck.instance.activate();

  User? currentUser = FirebaseAuth.instance.currentUser;
  if(currentUser != null) {
    // Logged In
    UserModel? thisUserModel = await FirebaseHelper.getUserModelById(currentUser.uid);
    if(thisUserModel != null) {
      runApp(MyAppLoggedIn(userModel: thisUserModel, firebaseUser: currentUser));
    }
    else {
      runApp(MyApp());
    }
  }
  else {
    // Not logged in
    runApp(MyApp());
  }
}



// Not Logged In
class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}


// Already Logged In
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(userModel: userModel, firebaseUser: firebaseUser),
    );
  }
}