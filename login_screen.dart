import 'package:flutter/material.dart';
import 'sign_up_screen.dart';
import 'package:buildtrackapp/routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  String? _loginRole = "Employee"; // default role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/buildtrackapp.jpg',
                height: 250,
                width: 250,
              ),
              const SizedBox(height: 10),

              // Title
              const Text(
                "Welcome to the World of BuildTrack!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 40),

              // Email Field
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Password Field
              TextFormField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Login Role Selection
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text("Employee Login"),
                    value: "Employee",
                    groupValue: _loginRole,
                    onChanged: (value) {
                      setState(() {
                        _loginRole = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("Worker Login"),
                    value: "Worker",
                    groupValue: _loginRole,
                    onChanged: (value) {
                      setState(() {
                        _loginRole = value;
                      });
                    },
                  ),
                  if (_loginRole == null)
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Please select a role",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              // Forgot Password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.forgotPassword);
                  },
                  child: const Text("Forgot Password?"),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_loginRole == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select a login role"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // ✅ Only allow Employer side for now
                      if (_loginRole == "Employee") {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.employerDashboard,
                        );
                      } else {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.workerDashboard,
                        );
                      }
                    }
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Sign Up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
