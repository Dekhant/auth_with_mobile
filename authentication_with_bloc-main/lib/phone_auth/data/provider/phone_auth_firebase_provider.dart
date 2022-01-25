import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthFirebaseProvider {
  final FirebaseAuth _firebaseAuth;

  PhoneAuthFirebaseProvider({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  Future<void> verifyPhoneNumber({
    required String mobileNumber,
    required onVerificationCompleted,
    required onVerificationFailed,
    required onCodeSent,
    required onCodeAutoRetrievalTimeOut,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: mobileNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeOut,
      timeout: Duration(seconds: 60),
    );
  }

  Future<User?> loginWithSMSVerificationCode(
      {required String verificationId,
      required String smsVerificationCode}) async {
    final AuthCredential credential = _getAuthCredentialFromVerificationCode(
        verificationId: verificationId, verificationCode: smsVerificationCode);
    return await authenticationWithCredential(credential: credential);
  }

  Future<User?> authenticationWithCredential(
      {required AuthCredential credential}) async {
    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  AuthCredential _getAuthCredentialFromVerificationCode(
      {required String verificationId, required String verificationCode}) {
    return PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: verificationCode,
    );
  }

  Future<void> addUserInfoInCollection({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) {
    return FirebaseFirestore.instance
        .collection('users')
        .add({
          'name': name,
          'email': email,
          'password': password,
          'phoneNumber' : phoneNumber,
          'uid': _firebaseAuth.currentUser?.uid,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
