import 'package:firebase_auth/firebase_auth.dart';
import '../user/userServices.dart';

class FirebaseAuthentication {

  final FirebaseAuth _auth = FirebaseAuth.instance;

// Sign up
  Future insertUser(String name, String email, String password, String phone, String type) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await UserServices().insertUser(userCredential.user!.uid, name, email, phone, type);
      return userCredential.user;
    }
    catch (err) {
      print(err.toString());
    }
  }

// Sign in
 Future login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    }
    catch (err) {
      print(err.toString());
    }
 }
// logout
Future logout() async {
    try {
      return _auth.signOut();
    }
    catch (err) {
      print(err.toString());
      return null;
    }
}

  Future deleteAndLogout() async {
    try {
      return _auth.currentUser?.delete();
    }
    catch (err) {
      print(err.toString());
      return null;
    }
  }

Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    }
    catch (err) {
      print(err.toString());
      return "err:"+err.toString();
    }
}

}