import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jsm/jsm.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase_options.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class FirebaseService extends JService {
  JObservable<AuthStatus> get authStatus => _status;
  final _status = AuthStatus.unknown.observable;

  JObservable<User?> get currentUser =>
      FirebaseAuth.instance.currentUser.observable;

  @override
  Future<void> onInit() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    FirebaseAuth.instance.authStateChanges().listen((User? userAuth) {
      _status.value = (userAuth != null)
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
    });
  }

  @override
  Future<void> onClose() async {}

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect();
      }
    }
    await FirebaseAuth.instance.signOut();
  }

  // ...
}
