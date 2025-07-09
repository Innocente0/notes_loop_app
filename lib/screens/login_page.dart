// lib/screens/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _obscure = true, _remember = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (ctx, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(ctx, '/home');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(ctx)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Stack(children: [
          // Top bubble
          Positioned(
            top: -80, right: -80,
            child: Container(
              width: 200, height: 200,
              decoration: const BoxDecoration(
                  color: Color(0xFFEA3C79), shape: BoxShape.circle),
            ),
          ),
          // Bottom wave
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: _WaveClipper(),
              child: Container(
                height: 200, color: const Color(0xFFEA3C79),
              ),
            ),
          ),
          // Form
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Text('Welcome Back',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    const SizedBox(height: 4),
                    const Text('Hey! Good to see you again',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 32),
                    // Email
                    TextFormField(
                      controller: _emailC,
                      validator: (v) => v!.contains('@') ? null : 'Invalid',
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
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
                      validator: (v) => v!.length >= 6 ? null : 'Min 6 chars',
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Remember / Forgot
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Checkbox(
                            value: _remember,
                            activeColor: const Color(0xFFEA3C79),
                            onChanged: (v) =>
                                setState(() => _remember = v!),
                          ),
                          const Text('Remember me')
                        ]),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // SIGN IN
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (ctx, state) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                              if (_formKey.currentState!.validate()) {
                                ctx.read<AuthBloc>().add(
                                  LoginRequested(
                                    _emailC.text.trim(),
                                    _passC.text.trim(),
                                  ),
                                );
                              }
                            },
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
                              'SIGN IN',
                              style: TextStyle(
                                  color: Color(0xFFEA3C79),
                                  fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/signup'),
                        child: const Text(
                          "Don't have an account? Sign Up",
                          style: TextStyle(
                              color: Colors.black87,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final p = Path();
    p.lineTo(0, size.height - 60);
    p.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 60);
    p.lineTo(size.width, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> old) => false;
}
