import 'package:flutter/material.dart';
import './info.dart';
import './sign_in.dart';

class AppRouter {


  static Route<dynamic> generateRoute(RouteSettings settings) {
   

    switch (settings.name) {
      case '/main':
        final args = settings.arguments as Map<String, dynamic>;
        final String username = args['username'];
        final bool isLoggedIn = args['isLoggedIn'];
        return MaterialPageRoute(builder: (_) => Info(username: username, isLoggedIn: isLoggedIn));
      case '/sign_in':
        return MaterialPageRoute(builder: (_) => SignInScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

class CheckLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check login state here
    bool isLoggedIn = false; // Replace with your login state check

    if (isLoggedIn) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/main'));
    } else {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/sign_in'));
    }

    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}