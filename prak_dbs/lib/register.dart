import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'homescreen.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  void _signUp() async {
    setState(() => _loading = true);
    User? user = await AuthService().signUp(_email.text, _password.text);
    setState(() => _loading = false);

    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      _showError('Sign up failed.');
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
                'lib/aset/register.gif', 
                height: 300, 
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Silahkan daftarkan akun anda', 
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
              onPressed: _loading ? null : _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF48C2C6),
                foregroundColor: Colors.white,   
              ),
              child: _loading 
                ? CircularProgressIndicator() 
                : Text("Daftar"),
            ),


            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF48C2C6),  
              ),
              child: Text("Sudah punya akun? Masuk"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SignInScreen()), 
              ),
            )
          ],
        ),
      ),
    );
  }
}