import 'package:flutter/material.dart';
import 'package:flutter_app/SignIn.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              Image.asset(
                'assets/7.png',
                width: 300,
                height: 400,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text(
                  'Create an account',
                  style: TextStyle(fontSize: 16, color: Colors.purple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}