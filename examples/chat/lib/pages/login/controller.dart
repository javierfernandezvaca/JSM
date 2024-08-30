import 'dart:io';

import 'package:chat/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jsm/jsm.dart';

class LoginController extends JController {
  final firebase = JService.find<FirebaseService>();

  @override
  void onInit() {}

  @override
  void onReady() {
    if (firebase.authStatus.value == AuthStatus.authenticated) {
      JRouter.offNamed(page: '/chat');
    }
  }

  @override
  void onClose() {}

  void onSignIn() async {
    try {
      UserCredential userCredential = await firebase.signInWithGoogle();
      if (userCredential.user != null) {
        await createUser();
        JRouter.offNamed(page: '/chat');
      } else {
        JDialog.snackBar(
          content: const Text('User could not be authenticated'),
        );
      }
    } catch (e) {
      JDialog.snackBar(
        content: const Text('An error occurred during authentication'),
      );
      JConsole.error('Error on [onSignIn]: $e');
    }
  }

  Future<void> createUser() async {
    User user = firebase.currentUser.value!;
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    DocumentReference userDoc = userCollection.doc(user.uid);
    DocumentSnapshot docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      await userDoc.set({
        'email': user.email,
        'id': user.uid,
        'name': user.displayName,
        'photo': user.photoURL,
      });
    }
  }

  onExitApp() {
    JDialog.materialConfirmationDialog(
      title: const Text('Confirm'),
      content: const Text('Do you want to exit the app?'),
      confirmLabel: const Text('OK'),
      onConfirm: () async {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
    );
  }

  // ...
}
