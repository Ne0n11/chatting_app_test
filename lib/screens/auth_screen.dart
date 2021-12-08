import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/auth_form.dart';
import 'dart:io';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  var _isLoading = false;

  Future<void> _submitAuthForm(String userEmail, String userName, String userPassword, File userFile, bool isLogin, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );
      } else {

        authResult = await _auth.createUserWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );

       final storageRef = FirebaseStorage.instance.ref()
            .child('user_image').child(authResult.user!.uid + '.jpeg');

       await storageRef.putFile(userFile);

       final url = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection("users").doc(authResult.user!.uid).set({
          'username' : userName,
          'email' : userEmail,
          'imageUrl' : url,
        });

      }

    }on PlatformException catch(error){
      var message = "An error occurred please check your credentials";
      if(error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(ctx).errorColor,
          ));
      setState(() {
        _isLoading = false;
      });
    }catch(error){
        print(error);
        setState(() {
          _isLoading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(),
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}

