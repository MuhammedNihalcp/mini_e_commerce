import 'package:flutter/material.dart';
import 'package:mini_commerce/controller/auth_provider.dart';
import 'package:provider/provider.dart';
import 'product_list_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;

  // Future<void> _signIn(BuildContext context) async {
  //   final auth = Provider.of<AuthProvider>(context, listen: false);
  //   setState(() => _isLoading = true);
  //   try {
  //     await auth.signInEmail(_emailCtrl.text.trim(), _passCtrl.text.trim());
  //     // Navigator.pushReplacement(
  //     //   context,
  //     //   MaterialPageRoute(builder: (_) => ProductListPage()),
  //     // );
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Error: $e")));
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  // Future<void> _signInGoogle(BuildContext context) async {
  //   final auth = Provider.of<AuthProvider>(context, listen: false);
  //   try {
  //     await auth.signInWithGoogle();
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => ProductListPage()),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Google Sign-In failed: $e")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_bag_rounded,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),

                // Card with inputs
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailCtrl,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passCtrl,
                          obscureText: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.indigo,
                                ),
                                onPressed: () =>
                                    Provider.of<AuthProvider>(
                                      context,
                                      listen: false,
                                    ).signInEmail(
                                      _emailCtrl.text.trim(),
                                      _passCtrl.text.trim(),
                                    ),
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                        const SizedBox(height: 16),
                        // Google Login Button
                        ElevatedButton.icon(
                          icon: const Icon(Icons.g_mobiledata, size: 34),
                          label: const Text("Sign in with Google"),
                          onPressed: () async {
                            Provider.of<AuthProvider>(
                              context,
                              listen: false,
                            ).signInWithGoogle();
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Navigate to sign-up page
                  },
                  child: const Text(
                    "Don’t have an account? Sign Up",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
