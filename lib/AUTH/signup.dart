import 'package:belajarfirebase/AUTH/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> registerUser(String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Handle successful registration (e.g., display a confirmation message)
      print('User created: ${userCredential.user?.uid}');
      Navigator.pushNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The email address is already in use.');
      } else {
        print(e.code); // Print the error code for debugging
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Auth(
      child: Column(
        children: [
          Text(
            'Sign Up',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email cannot be empty';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password cannot be empty';
              }
              return null;
            },
            obscureText: true,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () =>
                  registerUser(emailController.text, passwordController.text),
              child: Text('Sign Up'))
        ],
      ),
    );
  }
}
