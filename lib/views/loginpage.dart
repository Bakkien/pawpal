import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/homepage.dart';
import 'package:pawpal/views/registerpage.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double width;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? emailError, passwordError;
  bool visible = true;
  bool isChecked = false;
  bool isLoading = false;
  late User user;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    if (width < 600) {
      width = width;
    } else {
      width = 600;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo_nodesc.png', scale: 0.8),
                const SizedBox(height: 20),
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
                const SizedBox(height: 5),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        isChecked = value!;
                        setState(() {});
                        emailError = null;
                        passwordError = null;
                        if (isChecked) {
                          if (emailController.text.trim().isEmpty) {
                            isChecked = false;
                            emailError = 'Please enter the field';
                            setState(() {});
                            return;
                          } else if (RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(emailController.text.trim()) ==
                              false) {
                            isChecked = false;
                            emailError = 'Invalid email';
                            setState(() {});
                            return;
                          } else if (passwordController.text.trim().isEmpty) {
                            isChecked = false;
                            passwordError = 'Please enter the field';
                            setState(() {});
                            return;
                          } else if (passwordController.text.trim().length <
                              6) {
                            isChecked = false;
                            passwordError =
                                'Password must be at least 6 characters';
                            setState(() {});
                            return;
                          } else {
                            prefUpdate(isChecked);
                            return;
                          }
                        } else {
                          prefUpdate(isChecked);
                          return;
                        }
                      },
                    ),
                    Text('Remember Me'),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      loginValidation();
                    },
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Don\'t have an account? Register',
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

  void loadPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');
      if (rememberMe != null && rememberMe) {
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');
        emailController.text = email ?? '';
        passwordController.text = password ?? '';
        isChecked = true;
        setState(() {});
      }
    });
  }

  void prefUpdate(bool isChecked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      prefs.setString('email', emailController.text.trim());
      prefs.setString('password', passwordController.text.trim());
      prefs.setBool('rememberMe', isChecked);
    } else {
      prefs.remove('email');
      prefs.remove('password');
      prefs.remove('rememberMe');
    }
  }

  void loginValidation() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    setState(() {
      emailError = null;
      passwordError = null;
    });

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

    loginUser(email, password);
  }

  void loginUser(String email, String password) async {
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
              Text('Loading...'),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );

    await http
        .post(
          Uri.parse('${MyConfig.server}/pawpal/server/api/login_user.php'),
          body: {'email': email, 'password': password},
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['success'] == 'true') {
              user = User.fromJson(resarray['data'][0]);
              if (!mounted) return;
              stopLoading();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage(user: user)),
              );
            } else {
              if (!mounted) return;
              stopLoading();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Login falid: ${resarray['message']}"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            if (!mounted) return;
            stopLoading();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Login failed: ${response.statusCode}"),
                backgroundColor: Colors.red,
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

  void stopLoading() {
    if (isLoading) {
      Navigator.pop(context); // Close the loading dialog
      setState(() {
        isLoading = false;
      });
    }
  }
}
