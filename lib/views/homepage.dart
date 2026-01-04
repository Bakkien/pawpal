import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/shared/mydrawer.dart';
import 'package:pawpal/views/mainpage.dart';
import 'package:pawpal/views/submitpetpage.dart';

class HomeScreen extends StatefulWidget {
  final User? user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // welcome message
              Text(
                'Welcome, ${widget.user?.userName}!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              // clickable logo navigate to main screen
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
                              builder: (context) =>
                                  MainScreen(user: widget.user),
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/images/logo.png',
                          scale: 0.6,
                        ),
                      ),
                      Text(
                        'Click on Me',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // add submission
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
      drawer: MyDrawer(user: widget.user),
    );
  }
}
