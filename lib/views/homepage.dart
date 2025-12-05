import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/views/loginpage.dart';
import 'package:pawpal/views/mainscreen.dart';
import 'package:pawpal/views/submitpetscreen.dart';

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    if (width > 600) {
      width = 600;
    } else {
      width = width;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      body: Center(
        child: Container(
          width: width,
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${widget.user?.userName}!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainScreen(user: widget.user),
                            ),
                          );
                        },
                        child: Image.asset('assets/images/logo.png', scale: 0.6),
                      ),
                      Text('Click on Me', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmitPetScreen(user: widget.user),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
