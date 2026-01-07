import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/animated_route.dart';
import 'package:pawpal/views/adoptionpage.dart';
import 'package:pawpal/views/donationhistorypage.dart';
import 'package:pawpal/views/loginpage.dart';
import 'package:pawpal/views/mainpage.dart';
import 'package:pawpal/views/profilepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  final User? user;
  const MyDrawer({super.key, this.user});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late double screenHeight;
  Uint8List? webImage, savedAvatar, networkImage;
  File? image;
  String? name;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  void _loadUserPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      String? base64image = prefs.getString('avatar');
      name = prefs.getString('name');
      email = prefs.getString('email');
      if (base64image != null && base64image.isNotEmpty) {
        savedAvatar = base64Decode(base64image);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            // avatar
            currentAccountPicture: CircleAvatar(
              radius: 15,
              backgroundImage: savedAvatar != null
                  ? MemoryImage(savedAvatar!)
                  : widget.user?.userAvatar != null
                  ? NetworkImage(
                      '${MyConfig.server}/pawpal/server/uploads/profile/user_${widget.user!.userId}.png',
                    )
                  : null,
              child: (savedAvatar == null && widget.user?.userAvatar == null)
                  ? Text(
                      name?.substring(0, 1).toUpperCase() ??
                          widget.user!.userName
                              .toString()
                              .substring(0, 1)
                              .toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),

            // user name
            accountName: Text(name ?? widget.user!.userName.toString()),

            //user email
            accountEmail: Text(email ?? widget.user!.userEmail.toString()),
            decoration: BoxDecoration(color: Colors.blue),
          ),

          // Main Screen
          ListTile(
            leading: Icon(Icons.pets),
            title: Text('Pet Adoption & Donation'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(MainScreen(user: widget.user)),
              );
            },
          ),

          // Adoption Screen
          ListTile(
            leading: Icon(Icons.request_page),
            title: Text('Adoption'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(AdoptionScreen(user: widget.user)),
              );
            },
          ),
          
          // Donation History Screen
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Donation History'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(
                  DonationHistoryScreen(user: widget.user),
                ),
              );
            },
          ),

          // Profile Screen
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(ProfileScreen(user: widget.user!)),
              );
            },
          ),

          // Login Screen
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Log Out'),
            onTap: () {
              removePreferences();
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(LoginScreen()),
              );
            },
          ),

          const Divider(color: Colors.grey),
          SizedBox(
            height: screenHeight / 3.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text("Version 0.3", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // remove all preferences after log out
  void removePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('avatar');
    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('password');
    prefs.remove('phone');
    prefs.remove('rememberMe');
  }
}
