import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Loading...', style: TextStyle(fontSize: 20,),),
            Divider(indent: 10,),           
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
