// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:lazyload/Theme/app_button_style.dart';
import 'package:lazyload/widgets/auth/auth_model.dart';
import 'package:lazyload/widgets/auth/main_screen/main_screen_widget.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Login to your account",
        ),
        backgroundColor: Color.fromRGBO(3, 37, 65, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            _HeaderWidget(),
            _FormWidget(),
          ],
        ),
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontSize: 16, color: Colors.black);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "In order to use the editing and rating capabilities of TMDb, as well as get personal recommendations you will need to login to your account. If you do not have an account, registering for an account is free and simple. Click here to get started.",
            style: textStyle,
          ),
          SizedBox(
            height: 5,
          ),
          TextButton(
            style: AppButtonStyle.linkButton,
            onPressed: () {},
            child: Text("Registred"),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "If you signed up but didn't get your verification email, click here to have it resent.",
            style: textStyle,
          ),
          SizedBox(
            height: 5,
          ),
          TextButton(
            style: AppButtonStyle.linkButton,
            onPressed: () {},
            child: Text("Verification email"),
          ),
        ],
      ),
    );
  }
}
class _FormWidget extends StatelessWidget {
  const _FormWidget({ Key? key }) : super(key: key);

  @override
   Widget build(BuildContext context) {
     final model = AuthProvider.read(context)?.model;
    final textStyle = TextStyle(fontSize: 16, color: Colors.black);
    final TextFieldDecorator = const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(10),
        isCollapsed: true);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ErrorMessageWidget(),
        Text("Username", style: textStyle),
        TextField(
          controller: model?.loginTextController,
          decoration: TextFieldDecorator,
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          "Password",
          style: textStyle,
        ),
        TextField(
          controller: model?.passwordTextController,
          decoration: TextFieldDecorator,
          obscureText: true,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const _AuthButtonWidget(),
            SizedBox(
              width: 15,
            ),
            TextButton(
              onPressed: (){},
              style: AppButtonStyle.linkButton,
              child: Text("Reset password"),
            ),
          ],
        )
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({
    Key? key,
   
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    final model = AuthProvider.watch(context)?.model;
    const color = Color(0xFF01B4E4);
    final onPressed = model?.canStartAuth == true ? ( ) => model?.auth(context) : null;
    final child = model?.isAuthProgress == true ? const SizedBox(width: 15,height: 15, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Login');
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          color
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        textStyle: MaterialStateProperty.all(
          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 15, vertical: 1),
        ),
      ),
      child: child,
    );
  }
}
 class _ErrorMessageWidget extends StatelessWidget {
   const _ErrorMessageWidget({ Key? key }) : super(key: key);
 
   @override
   Widget build(BuildContext context) {
     final errorMessage = AuthProvider.watch(context)?.model.errorMessage;
     if(errorMessage == null) return const SizedBox.shrink();
     return Padding(
       padding: const EdgeInsets.only(bottom: 20),
       child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red, fontSize: 17),
            ),
     );
       
     
   }
 }