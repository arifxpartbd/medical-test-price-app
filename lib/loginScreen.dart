import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medicaltestpriceappbd/homeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<UserCredential?> _singInWithGoogle(BuildContext context) async {
    if (kIsWeb) {
      //for web app, use signInWithPopus instead of signInWithCredential
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);
        return userCredential;
      } catch (e) {
        print("Error signin in with google $e");

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to sign in with google"),
        ));
        return null;
      }
    } else {
      //for android and ios apps, use signin instead of signinwithcredential
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        return userCredential;
      } catch (e) {
        print("Error signin in with google: $e");

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to sign in with google"),
        ));
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Expanded(
            flex: 4,
            child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  "images/medical_background.png",
                  fit: BoxFit.cover,
                ))),
        Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Bangladesh All Medical Test Price",style: TextStyle(
                    fontWeight: FontWeight.bold,fontSize: 25
                  ),),
                  const SizedBox(height: 100,),
                  GestureDetector(
                    onTap: ()async{
                      UserCredential? userCredential =
                          await _singInWithGoogle(context);

                      if (userCredential != null) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => HomeScreen()));
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset("images/googleicon.png",)),
                        const SizedBox(width: 15,),
                        Expanded(
                          child: Container(
                              color: Colors.red,
                              child: const Padding(
                                padding: EdgeInsets.all(17.0),
                                child: Text("Login With Google",style: TextStyle(
                                  fontWeight: FontWeight.bold,letterSpacing: 1,color: Colors.white,
                                ),),
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
        )
      ],
    ));
  }
}
