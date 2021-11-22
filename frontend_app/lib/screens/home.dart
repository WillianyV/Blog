import 'package:flutter/material.dart';
import 'package:frontend_app/screens/login.dart';
import 'package:frontend_app/services/user_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
            child: GestureDetector(
                onTap: () {
                  logout().then((value) => {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Login()),
                            (route) => false)
                      });
                },
                child: Text('Press to Logout'))),
      ),
    );
  }
}
