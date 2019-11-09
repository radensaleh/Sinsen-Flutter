import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
  };
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Sinsen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          fontFamily: 'nyoba_font'
      ),
      home: Scaffold(
      
        body: LoginPage(),
       
      
      ),
    );
  }
}