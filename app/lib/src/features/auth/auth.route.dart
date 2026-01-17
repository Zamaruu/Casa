import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthRoute extends StatelessWidget {
  const AuthRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 350, minHeight: 350, maxHeight: 400),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Login'),

                  const SizedBox(height: 16),

                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 16),

                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),

                  const Spacer(),

                  ElevatedButton(
                    onPressed: () {
                      context.replace('/home');
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
