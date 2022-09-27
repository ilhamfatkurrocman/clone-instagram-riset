import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:instagram_clone/resources/storage_method.dart';
import 'package:matcher/matcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String response = "Some error occurred";

    try {
      if (email.isNotEmpty ||
              password.isNotEmpty ||
              username.isNotEmpty ||
              bio.isNotEmpty
          // file != null
          ) {
        //Register user
        UserCredential create = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(create.user!.uid);

        //Call storage method
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profileImage', file, false);

        //Add user to our database
        await _firestore.collection('users').doc(create.user!.uid).set({
          'username': username,
          'uid': create.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'photoUrl': photoUrl,
        });

        response = "Success";
      }
    } catch (e) {
      response = e.toString();
    }

    return response;
  }
}
