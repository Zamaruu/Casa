import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/models/enums/e_snackbar_type.dart';
import 'package:casa/src/core/utils/snackbar.util.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRoute extends ConsumerStatefulWidget {
  const AuthRoute({super.key});

  @override
  ConsumerState createState() => _AuthRouteState();
}

class _AuthRouteState extends ConsumerState<AuthRoute> {
  late final GlobalKey<FormState> formKey;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  // region Methods

  void performLoginWithEmailAndPassword(WidgetRef ref) async {
    if (formKey.currentState!.validate()) {
      final email = emailController.text;
      final password = passwordController.text;

      // Perform login with email and password
      final loginResponse = await ref.read(authProvider.notifier).login(email, password);

      if (mounted) {
        if (loginResponse.isError) {
          CasaSnackbars.showDefaultSnackbar(
            message: loginResponse.message ?? 'An error occurred during login.',
            context: context,
            type: ESnackbarType.error,
          );
        } else {
          CasaSnackbars.showDefaultSnackbar(
            message: 'Login successful!',
            context: context,
            type: ESnackbarType.success,
          );
        }
      }
    }
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 350, minHeight: 350, maxHeight: 400),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CasaText(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),

                    const Spacer(),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () => performLoginWithEmailAndPassword(ref),
                          child: const Text('Anmelden'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Divider(height: 1, thickness: 2),
                              CasaText("ODER"),
                              Divider(height: 1, thickness: 2),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          onPressed: null,
                          child: const Text('OAuth'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
