import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

enum AuthFormMode {
  Login,
  Signup,
}

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _isLoading = false;
  AuthFormMode _authFormMode = AuthFormMode.Login;
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _formData = {
    'email': '',
    'password': '',
  };

  var _passwordEditingController = TextEditingController();

  Future<void> submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    print("correct!!");
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    final String email = _formData['email'];
    final String password = _formData['password'];
    try {
      if (_authFormMode == AuthFormMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(email, password);
      } else {
        await Provider.of<Auth>(context, listen: false).signup(email, password);
      }
    } catch (error) {
      showError(context, error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showError(context, error) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Error"),
        content: Text(error),
        actions: <Widget>[
          RaisedButton(
            child: Text("OK"),
            textColor: Theme.of(context).primaryTextTheme.button.color,
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void switchAuthFormMode() {
    if (_authFormMode == AuthFormMode.Login) {
      setState(() {
        _authFormMode = AuthFormMode.Signup;
      });
    } else {
      setState(() {
        _authFormMode = AuthFormMode.Login;
      });
    }
  }

  @override
  void dispose() {
    _passwordEditingController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 5.0,
      child: Container(
        width: deviceSize.width * 0.75,
        height: _authFormMode == AuthFormMode.Login ? 260 : 320,
        constraints: BoxConstraints(
            minHeight: _authFormMode == AuthFormMode.Login ? 260 : 320),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Enter a valid e-mail address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _formData['email'] = value;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  controller: _passwordEditingController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password must contain at least 6 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _formData['password'] = value;
                  },
                ),
                if (_authFormMode == AuthFormMode.Signup)
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Confirm password'),
                    validator: (value) {
                      if (_passwordEditingController.text != value) {
                        return 'Not equal to password';
                      }
                      return null;
                    },
                  ),
                SizedBox(
                  height: 10,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  AuthButtons(
                    authFormMode: _authFormMode,
                    submit: submit,
                    switchAuthFormMode: switchAuthFormMode,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthButtons extends StatelessWidget {
  final Function submit;
  final Function switchAuthFormMode;

  const AuthButtons(
      {Key key, this.authFormMode, this.submit, this.switchAuthFormMode})
      : super(key: key);

  final AuthFormMode authFormMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
          child: Text(authFormMode == AuthFormMode.Login ? "LOGIN" : "SIGN UP"),
          onPressed: submit,
          color: Theme.of(context).primaryColor,
          textColor: Theme.of(context).primaryTextTheme.button.color,
        ),
        FlatButton(
          child: Text(
              'Click here to ${authFormMode == AuthFormMode.Login ? 'SIGN UP' : 'LOGIN'}'),
          onPressed: switchAuthFormMode,
          textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
