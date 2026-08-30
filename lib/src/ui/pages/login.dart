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
                                context.pushReplacement('/welcome');
                                log(_emailController.text.trim());
                              }
                            },
                            child: const Text("submit"),
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
}