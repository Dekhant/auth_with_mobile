import 'package:authentication_with_bloc/home/views/home_main_view.dart';
import 'package:authentication_with_bloc/login/views/login_main_view.dart';
import 'package:authentication_with_bloc/phone_auth/bloc/phone_auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPhoneNumberView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginMainView()));
            },
          ),
          title: Text('Регистрация'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: _PhoneAuthViewBuilder(),
        ),
      ),
    );
  }
}

class _PhoneAuthViewBuilder extends StatelessWidget {
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _codeNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthBloc, PhoneAuthState>(
      listener: (previous, current) {
        if (current is ConfirmPasswordSuccess) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeMainView()));
        } else if (current is PhoneAuthCodeVerificationFailure) {
          _showSnackBarWithText(context: context, textValue: current.message);
        } else if (current is PhoneAuthError) {
          _showSnackBarWithText(
              context: context, textValue: 'Unexpected error occurred.');
        } else if (current is PhoneAuthNumberVerficationFailure) {
          _showSnackBarWithText(context: context, textValue: current.message);
        } else if (current is PhoneAuthNumberVerificationSuccess) {
          _showSnackBarWithText(
              context: context,
              textValue: 'SMS code is sent to your mobile number.');
        } else if (current is PhoneAuthCodeAutoRetrievalTimeoutComplete) {
          _showSnackBarWithText(
              context: context, textValue: 'Time out for auto retrieval');
        }
      },
      builder: (context, state) {
        if (state is PhoneAuthInitial) {
          return _phoneNumberSubmitWidget(context);
        } else if (state is PhoneAuthNumberVerificationSuccess) {
          return _codeVerificationWidget(context, state.verificationId);
        } else if (state is PhoneAuthNumberVerficationFailure) {
          return _phoneNumberSubmitWidget(context);
        } else if (state is PhoneAuthCodeVerificationFailure) {
          return _codeVerificationWidget(
            context,
            state.verificationId,
          );
        } else if (state is PhoneAuthLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PhoneAuthCodeVerificationSuccess) {
          return _passwordVerificationWidget(context);
        }
        return Container();
      },
    );
  }

  Widget _phoneNumberSubmitWidget(context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'ФИО'),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Email'),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: _countryCodeController,
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: '+',
                        border: OutlineInputBorder(),
                        labelText: 'Код',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 270,
                    child: TextField(
                      controller: _phoneNumberController,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Телефон',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => _verifyPhoneNumber(context),
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.redAccent,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Получить код подтверждения',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _codeVerificationWidget(context, verificationId) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _codeNumberController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
              labelText: 'Код из SMS',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        TextButton(
          onPressed: () =>
              _verifySMS(
                context,
                verificationId,
              ),
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.redAccent,
          ),
          child: Text('Подвтердить'),
        )
      ],
    );
  }

  Widget _passwordVerificationWidget(context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Пароль',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Повторите пароль',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        TextButton(
          onPressed: () => _verifyPassword(context),
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.redAccent,
          ),
          child: Text('Зарегестрироваться'),
        )
      ],
    );
  }

  void _verifyPhoneNumber(BuildContext context) {
    BlocProvider.of<PhoneAuthBloc>(context).add(PhoneAuthNumberVerified(
        phoneNumber:
        '\+' + _countryCodeController.text + _phoneNumberController.text));
  }

  void _verifySMS(BuildContext context, String verificationCode) {
    BlocProvider.of<PhoneAuthBloc>(context).add(PhoneAuthCodeVerified(
        verificationId: verificationCode, smsCode: _codeNumberController.text));
  }

  void _verifyPassword(BuildContext context) {
    if (_passwordController.value.text !=
        _confirmPasswordController.value.text) {
      _showSnackBarWithText(context: context, textValue: 'Пароли не совпадают');
    } else {
      BlocProvider.of<PhoneAuthBloc>(context).add(PasswordConfirmed(
        email: _emailController.value.text,
        password: _passwordController.value.text,
        name: _nameController.value.text,
        phoneNumber: '127354987235',
      ));
    }
  }

  void _showSnackBarWithText(
      {required BuildContext context, required String textValue}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(textValue)));
  }
}
