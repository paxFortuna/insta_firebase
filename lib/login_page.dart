import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Instagram clon',
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.all(50.0),
            ),
            SignInButton(
              Buttons.Google,
              onPressed: () {
                _handleSignIn().then((user) {
                  print(user);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> _handleSignIn() async {
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    // final GoogleAuthCredential 대신 OAuthCredential
    final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);

  }
}