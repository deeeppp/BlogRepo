import 'package:flutter/material.dart';
import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand,
        children: [
          Image.asset('assets/blog_main.jpg', fit: BoxFit.cover,),
          Container(color: Colors.black.withOpacity(0.5),),
          Center(
            child: Text('Welcome to My Blog',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

