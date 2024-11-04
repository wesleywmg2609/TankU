import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tankyou/auth/auth.dart';
import 'package:tankyou/components/my_button.dart';
import 'package:tankyou/components/my_icon.dart';
import 'package:tankyou/components/my_svg_icon.dart';
import 'package:tankyou/components/my_text.dart';
import 'package:tankyou/helper/functions.dart';
import 'package:tankyou/helper/widgets.dart';
import 'package:tankyou/views/main_page.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _confettiController = ConfettiController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _isConfettiPlaying = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    logCurrentUser();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

Future<void> _login() async {
  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    displayMessageToUser('Please fill in all fields.', context);
    return;
  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
    displayMessageToUser('Please enter a valid email address.', context);
    return;
  }

  showLoadingDialog(context);

  try {
    User? user = await loginWithEmailPassword(email, password);
    Navigator.pop(context);
    logCurrentUser();

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage(user: user)),
      );
    } else {
      displayMessageToUser('Authentication failed. Please try again.', context);
    }
  } catch (e) {
    Navigator.pop(context);
    displayMessageToUser('An error occurred. Please try again.', context);
  }
}

  Future<void> _googleSignIn() async {
    try {
    User? user = await signInWithGoogle();
    logCurrentUser();

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage(user: user,)),
      );
    } else {
      displayMessageToUser('Authentication failed. Please try again.', context);
    }
  } catch (e) {
    displayMessageToUser('An error occurred. Please try again.', context);
  }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyButton(  
                                onPressed: () => toggleConfetti( _confettiController, _isConfettiPlaying),
                                resetAfterPress: false,
                                child: const MySvgIcon(filepath: 'assets/tankyou_logo.svg', size: 150)
                              ),
                            ],
                          ),
                        ),
                        buildTextField( 
                          _emailController, 
                          const MyIcon(icon: Icons.mail), 
                          'Email',
                          ),
                        const SizedBox(height: 15),
                        buildTextField(
                          _passwordController, 
                          const MyIcon(icon: Icons.key),
                          'Password', 
                          isPassword: true, 
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: buildHyperlink(
                              context, 
                                'Forgot my password?', () {}),
                          ),
                        ),
                        MyButton(
                          onPressed: () => _login(),
                          child: const MyText( text: 'Login', 
                            isBold: true,
                            letterSpacing: 2.0,
                            size: 16,
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildHyperlink(
                                  context, 
                                    'Don\'t have an account?', () {}),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: widget.onTap,
                                  child: const MyText( text: 'Register Here',
                                    isBold: true,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 1,
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              child: MyText( text: 'Or continue with',
                                letterSpacing: 1.0,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyButton(
                                onPressed: _googleSignIn,
                                child: const MySvgIcon(filepath: 'assets/google_logo.svg')
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          createConfetti(_confettiController),
        ],
      ),
    );
  }
}
