import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

//TODO regexp

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListenableBuilder(
            listenable: .merge([_emailController, _passwordController]),
            builder: (context, child) {
              return AutofillGroup(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const .all(24.0),
                      child: Column(
                        mainAxisSize: .max,
                        mainAxisAlignment: .center,
                        crossAxisAlignment: .center,
                        children: [
                          const Text("LOGO"),
                          const SizedBox(height: 16.0),
                          Text(
                            key: Key("login"),
                            "Login",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            key: Key("email"),
                            controller: _emailController,
                            textInputAction: .next,
                            keyboardType: .emailAddress,
                            autofillHints: [
                              AutofillHints.email,
                              AutofillHints.username,
                            ],
                            decoration: const .new(
                              label: Text("Email"),
                              hintText: "example@mail.com",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (value) {
                              //if (value!.trim().isEmpty){}
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            key: Key("password"),
                            controller: _passwordController,
                            textInputAction: .send,
                            keyboardType: .visiblePassword,
                            obscureText: _isPasswordVisible,
                            autofillHints: [AutofillHints.password],
                            decoration: .new(
                              label: const Text("Password"),
                              hintText: _isPasswordVisible
                                  ? 'Password'
                                  : "********",
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.key_outlined),
                              suffixIcon: _isPasswordVisible
                                  ? IconButton(
                                      icon: const Icon(Icons.visibility),
                                      onPressed: () {
                                        setState(
                                          () => _isPasswordVisible = false,
                                        );
                                      },
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.visibility_off),
                                      onPressed: () {
                                        setState(
                                          () => _isPasswordVisible = true,
                                        );
                                      },
                                    ),
                            ),
                            validator: (value) {
                              //if (value!.trim().isEmpty){}
                              return null;
                            },
                          ),
                          const SizedBox(height: 8.0),
                          RichText(
                            text: TextSpan(
                              text: "Forgot Password?",
                              style: const .new(
                                color: Colors.blue,
                                decoration: .underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  log("Forgot Password? CLICKED");
                                },
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          FilledButton(
                            key: Key("submit"),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(50.0),
                              shape: const LinearBorder(),
                            ),
                            onPressed: () async {
                              //GoRouter.of(context).pushReplacement('/wrapper');
                              //context.go('/dashboard');
                              if (_formKey.currentState!.validate()) {
                                //TODO

                                var res = await loadingDialog(
                                  context,
                                  'Signing in to the app...',
                                  () => _loginLogic(),
                                );

                                log('res = $res');

                                log(_emailController.text.trim());
                              }
                            },
                            child: const Text("LOGIN"),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            '- - - Or - - -',
                            style: .new(color: Colors.grey),
                          ),
                          const SizedBox(height: 16.0),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.go('/signup');
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50.0),
                              shape: const ContinuousRectangleBorder(),
                            ),
                            icon: const Icon(Icons.abc),
                            label: const Text("REGISTER USING EMAIL"),
                          ),
                          const SizedBox(height: 16.0),
                          OutlinedButton.icon(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              minimumSize: const .fromHeight(50.0),
                              shape: const ContinuousRectangleBorder(),
                            ),
                            icon: const Icon(Icons.abc),
                            label: const Text("LOGIN WITH GOOGLE"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginLogic() async {
    try {
      TextInput.finishAutofillContext();
      // Here we emulate signing ip logic
      // TODO: await Future.delayed(const .new(milliseconds: 500));
      if (mounted) context.pushReplacement('/welcome');

      // Just for testing
      //throw Exception('Error when logging to the app');
    } catch (e) {
      log('e = $e');

      rethrow;
    }
  }
}

//
//
//
//
//

Future<bool?> loadingDialog(
  BuildContext context,
  String message,
  Future<void> Function() callback,
) async {
  Future.microtask(() async {
    try {
      await callback();
    } catch (e) {
      if (context.mounted) {
        context.pop(false);

        // To display error message in a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
        );
      }
    }
  });

  var result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(message),
        content: Column(
          children: [
            Text("Please wait a moment..."),
            const SizedBox(height: 16.0),
            const CircularProgressIndicator(),
          ],
        ),
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: const EdgeInsets.all(16.0),
        scrollable: true,
        elevation: 2.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
      );
    },
  );

  //

  log('result = $result');
  return result;
}
