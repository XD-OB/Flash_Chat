import 'package:flash_chat/components/rounded_button.dart';
import 'package:string_validator/string_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../constants.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final     _auth = FirebaseAuth.instance;
  final     _controllerE = TextEditingController();
  final     _controllerP = TextEditingController();
  bool      _showSpinner = false;
  bool      _vPassword = false;
  bool      _error = false;
  String    email;
  String    password;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
              SizedBox(
                height: 45.0,
              ),
              TextField(
                controller: _controllerE,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  if (_error)
                    setState(() => _error = false);
                  email = value;
                },
                decoration: kTextFieldDecoration,
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _controllerP,
                textAlign: TextAlign.center,
                obscureText: !_vPassword,
                onChanged: (value) {
                  if (_error)
                    setState(() => _error = false);
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password.',
                ),
              ),
              Visibility(
                visible: _error,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Wrong Password or Email !',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.redAccent[200],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Icon(
                  Icons.remove_red_eye,
                  color: Colors.grey,
                ),
                onTap: () => setState(() => _vPassword = !_vPassword),
              ),
              SizedBox(
                height: 5.0,
              ),
            RoundedButton(
              text: 'Register',
              color: Colors.blueAccent,
              onPressed: () async {
                setState(() => _showSpinner = true);
                _controllerE.clear();
                _controllerP.clear();
                if (!isEmail(email) || password == null) {
                  setState(()=> _error = true);
                  return ;
                }
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  if (newUser != null) {
                    Navigator.pushNamed(
                        context,
                        ChatScreen.id,
                    );
                  } else {
                    print('already exist !');
                  }
                } catch(e) {
                  print(e);
                }
                setState(() => _showSpinner = false);
              },
            ),
          ],
            ),
        ),
      ),
    );
  }
}
