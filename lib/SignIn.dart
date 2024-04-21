import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add login logic here
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Connect',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink, // Modify the color of the "Connect" button here
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Add logic for the "Forgot Password?" link here
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(fontSize: 16, color: Colors.blue), // Modify the text color here
              ),
            ),
          ],
        ),
      ),
    );
  }
}