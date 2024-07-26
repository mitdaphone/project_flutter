import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart'; // Import the main.dart to navigate to HomeScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('https://store.annymarket.shop/public/api/login_user'),
      body: {
        'user_name': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    var message = 'Login failed';
    if (response.statusCode == 200) {
      // Navigate to HomeScreen on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      return;
    } else if (response.statusCode == 401) {
      message = 'Incorrect Password';
    } else if (response.statusCode == 404) {
      message = 'Incorrect User Name';
    } else {
      // General failure message
      var responseBody = jsonDecode(response.body);
      if (responseBody['message'] != null) {
        message = responseBody['message'];
      }
    }

    // Show an error message on unsuccessful login
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Failed'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[400]!, Colors.purple[700]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(flex: 2),
                CircleAvatar(
                  radius: 40.0,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(
                    Icons.computer,
                    size: 50.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  '084.Computer Management System',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(flex: 2),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.person, color: Colors.purple[700]),
                          labelText: 'ຊື່ຜູ້ໃຊ້',
                          labelStyle: TextStyle(color: Colors.purple[700]),
                          border: InputBorder.none,
                        ),
                      ),
                      Divider(color: Colors.purple[700]),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock, color: Colors.purple[700]),
                          labelText: 'ລະຫັດຜ່ານ',
                          labelStyle: TextStyle(color: Colors.purple[700]),
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                      ),
                      Divider(color: Colors.purple[700]),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'ເຂົ້າສູ່ລະບົບ',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 10.0),
                            Icon(Icons.arrow_forward, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
