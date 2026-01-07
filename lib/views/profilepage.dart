import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/mydrawer.dart';
import 'package:pawpal/views/paymentpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  User user;
  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late double width;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  File? image;
  Uint8List? webImage, savedAvatar;
  String? nameError, phoneError;
  bool isLoading = false;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
    loadProfile();
  }

  void _loadUserPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      String? base64image = prefs.getString('avatar');
      String? name = prefs.getString('name');
      String? phone = prefs.getString('phone');
      if (base64image != null && base64image.isNotEmpty) {
        savedAvatar = base64Decode(base64image);
      }
      nameController.text = name ?? widget.user.userName.toString();
      phoneController.text = phone ?? widget.user.userPhone.toString();
      setState(() {});
    });
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 16,

        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            onPressed: () {
              loadProfile();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // AVATAR
                        GestureDetector(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.blue,
                            backgroundImage: savedAvatar != null
                                ? MemoryImage(savedAvatar!)
                                : kIsWeb
                                ? (webImage != null
                                      ? MemoryImage(webImage!)
                                      : widget.user.userAvatar != null
                                      ? NetworkImage(
                                          '${MyConfig.server}/pawpal/server/uploads/profile/user_${widget.user.userId}.png',
                                        )
                                      : null)
                                : (image != null
                                      ? FileImage(image!)
                                      : widget.user.userAvatar != null
                                      ? NetworkImage(
                                          '${MyConfig.server}/pawpal/server/uploads/profile/user_${widget.user.userId}.png',
                                        )
                                      : null),
                            child:
                                (savedAvatar == null &&
                                    image == null &&
                                    webImage == null &&
                                    widget.user.userAvatar == null)
                                ? Text(
                                    widget.user.userName
                                            ?.substring(0, 1)
                                            .toUpperCase() ??
                                        '',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                          onTap: () {
                            pickimagedialog();
                          },
                        ),

                        const SizedBox(height: 20),
                        // uneditable field
                        _readonlyField("Email", widget.user.userEmail),
                        _readonlyField(
                          "Registered",
                          dateFormat.format(
                            DateTime.parse(
                              widget.user.userRegdate ?? '0000-00-00',
                            ),
                          ),
                        ),
                        const Divider(height: 30),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                children: [
                                  const Icon(
                                    Icons.account_balance_wallet_outlined,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "My Wallet",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Wallet value
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'RM ${double.parse(widget.user.userWallet.toString()).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F3C88),
                                    ),
                                  ),
                                  const Spacer(),

                                  // Top Up button
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.add,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Top Up",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      showTopUpDialog();
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),

                              // Hint
                              Text(
                                "Money are used to make donation",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 30),
                        const SizedBox(height: 8),

                        // editable field
                        _inputField(
                          controller: nameController,
                          label: "Name",
                          icon: Icons.person,
                          error: nameError,
                          keyboard: TextInputType.name,
                        ),
                        const SizedBox(height: 12),
                        _inputField(
                          controller: phoneController,
                          label: "Phone Number",
                          icon: Icons.phone_outlined,
                          error: phoneError,
                          keyboard: TextInputType.phone,
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _updateProfile,
                            child: const Text(
                              "Save Changes",

                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // LOADING OVERLAY
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      drawer: MyDrawer(user: widget.user),
    );
  }

  // ================= HELPERS =================
  Widget _readonlyField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: value ?? "-"),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock_outline),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void showTopUpDialog() {
    double selectedTopUp = 10.00;

    List<double> topUpPriceMap = [
      5.00,
      10.00,
      15.00,
      20.00,
      30.00,
      40.00,
      50.00,
      100.00,
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: const [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 8),
                  Text("Top Up"),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select a top up package",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),

                  // DROPDOWN
                  DropdownButtonFormField<double>(
                    initialValue: selectedTopUp,
                    decoration: InputDecoration(
                      labelText: "Top Up Amount",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: topUpPriceMap.map((double money) {
                      return DropdownMenuItem<double>(
                        value: money,
                        child: Text("RM ${money.toStringAsFixed(2)}"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedTopUp = value!;
                      });
                    },
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    if (widget.user != null) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentScreen(
                            user: widget.user,
                            money: double.parse(
                              selectedTopUp.toStringAsFixed(2),
                            ),
                          ),
                        ),
                      );
                    }
                    loadProfile();
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // UI Helper
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String? error,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        errorText: error,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void loadProfile() {
    http
        .get(
          Uri.parse(
            '${MyConfig.server}/pawpal/server/api/get_user_details.php?userid=${widget.user.userId}',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['success']) {
              User user = User.fromJson(resarray['data'][0]);
              widget.user = user;
              setState(() {});
            }
          }
        });
  }

  // choose image source
  void pickimagedialog() {
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
                  openCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  openGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // open camera to get image
  Future<void> openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImage = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        image = File(pickedFile.path);
        cropImage();
      }
    }
  }

  // open gallery to get image
  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImage = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        image = File(pickedFile.path);
        cropImage(); // only for mobile
      }
    }
  }

  // crop the selected image
  Future<void> cropImage() async {
    if (kIsWeb) return; // skip cropping on web
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Please Crop Your Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(title: 'Cropper'),
      ],
    );
    if (croppedFile != null) {
      image = File(croppedFile.path);
      setState(() {});
    }
  }

  // update profile
  Future<void> _updateProfile() async {
    String base64image = "";
    if (kIsWeb) {
      base64image = base64Encode(webImage!);
    } else if (image != null) {
      base64image = base64Encode(image!.readAsBytesSync());
    }
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();

    setState(() {
      nameError = null;
      phoneError = null;
    });

    if (name.isEmpty) {
      setState(() {
        nameError = 'Please enter the field';
      });
      return;
    }
    if (phone.isEmpty) {
      setState(() {
        phoneError = 'Please enter the field';
      });
      return;
    }
    if (phone.length < 10 || phone.length > 11) {
      setState(() {
        phoneError = 'Invalid phone number';
      });
      return;
    }

    setState(() => isLoading = true);
    await http
        .post(
          Uri.parse('${MyConfig.server}/pawpal/server/api/update_profile.php'),
          body: {
            'userid': widget.user.userId,
            'useravatar': base64image,
            'username': name,
            'userphone': phone,
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            if (data['success']) {
              savePreferences(base64image);
              loadProfile();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Profile updated successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(data['message'] ?? "Update failed"),
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Request timed out. Please try again.'),
              ),
            );
          },
        );

    loadProfile();
    setState(() => isLoading = false);
  }

  void savePreferences(String base64image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('avatar', base64image);
    prefs.setString('name', nameController.text.trim());
    prefs.setString('phone', phoneController.text.trim());
  }
}
