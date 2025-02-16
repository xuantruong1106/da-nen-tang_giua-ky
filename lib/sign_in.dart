import 'package:flutter/material.dart';
import './connect_db.dart';

class SignInScreen extends StatefulWidget {
  final db = DatabaseConnection();

  SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signIn() async {
    try {
      await widget.db.connect();
      final result = await widget.db.executeQuery(
        'SELECT check_account(@email, @password);',
        substitutionValues: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid username or password'),
          ),
        );
      }

      // Assuming the login is successful if the query returns a result
      Navigator.pushReplacementNamed(
        // ignore: use_build_context_synchronously
        context,
        '/main',
        arguments: {
          'username': result[0][0].toString(),
          'isLoggedIn': true,
        },
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('signIn() Error: $e'),
        ),
      );
    }finally{
      await widget.db.connection?.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: signIn,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}