import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'homescreen.dart';
import 'register.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  void _signIn() async {
    setState(() => _loading = true);
    User? user = await AuthService().signIn(_email.text, _password.text);
    setState(() => _loading = false);

    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      _showError('Sign in failed.');
    }
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(title: Text("Error"), content: Text(msg), actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [

                        Text(
              'Skedulo',
              style: TextStyle(
                fontSize: 36, 
                fontWeight: FontWeight.bold,
                color: Color(0xFF48C2C6),
              ),
            ),
            Center(
              child: Image.asset(
                'lib/aset/login3.gif',
                height: 300, 
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Masukan email dan password anda',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.normal, 
                color: Color(0xFF000000), 
              ),
            ),
            SizedBox(height: 20),
            
            TextField(
              controller: _email,
              decoration: InputDecoration(
                labelText: 'Email',
                  labelStyle: TextStyle(
                  color: Color.fromARGB(255, 70, 70, 70),
                  fontWeight: FontWeight.normal,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF48C2C6)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF48C2C6)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF48C2C6)),
                ),
              ),
            ),

            SizedBox(height: 10), 
            TextField(
              controller: _password,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 70, 70, 70),
                  fontWeight: FontWeight.normal, 
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF48C2C6)), 
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF48C2C6)), 
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF48C2C6)),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _signIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF48C2C6),
                foregroundColor: Colors.white,   
              ),
              child: _loading 
                ? CircularProgressIndicator() 
                : Text("Masuk"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF48C2C6),  
              ),
              child: Text("Tidak punya akun? Daftar"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SignUpScreen()),
              ),
            )
          ],
        ),
      ),
    );
  }
}