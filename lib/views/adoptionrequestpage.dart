import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/myconfig.dart';
import 'package:http/http.dart' as http;

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
  TextEditingController addinfoController = TextEditingController();
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: width * 0.9,
                    child: AspectRatio(
                      aspectRatio: 5 / 3,
                      child: Image.network(
                        '${MyConfig.server}/pawpal/server/uploads/pet_${widget.pet!.petId}_1.png',
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Poster',
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
                TextField(
                  maxLines: 3,
                  controller: addinfoController,
                  decoration: InputDecoration(
                    labelText: 'Addtional Information',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
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
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        content: const Text('Are you sure you want to apply for adoption?'),
        actions: [
            TextButton(
              onPressed: () {
                
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
    });
  }
}
