part of 'phone_auth_bloc.dart';

abstract class PhoneAuthEvent extends Equatable {
  const PhoneAuthEvent();

  @override
  List<Object?> get props => [];
}

class PhoneAuthNumberVerified extends PhoneAuthEvent {
  final String phoneNumber;
  PhoneAuthNumberVerified({
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [phoneNumber];
}

class PhoneAuthCodeVerified extends PhoneAuthEvent {
  final String verificationId;
  final String smsCode;
  PhoneAuthCodeVerified({
    required this.verificationId,
    required this.smsCode,
  });

  @override
  List<Object> get props => [smsCode];
}

class PasswordConfirmed extends PhoneAuthEvent {
  final String password;
  final String email;
  final String name;
  final String phoneNumber;
  PasswordConfirmed({
    required this.email,
    required this.name,
    required this.password,
    required this.phoneNumber
  });

  @override
  List<Object> get props => [phoneNumber];
}

class PhoneAuthCodeAutoRetrievalTimeout extends PhoneAuthEvent {
  final String verificationId;
  PhoneAuthCodeAutoRetrievalTimeout(this.verificationId);
  @override
  List<Object> get props => [verificationId];
}

class PhoneAuthCodeSent extends PhoneAuthEvent {
  final String verificationId;
  final int? token;
  PhoneAuthCodeSent({
    required this.verificationId,
    required this.token,
  });

  @override
  List<Object> get props => [verificationId];
}

class PhoneAuthVerificationFailed extends PhoneAuthEvent {
  final String message;

  PhoneAuthVerificationFailed(this.message);
  @override
  List<Object> get props => [message];
}

class PhoneAuthVerificationCompleted extends PhoneAuthEvent {
  final String? uid;
  PhoneAuthVerificationCompleted(this.uid);
  @override
  List<Object?> get props => [uid];
}
