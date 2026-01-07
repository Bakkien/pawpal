import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pawpal/models/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pawpal/myconfig.dart';
import 'package:http/http.dart' as http;

class SubmitPetScreen extends StatefulWidget {
  final User? user;
  const SubmitPetScreen({super.key, required this.user});

  @override
  State<SubmitPetScreen> createState() => _SubmitPetScreenState();
}

class _SubmitPetScreenState extends State<SubmitPetScreen> {
  late double width;
  TextEditingController petNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  List<String> petTypes = ["Cat", "Dog", "Rabbit", "Other"];
  List<String> gender = ["Male", "Female", "Both"];
  List<String> categories = ["Adoption", "Donation Request", "Help/Rescue"];
  List<String> health = ["Healthy", "Critical", "Unknown"];
  String selectedPetType = "Other",
      selectedGender = "Male",
      selectedCategory = "Adoption",
      selectedHealth = "Healthy";
  late Position position;
  late double lat, lng;
  List<Uint8List?> webImages = [null, null, null];
  List<File?> images = [null, null, null];
  String? petNameError, ageError, descriptionError, locationError, imageError;
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
      appBar: AppBar(title: Text('Pet Submission Form')),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: width,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                // logo
                Image.asset('assets/images/pet_background.png', scale: 3),
                const SizedBox(height: 20),

