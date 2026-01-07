import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/loginpage.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late double width;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? nameError,
      emailError,
      passwordError,
      confirmPasswordError,
      phoneError;
  bool visible = true;
  bool isLoading = false;
  late User user;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    if (width < 600) {
      width = width;
    } else {
      width = 600;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: width,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Image.asset('assets/images/logo_nodesc.png', scale: 0.8),
                const SizedBox(height: 20),

                // name text field
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Name',
                    errorText: nameError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // email text field
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    hintText: 'xxx@gmail.com',
                    errorText: emailError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // password textfield
                TextField(
                  controller: passwordController,
                  obscureText: visible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password',
                    errorText: passwordError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (visible) {
                          visible = false;
                        } else {
                          visible = true;
                        }
                        setState(() {});
                      },
                      icon: Icon(
                        visible ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // confirm password text field
                TextField(
                  controller: confirmPasswordController,
                  obscureText: visible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Confirm Password',
                    errorText: confirmPasswordError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (visible) {
                          visible = false;
                        } else {
                          visible = true;
                        }
                        setState(() {});
                      },
                      icon: Icon(
                        visible ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // phone text field
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    labelText: 'Phone',
                    hintText: '0123456789',
                    errorText: phoneError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // register button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
                  ),
                    onPressed: () {
                      registerValidation();
                    },
                    child: const Text('Register'),
                  ),
                ),
                const SizedBox(height: 20),

                // tap to login page
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Already have an account? Login here',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // validate all fields for register
  void registerValidation() {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    String phone = phoneController.text;

    setState(() {
      nameError = null;
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
      phoneError = null;
    });

    if (name.isEmpty) {
      setState(() {
        nameError = 'Please enter the field';
      });
      return;
    }
    if (email.isEmpty) {
      setState(() {
        emailError = 'Please enter the field';
      });
      return;
    }
    if (RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email) == false) {
      setState(() {
        emailError = 'Invalid email';
      });
      return;
    }
    if (password.isEmpty) {
      setState(() {
        passwordError = 'Please enter the field';
      });
      return;
    }
    if (password.length < 6) {
      setState(() {
        passwordError = 'Password must be at least 6 characters';
      });
      return;
    }
    if (confirmPassword.isEmpty) {
      setState(() {
        confirmPasswordError = 'Please enter the field';
      });
      return;
    }
    if (password != confirmPassword) {
      setState(() {
        confirmPasswordError = 'Passwords do not match';
      });
      return;
    }
    if (phone.isEmpty) {
      setState(() {
        phoneError = 'Please enter the field';
      });
      return;
    }
    if (phone.length < 10 || phone.length > 11) {
      setState(() {
        phoneError = 'Invalid phone number';
      });
      return;
    }

    registerUser(name, email, password, phone);
  }

  // register the user
  void registerUser(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    setState(() {
      isLoading = true;
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Registering...'),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );

    await http
        .post(
          Uri.parse('${MyConfig.server}/pawpal/server/api/register_user.php'),
          body: {
            'name': name,
            'email': email,
            'password': password,
            'phone': phone,
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);

            if (resarray['success']) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration successful')),
              );
              stopLoading();
              Navigator.pop(context); // Close the registration page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            } else {
              if (!mounted) return;
              stopLoading();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Registration failed: ${resarray['message']}'),
                ),
              );
            }
          } else {
            if (!mounted) return;
            stopLoading();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Registration failed: ${response.statusCode}'),
              ),
            );
          }
        })
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            if (!mounted) return;
            stopLoading();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Request timed out. Please try again.'),
              ),
            );
          },
        );
  }

  // close the status of loading on screen
  void stopLoading() {
    if (isLoading) {
      Navigator.pop(context); // Close the loading dialog
      setState(() {
        isLoading = false;
      });
    }
  }
}
