import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/views/homepage.dart';
import 'package:pawpal/views/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/myconfig.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String email = '';
  String password = '';
  late User user;

  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', scale: 0.6),
            const SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  void autoLogin() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');
      if (rememberMe != null && rememberMe) {
        email = prefs.getString('email') ?? 'NA';
        password = prefs.getString('password') ?? 'NA';
        if (email != 'NA' && password != 'NA') {
          http
              .post(
                Uri.parse(
                  '${MyConfig.server}/pawpal/server/api/login_user.php',
                ),
                body: {'email': email, 'password': password},
              )
              .then((response) {
                if (response.statusCode == 200) {
                  var jsonResponse = response.body;
                  var resarray = jsonDecode(jsonResponse);
                  if (resarray['success'] == 'true') {
                    user = User.fromJson(resarray['data'][0]);
                    // Navigate to home page
                    Future.delayed(const Duration(seconds: 2), () {
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(user: user),
                        ),
                      );
                    });
                  } else {
                    navigateToLogin();
                  }
                } else {
                  navigateToLogin();
                }
              })
              .timeout(
                const Duration(seconds: 5),
                onTimeout: () {
                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              );
        } else {
          navigateToLogin();
        }
      }
      else {
        navigateToLogin();
      }
    });
  }

  void navigateToLogin() {
    Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
  }
}