                // pet name
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: petNameController,
                        decoration: InputDecoration(
                          labelText: 'Pet Name',
                          errorText: petNameError,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    // pet type
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedPetType,
                        decoration: InputDecoration(
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
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    // gender
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedGender,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: gender.map((String selectedGender) {
                          return DropdownMenuItem<String>(
                            value: selectedGender,
                            child: Text(selectedGender),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    // age
                    Expanded(
                      child: TextField(
                        controller: ageController,
                        decoration: InputDecoration(
                          labelText: 'Age',
                          errorText: ageError,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // category
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: categories.map((String selectedCategory) {
                          return DropdownMenuItem<String>(
                            value: selectedCategory,
                            child: Text(selectedCategory),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedHealth,
                        decoration: InputDecoration(
                          labelText: 'Health',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: health.map((String selectedHealth) {
                          return DropdownMenuItem<String>(
                            value: selectedHealth,
                            child: Text(selectedHealth),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedHealth = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // description
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: 3,
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          errorText: descriptionError,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // location
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: 3,
                        controller: locationController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          errorText: locationError,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              position = await _determinePosition();
                              lat = position.latitude;
                              lng = position.longitude;
                              List<Placemark> placemarks =
                                  await placemarkFromCoordinates(
                                    position.latitude,
                                    position.longitude,
                                  );
                              Placemark place = placemarks[0];
                              locationController.text =
                                  "${place.name},\n${place.postalCode},${place.locality},\n${place.administrativeArea},${place.country}";
                              setState(() {});
                            },
                            icon: Icon(Icons.location_searching),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // image upload maximum up to 3
                Row(
                  children: [
                    Text('Image\n(Max 3)', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 33),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            imageError = null;
                          });
                          // index for image, easy for pick and crop image based on index
                          if (kIsWeb) {
                            openGallery(0);
                          } else {
                            pickimagedialog(0);
                          }
                        },
                        child: Container(
                          height: 95,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: imageError == null
                                  ? Colors.grey
                                  : Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            image: (images[0] != null && !kIsWeb)
                                ? DecorationImage(
                                    image: FileImage(images[0]!),
                                    fit: BoxFit.cover,
                                  )
                                : (webImages[0] != null)
                                ? DecorationImage(
                                    image: MemoryImage(webImages[0]!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: (images[0] == null && webImages[0] == null)
                              ? Center(
                                  child: Icon(
                                    Icons.photo_library,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            imageError = null;
                          });
                          if (images[0] != null || webImages[0] != null) {
                            if (kIsWeb) {
                              openGallery(1);
                            } else {
                              pickimagedialog(1);
                            }
                          } else {
                            imageError = 'Please click on the first one';
                            setState(() {});
                          }
                        },
                        child: Container(
                          height: 95,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: imageError == null
                                  ? Colors.grey
                                  : Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            image: (images[1] != null && !kIsWeb)
                                ? DecorationImage(
                                    image: FileImage(images[1]!),
                                    fit: BoxFit.cover,
                                  )
                                : (webImages[1] != null)
                                ? DecorationImage(
                                    image: MemoryImage(webImages[1]!),
                                    fit: BoxFit.cover,
                                  )
                                : null, // return icon if no image
                          ),
                          child: (images[1] == null && webImages[1] == null)
                              ? Center(
                                  child: Icon(
                                    Icons.photo_library,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            imageError = null;
                          });
                          if (images[0] == null && webImages[0] == null) {
                            imageError = 'Please click on the first one';
                            setState(() {});
                          } else if (images[1] == null &&
                              webImages[1] == null) {
                            imageError = 'Please click on the second one';
                            setState(() {});
                          } else {
                            if (kIsWeb) {
                              openGallery(2);
                            } else {
                              pickimagedialog(2);
                            }
                          }
                        },
                        child: Container(
                          height: 95,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: imageError == null
                                  ? Colors.grey
                                  : Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            image: (images[2] != null && !kIsWeb)
                                ? DecorationImage(
                                    image: FileImage(images[2]!),
                                    fit: BoxFit.cover,
                                  )
                                : (webImages[2] != null)
                                ? DecorationImage(
                                    image: MemoryImage(webImages[2]!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: (images[2] == null && webImages[2] == null)
                              ? Center(
                                  child: Icon(
                                    Icons.photo_library,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                if (imageError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      imageError!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
                  ),
                    onPressed: () {
                      submitValidation();
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // auto obtain the current location of the user
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  // choose the image source
  void pickimagedialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  openCamera(index);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  openGallery(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // open the camera to capture image
  Future<void> openCamera(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImages[index] = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        File imageFile = File(pickedFile.path);
        cropImage(index, imageFile);
      }
    }
  }

  // open gallery to select image
  Future<void> openGallery(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImages[index] = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        File imageFile = File(pickedFile.path);
        cropImage(index, imageFile); // only for mobile
      }
    }
  }

  // crop the image
  Future<void> cropImage(int index, File image) async {
    if (kIsWeb) return; // skip cropping on web
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Please Crop Your Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(title: 'Cropper'),
      ],
    );

    if (croppedFile != null) {
      image = File(croppedFile.path);
      // save image in list
      if (index == 0) images[0] = image;
      if (index == 1) images[1] = image;
      if (index == 2) images[2] = image;
      imageError = null;
      setState(() {});
    }
  }

  // validate all fields for submission
  void submitValidation() {
    String petName = petNameController.text.trim();
    String petType = selectedPetType;
    String gender = selectedGender;
    String age = ageController.text.trim();
    String category = selectedCategory;
    String health = selectedHealth;
    String description = descriptionController.text.trim();
    String location = locationController.text.trim();

    List<String> base64images = [];

    setState(() {
      petNameError = null;
      ageError = null;
      descriptionError = null;
      locationError = null;
      imageError = null;
    });

    if (petName.isEmpty) {
      setState(() {
        petNameError = "Required field";
      });
      return;
    }

    if (ageController.text.trim().isEmpty) {
      setState(() {
        ageError = "Required field";
      });
      return;
    }

    if (description.isEmpty) {
      setState(() {
        descriptionError = "Required field";
      });
      return;
    }
    if (description.length < 10) {
      setState(() {
        descriptionError = "Description must be at least 10 characters";
      });
      return;
    }
    if (location.isEmpty) {
      setState(() {
        locationError = "Required field";
      });
      return;
    }
    if (kIsWeb) {
      for (int i = 0; i < 3 && webImages[i] != null; i++) {
        base64images.add(base64Encode(webImages[i]!));
      }
    } else {
      if (images[0] == null) {
        setState(() {
          imageError = "Please select at least one image";
        });
        return;
      }
      for (int i = 0; i < 3 && images[i] != null; i++) {
        base64images.add(base64Encode(images[i]!.readAsBytesSync()));
      }
    }

    // show submit confirmation dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Are you sure you want to submit?'),
          actions: [
            TextButton(
              onPressed: () {
                submitPet(
                  petName,
                  petType,
                  gender,
                  age,
                  category,
                  health,
                  description,
                  lat.toString(),
                  lng.toString(),
                  base64images,
                );
                Navigator.of(context).pop();
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

  // send pet data to database
  void submitPet(
    String petName,
    String petType,
    String gender,
    String age,
    String category,
    String health,
    String description,
    String lat,
    String lng,
    List<String?> base64images,
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
          Uri.parse('${MyConfig.server}/pawpal/server/api/submit_pet.php'),
          body: {
            'userid': widget.user?.userId,
            'petname': petName,
            'pettype': petType,
            'gender': gender,
            'age': age,
            'category': category,
            'health': health,
            'description': description,
            'latitude': lat,
            'longitude': lng,
            'images': jsonEncode(base64images),
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['success']) {
              if (!mounted) return;
              stopLoading();
              Navigator.pop(context);// cant pushreplacement idk why
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${resarray['message']}"),
                  backgroundColor: Colors.green,
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
      Navigator.of(context).pop(); // Close the loading dialog
      setState(() {
        isLoading = false;
      });
    }
  }
}
