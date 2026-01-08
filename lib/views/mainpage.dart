import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pawpal/views/adoptionrequestpage.dart';
import 'package:pawpal/shared/mydrawer.dart';
import 'package:pawpal/views/donationpage.dart';
import 'package:pawpal/views/editpetpage.dart';
import 'package:pawpal/views/submitpetpage.dart';

class MainScreen extends StatefulWidget {
  final User? user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late double width;
  TextEditingController searchController = TextEditingController();
  String selectedPetType = 'All';
  List<String> petTypes = ["All", "Cat", "Dog", "Rabbit", "Other"];
  List<Pet> listPets = [];
  String status = "Loading...";
  DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadPets('', '');
  }

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
        title: Text('Pet Adoption & Donation'),
        actions: [
          IconButton(
            onPressed: () {
              loadPets('', '');
              searchController.clear();
              selectedPetType = 'All';
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: width,
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // search textfield
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  String filter = selectedPetType;
                  if (filter != 'All') {
                    loadPets(value, selectedPetType);
                  } else if (value.isEmpty) {
                    loadPets('', '');
                  } else {
                    loadPets(value, '');
                  }
                },
              ),

              SizedBox(height: 10),
              // Filter
              DropdownButtonFormField<String>(
                initialValue: selectedPetType,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.pets),
                  labelText: 'Pet Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: Icon(Icons.keyboard_arrow_down),
                items: petTypes.map((String selectedPetType) {
                  return DropdownMenuItem<String>(
                    value: selectedPetType,
                    child: Text(selectedPetType),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPetType = newValue!;
                    String search = searchController.text.trim();
                    if (selectedPetType == 'All') {
                      // All always at top if selected
                      petTypes.remove(selectedPetType);
                      petTypes.insert(0, selectedPetType);
                      searchController.clear();
                      loadPets('', '');
                    } else {
                      // move selected at top but All always at second
                      petTypes.remove(selectedPetType);
                      petTypes.remove('All');
                      petTypes.insert(0, selectedPetType);
                      petTypes.insert(1, 'All');
                      loadPets(search, selectedPetType);
                    }
                  });
                },
              ),

              SizedBox(height: 20),
              Expanded(
                child: listPets.isEmpty
                    // show no submission if empty list
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inbox, size: 64),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    // show the list of pets
                    : ListView.builder(
                        itemCount: listPets.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // First image as thumbnail
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: width * 0.28, // more responsive
                                      height:
                                          width * 0.26, // balanced aspect ratio
                                      color: Colors.grey[200],
                                      child: Image.network(
                                        '${MyConfig.server}/pawpal/server/uploads/pet/pet_${listPets[index].petId}_1.png',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.broken_image,
                                                size: 60,
                                                color: Colors.grey,
                                              );
                                            },
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Pet Name
                                        Text(
                                          'Name: ${listPets[index].petName.toString()}',
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        // Pet Type
                                        Text(
                                          'Type: ${listPets[index].petType.toString()}',
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        // Age
                                        Text(
                                          'Age: ${listPets[index].age.toString()}',
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                      ],
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      showDetailsDialog(index);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ), // add submission
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

  // load all pets
  void loadPets(String searchQuery, String filterQuery) {
    setState(() {
      status = "Loading...";
    });
    http
        .get(
          Uri.parse(
            '${MyConfig.server}/pawpal/server/api/get_my_pets.php?search=$searchQuery&filter=$filterQuery',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);

            if (jsonResponse['success'] &&
                jsonResponse['data'] != null &&
                jsonResponse['data'].isNotEmpty) {
              // has data → load to list
              listPets.clear();
              for (var item in jsonResponse['data']) {
                listPets.add(Pet.fromJson(item));
              }
              setState(() {
                status = "";
              });
            } else if (jsonResponse['success']) {
              // success but EMPTY data
              setState(() {
                listPets.clear();
                status = jsonResponse['message'].toString();
              });
            }
          } else {
            // request failed
            setState(() {
              listPets.clear();
              status = "Failed to load pets";
            });
          }
        });
  }

  // show all details in dialog using table
  void showDetailsDialog(int index) {
    final pet = listPets[index];
    final formattedDate = formatter.format(
      DateTime.parse(pet.createdDate.toString()),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: controller,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DRAG HANDLE
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // IMAGE
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: AspectRatio(
                        aspectRatio: 5 / 3,
                        child: Image.network(
                          '${MyConfig.server}/pawpal/server/uploads/pet/pet_${pet.petId}_1.png',
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

                    const SizedBox(height: 16),

                    // Pet Name
                    Text(
                      '${pet.petName.toString()}, ${pet.gender.toString()}, ${pet.age.toString()}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Category
                    Text(
                      pet.category.toString(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    //Health
                    Text(
                      'Health: ${pet.health.toString()}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      pet.description.toString(),
                      style: const TextStyle(fontSize: 15),
                    ),

                    const SizedBox(height: 20),
                    const Divider(),

                    // INFO SECTION
                    _infoRow("Posted On", formattedDate),
                    _infoRow("Posted by", pet.userName),
                    _infoRow("Phone", pet.userPhone),
                    _infoRow("Email", pet.userEmail),

                    const SizedBox(height: 20),

                    // check if user id != pet. user id then show button else edit and delete
                    widget.user!.userId != pet.userId
                        ? SizedBox(
                            width: double.infinity,
                            child: pet.category == 'Adoption'
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AdoptionRequestScreen(
                                                user: widget.user,
                                                pet: pet,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Text('Request to Adopt'),
                                  )
                                : pet.category == 'Donation Request'
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFD700),
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DonationScreen(
                                            user: widget.user!,
                                            pet: pet,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text('Donate'),
                                  )
                                : null,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdatePetScreen(
                                        user: widget.user,
                                        pet: listPets[index],
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit, size: 24, color: Colors.blue),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDeleteDialog(index);
                                },
                                icon: const Icon(Icons.delete, size: 24, color: Colors.red),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // UI Helper
  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(child: Text(value ?? "-")),
        ],
      ),
    );
  }

  void showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this request?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                deletePet(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deletePet(int index) {
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
          Uri.parse('${MyConfig.server}/pawpal/server/api/delete_pet.php'),
          body: {
            'userid': widget.user!.userId.toString(),
            'petid': listPets[index].petId.toString(),
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['success']) {
              loadPets('', '');
              if (!mounted) return;
              stopLoading();
              Navigator.pop(context); // close DraggableScrollableShee
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Pet deleted successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              if (!mounted) return;
              stopLoading();
              Navigator.pop(context); // close DraggableScrollableShee
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Pet deletion failed"),
                  backgroundColor: Colors.red,
                ),
              );
            }
            setState(() {});
          }
        })
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            if (!mounted) return;
            stopLoading();
            Navigator.pop(context); // close DraggableScrollableShee
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
