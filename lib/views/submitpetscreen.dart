import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pawpal/myconfig.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/views/homepage.dart';

class SubmitPetScreen extends StatefulWidget {
  final User? user;
  const SubmitPetScreen({super.key, required this.user});

  @override
  State<SubmitPetScreen> createState() => _SubmitPetScreenState();
}

class _SubmitPetScreenState extends State<SubmitPetScreen> {
  late double width;
  TextEditingController petNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();
  List<String> petTypes = ["Cat", "Dog", "Rabbit", "Other"];
  List<String> categories = ["Adoption", "Donation Request", "Help/Rescue"];
  String selectedPetType = "Other", selectedCategory = "Adoption";
  late Position position;
  File? image1, image2, image3;
  String? petNameError, descriptionError, latError, lngError, imageError;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _autoGetCurrentLocation();
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
      appBar: AppBar(title: Text('Pet Submission Form')),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: width,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Image.asset('assets/images/pet_background.png', scale: 3),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Pet Name', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: petNameController,
                        decoration: InputDecoration(
                          errorText: petNameError,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Pet Type', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 24),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedPetType,
                        decoration: InputDecoration(
                          labelText: 'Select Pet Type',
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
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Category', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 22),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Select Category',
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
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Description', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        maxLines: 3,
                        controller: descriptionController,
                        decoration: InputDecoration(
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
                Row(
                  children: [
                    Text('Location', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 25),
                    Expanded(
                      child: TextField(
                        controller: latController,
                        decoration: InputDecoration(
                          labelText: 'Latitude',
                          hintText: 'Latitude',
                          errorText: latError,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        controller: lngController,
                        decoration: InputDecoration(
                          labelText: 'Longitude',
                          hintText: 'Longitude',
                          errorText: lngError,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Image\n(Max 3)', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 33),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          pickimagedialog(1); // index for image, easy for pick and crop image based on index
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
                            image: (image1 != null)
                                ? DecorationImage(
                                    image: FileImage(image1!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: (image1 == null)
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
                          if (image1 != null) {
                            pickimagedialog(2);
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
                            image: (image2 != null)
                                ? DecorationImage(
                                    image: FileImage(image2!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: (image2 == null)
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
                          if (image1 == null) {
                            imageError = 'Please click on the first one';
                            setState(() {});
                          } else if (image2 == null) {
                            imageError = 'Please click on the second one';
                            setState(() {});
                          } else {
                            pickimagedialog(3);
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
                            image: (image3 != null)
                                ? DecorationImage(
                                    image: FileImage(image3!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: (image3 == null)
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
                    onPressed: () {
                      fieldValidation();
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

  Future<void> _autoGetCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    position = await Geolocator.getCurrentPosition();
    setState(() {
      latController.text = position.latitude.toString();
      lngController.text = position.longitude.toString();
    });
  }

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
  
  Future<void> openCamera(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        cropImage(index, imageFile);
    }
  }

  Future<void> openGallery(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      cropImage(index, imageFile);
    }
  }

  Future<void> cropImage(int index, File image) async {
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
      if (index == 1) image1 = image;
      if (index == 2) image2 = image;
      if (index == 3) image3 = image;
      imageError = null;
      setState(() {});
    }
  }

  void fieldValidation() {
    String petName = petNameController.text.trim();
    String petType = selectedPetType;
    String category = selectedCategory;
    String description = descriptionController.text.trim();
    String lat = latController.text.trim();
    String lng = lngController.text.trim();
    List<String> base64images = [];

    setState(() {
      petNameError = null;
      descriptionError = null;
      latError = null;
      lngError = null;
      imageError = null;
    });

    if (petName.isEmpty) {
      setState(() {
        petNameError = "Required field";
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
    if (lat.isEmpty) {
      setState(() {
        latError = "Required field";
      });
      return;
    }
    if (lng.isEmpty) {
      setState(() {
        lngError = "Required field";
      });
      return;
    }
    if (image1 == null) {
      setState(() {
        imageError = "Please select at least one image";
      });
      return;
    } else {
      base64images.add(base64Encode(image1!.readAsBytesSync()));
    }
    if (image2 != null) {
      base64images.add(base64Encode(image2!.readAsBytesSync()));
    }
    if (image3 != null) {
      base64images.add(base64Encode(image3!.readAsBytesSync()));
    }

    // show submit confirmation dialog
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: const Text('Are you sure you want to submit?'),
          actions: [
            TextButton(onPressed: () {
              submitPet(petName, petType, category, description, lat, lng, base64images);
              } , 
              child: Text('Submit')),
              TextButton(onPressed:  () => Navigator.pop(context), child: const Text('Cancel'))
          ],
        );
      }
    );
  }

  void submitPet(
    String petName,
    String petType,
    String category,
    String description,
    String lat,
    String lng,
    List<String> base64images,
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
            'category': category,
            'description': description,
            'latitude': lat,
            'longitude': lng,
            'image': jsonEncode(base64images),
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
                  content: Text("Service submitted successfully"),
                  backgroundColor: Colors.green,
                ),
              );
              if (!mounted) return;
              stopLoading();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(user: widget.user),
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
        });
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
