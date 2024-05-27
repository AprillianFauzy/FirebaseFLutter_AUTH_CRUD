import 'package:belajarfirebase/AUTH/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> loginUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Login successful');

      Navigator.pushNamed(context, '/crud');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('The user does not exist');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user');
      } else if (e.code == 'invalid-email') {
        print('The email address is not valid');
      } else {
        print('Error: ${e.code}'); // Print the error code for debugging
      }
    } catch (e) {
      print('An unknown error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Auth(
      child: Column(
        children: [
          Text(
            'Login',
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
                  loginUser(emailController.text, passwordController.text),
              child: Text('Login'))
        ],
      ),
    );
  }
}
