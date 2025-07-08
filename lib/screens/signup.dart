import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _confirmC = TextEditingController();
  bool _obscure = true;
  bool _agree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Stack(
          children: [
            // Top pink bubbles
            Positioned(
              top: -100,
              right: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFEA3C79).withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: -40,
              left: -80,
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Color(0xFFEA3C79),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Bottom pink wave
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: _BottomWave(),
                child: Container(
                  height: 180,
                  color: const Color(0xFFEA3C79),
                ),
              ),
            ),

            // Form content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('Hello! let’s join with us',
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 32),

                      // Email
                      TextFormField(
                        controller: _emailC,
                        validator: (v) =>
                        (v != null && v.contains('@')) ? null : 'Invalid email',
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: const Icon(Icons.email, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _passC,
                        obscureText: _obscure,
                        validator: (v) =>
                        (v != null && v.length >= 6) ? null : 'Min 6 chars',
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      TextFormField(
                        controller: _confirmC,
                        obscureText: _obscure,
                        validator: (v) =>
                        (v == _passC.text) ? null : 'Passwords differ',
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Agree checkbox
                      Row(children: [
                        Checkbox(
                          value: _agree,
                          onChanged: (v) => setState(() => _agree = v!),
                          activeColor: const Color(0xFFEA3C79),
                        ),
                        const Expanded(child: Text('I agree with privacy policy'))
                      ]),
                      const SizedBox(height: 24),

                      // SIGN UP button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _agree && state is! AuthLoading
                                  ? () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    SignUpRequested(
                                      _emailC.text.trim(),
                                      _passC.text.trim(),
                                    ),
                                  );
                                }
                              }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                    color: Color(0xFFEA3C79), width: 2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              child: state is AuthLoading
                                  ? const CircularProgressIndicator(
                                  color: Color(0xFFEA3C79))
                                  : const Text(
                                'SIGN UP',
                                style: TextStyle(
                                    color: Color(0xFFEA3C79), fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),

                      const Spacer(),
                      Center(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 24),
                            child: Text(
                              'You already have an account? Sign In',
                              style: TextStyle(
                                  color: Colors.black87,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomWave extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final p = Path();
    p.lineTo(0, 40);
    p.quadraticBezierTo(size.width * .5, 0, size.width, 40);
    p.lineTo(size.width, size.height);
    p.lineTo(0, size.height);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}
