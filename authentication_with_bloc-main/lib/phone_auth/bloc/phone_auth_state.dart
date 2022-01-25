part of 'phone_auth_bloc.dart';

abstract class PhoneAuthState extends Equatable {
  const PhoneAuthState();

  @override
  List<Object?> get props => [];
}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoading extends PhoneAuthState {}

class PhoneAuthError extends PhoneAuthState {}

class PhoneAuthNumberVerficationFailure extends PhoneAuthState {
  final String message;
  PhoneAuthNumberVerficationFailure(this.message);
  @override
  List<Object> get props => [props];
}

class PhoneAuthNumberVerificationSuccess extends PhoneAuthState {
  final String verificationId;
  PhoneAuthNumberVerificationSuccess({
    required this.verificationId,
  });
  @override
  List<Object> get props => [verificationId];
}

class PhoneAuthCodeSentSuccess extends PhoneAuthState {
  final String verificationId;
  PhoneAuthCodeSentSuccess({
    required this.verificationId,
  });
  @override
  List<Object> get props => [verificationId];
}

class PhoneAuthCodeVerificationFailure extends PhoneAuthState {
  final String message;
  final String verificationId;

  PhoneAuthCodeVerificationFailure(this.message, this.verificationId);

  @override
  List<Object> get props => [message];
}

class PhoneAuthCodeVerificationSuccess extends PhoneAuthState {
  final String? uid;

  PhoneAuthCodeVerificationSuccess({
    required this.uid,
  });

  @override
  List<Object?> get props => [uid];
}

class ConfirmPasswordSuccess extends PhoneAuthState {
  final UserModel user;

  ConfirmPasswordSuccess({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}

class ConfirmPasswordFailure extends PhoneAuthState {
  final String message;

  ConfirmPasswordFailure(this.message);

  @override
  List<Object> get props => [message];
}

class PhoneAuthCodeAutoRetrievalTimeoutComplete extends PhoneAuthState {
  final String verificationId;

  PhoneAuthCodeAutoRetrievalTimeoutComplete(this.verificationId);
  @override
  List<Object> get props => [verificationId];
}
