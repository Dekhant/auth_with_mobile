import 'package:authentication_with_bloc/phone_auth/data/models/phone_auth_model.dart';
import 'package:authentication_with_bloc/phone_auth/data/models/user_model.dart';
import 'package:authentication_with_bloc/phone_auth/data/provider/phone_auth_firebase_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthRepository {
  final PhoneAuthFirebaseProvider _phoneAuthFirebaseProvider;

  PhoneAuthRepository({
    required PhoneAuthFirebaseProvider phoneAuthFirebaseProvider,
  }) : _phoneAuthFirebaseProvider = phoneAuthFirebaseProvider;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required onVerificationCompleted,
    required onVerificationFailed,
    required onCodeSent,
    required onCodeAutoRetrievalTimeOut,
  }) async {
    await _phoneAuthFirebaseProvider.verifyPhoneNumber(
        onCodeAutoRetrievalTimeOut: onCodeAutoRetrievalTimeOut,
        onCodeSent: onCodeSent,
        onVerificationFailed: onVerificationFailed,
        onVerificationCompleted: onVerificationCompleted,
        mobileNumber: phoneNumber);
  }

  Future<PhoneAuthModel> verifySMSCode({
    required String smsCode,
    required String verificationId,
  }) async {
    final User? user =
        await _phoneAuthFirebaseProvider.loginWithSMSVerificationCode(
            verificationId: verificationId, smsVerificationCode: smsCode);
    if (user != null) {
      return PhoneAuthModel(
        phoneAuthModelState: PhoneAuthModelState.verified,
        uid: user.uid,
      );
    } else {
      return PhoneAuthModel(phoneAuthModelState: PhoneAuthModelState.error);
    }
  }

  Future<UserModel> addUserToCollection({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    var document = _phoneAuthFirebaseProvider.addUserInfoInCollection(
      email: email,
      password: password,
      name: name,
      phoneNumber: phoneNumber,
    );
    return UserModel(
      email: email,
      name: name,
      password: password,
      phoneNumber: phoneNumber,
      uid: FirebaseAuth.instance.currentUser!.uid,
    );
  }

  Future<PhoneAuthModel> verifyWithCredential({
    required AuthCredential credential,
  }) async {
    User? user = await _phoneAuthFirebaseProvider.authenticationWithCredential(
      credential: credential,
    );
    if (user != null) {
      return PhoneAuthModel(
        phoneAuthModelState: PhoneAuthModelState.verified,
        uid: user.uid,
      );
    } else {
      return PhoneAuthModel(phoneAuthModelState: PhoneAuthModelState.error);
    }
  }
}
