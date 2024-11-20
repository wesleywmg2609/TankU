import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tanku/auth/auth.dart';
import 'package:tanku/widgets/my_button.dart';
import 'package:tanku/widgets/my_confetti.dart';
import 'package:tanku/widgets/my_hyperlink.dart';
import 'package:tanku/widgets/my_icon.dart';
import 'package:tanku/widgets/my_svg_icon.dart';
import 'package:tanku/widgets/my_text.dart';
import 'package:tanku/widgets/my_text_field.dart';
import 'package:tanku/helper/functions.dart';
import 'package:tanku/screens/main_page.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _confettiController = ConfettiController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPwController = TextEditingController();
  bool _isConfettiPlaying = false;

  @override
  void dispose() {
    _confettiController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPwController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      displayMessageToUser('Please fill in all fields.', context);
      return;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      displayMessageToUser('Please enter a valid email address.', context);
      return;
    } else if (password.length < 6) {
      displayMessageToUser('Password too short.', context);
      return;
    } else if (password != confirmPassword) {
      displayMessageToUser('Passwords don\'t match.', context);
      return;
    }

    showLoadingDialog(context);

    User? user = await registerWithEmailPassword(email, password);
    Navigator.pop(context);

    logCurrentUser();

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage(user: user)),
      );
    } else {
      displayMessageToUser('Registration failed. Please try again.', context);
    }
  }

  void toggleConfetti() {
  setState(() {
    if (_isConfettiPlaying) {
      _confettiController.stop();
      _isConfettiPlaying = false;
    } else {
      _confettiController.play();
      _isConfettiPlaying = true;
    }
  });
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
                                onPressed: toggleConfetti,
                                resetAfterPress: false,
                                isPressed: _isConfettiPlaying,
                                child: const MySvgIcon(filepath: 'assets/tanku_logo.svg', size: 150)
                              ),
                            ],
                          ),
                        ),
                        MyTextField(
                          controller: _emailController, 
                          icon: const MyIcon(icon: Icons.mail), 
                          labelText: 'Email',
                          ),
                        const SizedBox(height: 15),
                        MyTextField( 
                            controller: _passwordController, 
                            icon: const MyIcon(icon: Icons.key), labelText: 'Password', 
                            isPassword: true,
                          ),
                        const SizedBox(height: 15),
                        MyTextField(
                          controller: _confirmPwController, 
                          icon: const MyIcon(icon: Icons.key),
                          labelText: 'Confirm Password', 
                          isPassword:  true,
                        ),
                        const SizedBox(height: 40),
                        MyButton(
                          onPressed: _register,
                          child: const MyText( text: 'Register', 
                            isBold: true,
                            letterSpacing: 2.0,
                            size: 16,
                          ), 
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyHyperlink(text:  
                                    'Already have an account?', onTap: () {}),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: widget.onTap,
                                  child: const MyText( text: 'Login Here',
                                    isBold: true,
                                    letterSpacing: 2.0,
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          MyConfetti(controller: _confettiController),
        ],
      ),
    );
  }
}
