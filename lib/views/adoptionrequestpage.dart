import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/myconfig.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/views/mainpage.dart';

class AdoptionRequestScreen extends StatefulWidget {
  final User? user;
  final Pet? pet;
  const AdoptionRequestScreen({
    super.key,
    required this.user,
    required this.pet,
  });

  @override
  State<AdoptionRequestScreen> createState() => _AdoptionRequestScreenState();
}

class _AdoptionRequestScreenState extends State<AdoptionRequestScreen> {
  late double width;
  String selectedHouse = "Apartment", selectedOwn = "Yes";
  List<String> houseTypes = ["Apartment", "Condo", "Landed House"];
  List<String> owned = ["Yes", "No"];
  TextEditingController reasonController = TextEditingController();
  String? reasonError;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    if (width > 600) {
      width = 600;
    } else {
      width = width;
    }
    return Scaffold(
      appBar: AppBar(title: Text('Adoption Form')),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: width,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: width * 0.9,
                    child: AspectRatio(
                      aspectRatio: 5 / 3,
                      child: Image.network(
                        '${MyConfig.server}/pawpal/server/uploads/pet/pet_${widget.pet!.petId}_1.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.broken_image,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Pet Owner Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pet Owner',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),
                        Text(
                          widget.pet?.userName ?? 'null',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.pet?.userEmail ?? 'null',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.pet?.userPhone ?? 'null',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    // Adopter Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adopter',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),
                        Text(
                          widget.user?.userName ?? 'null',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.user?.userEmail ?? 'null',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.user?.userPhone ?? 'null',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // House Type
                Text('Type of housing'),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: selectedHouse,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: Icon(Icons.keyboard_arrow_down),
                  items: houseTypes.map((String selectedHouse) {
                    return DropdownMenuItem<String>(
                      value: selectedHouse,
                      child: Text(selectedHouse),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedHouse = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 10),

                // Owned pet before
                Text('Have you owned pets before?'),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: selectedOwn,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: Icon(Icons.keyboard_arrow_down),
                  items: owned.map((String selectedOwn) {
                    return DropdownMenuItem<String>(
                      value: selectedOwn,
                      child: Text(selectedOwn),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOwn = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 10),

                // Reason
                Text('Why do you want to adopt this pet?'),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 3,
                  controller: reasonController,
                  decoration: InputDecoration(
                    errorText: reasonError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                // Request button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
                  ),
                    onPressed: showRequestDialog,
                    child: Text('Request'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showRequestDialog() {
    String petId = widget.pet!.petId.toString();
    String userId = widget.user!.userId.toString();
    String houseType = selectedHouse;
    String owned = selectedOwn;
    String reason = reasonController.text.trim();
    String status = 'Pending';

    setState(() {
      reasonError = null;
    });

    // reason validation
    if (reason.isEmpty) {
      setState(() {
        reasonError = "Required field";
      });
      return;
    }
    if (reason.length < 5) {
      setState(() {
        reasonError = "Reason must be at least 5 characters";
      });
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Are you sure you want to apply for adoption?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                submitRequest(
                  petId,
                  userId,
                  houseType,
                  owned,
                  reason,
                  status,
                );
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void submitRequest(
    String petId,
    String userId,
    String houseType,
    String owned,
    String reason,
    String status,
  ) {
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

    http
        .post(
          Uri.parse(
            '${MyConfig.server}/pawpal/server/api/submit_adoption_request.php',
          ),
          body: {
            'petid': petId,
            'userid': userId,
            'houseType': houseType,
            'owned': owned,
            'reason': reason,
            'status': status,
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['success']) {
              if (!mounted) return;
              stopLoading();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${resarray['message']}"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(user: widget.user),
                ),
              );
            } else {
              if (!mounted) return;
              stopLoading();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Submit failed: ${resarray['message']}"),
                  backgroundColor: Colors.red,
                ),
              );
            }
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
