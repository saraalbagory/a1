import 'dart:io';

import 'package:a1/database_services/repositry.dart';
import 'package:a1/models/student_model.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:image_picker/image_picker.dart';
//import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart'; // Add this import
//import 'package:a1/database_services/sign_up_logic.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  if (await Permission.camera.isDenied) {
    await Permission.camera.request();
  }
  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }
}

class ProfileScreen extends StatefulWidget {
  static const String routeName = "ProfileScreen";
  final Repository repo = Repository();
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController studentIDController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? gender;
  int? level;
  final _formKey = GlobalKey<FormState>();
  late StudentModel student;
  File? _image;
  @override
  void initState() {
    super.initState();
    requestPermissions();
    // Access the student data from ModalRoute in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StudentModel passedStudent =
          ModalRoute.of(context)!.settings.arguments as StudentModel;

      setState(() {
        student = passedStudent; // Initialize student with the passed student
        level = student.level; // Initialize level with student's saved level
        gender =
            student.gender; // Initialize gender with student's saved gender
        if (student.profileImage != null && student.profileImage!.isNotEmpty) {
          _image = File(student.profileImage!);
        }
      });
    });
  }

  Future<void> _uploadImage(String imagePath) async {
    try {
      final Directory = await getApplicationDocumentsDirectory();
      final fileName = imagePath.split('/').last;
      final savedImagePath = '${Directory.path}/$fileName';
      final File localImage = await File(imagePath).copy(savedImagePath);
      setState(() {
        _image = localImage;
      });
      log("Image uploaded successfully");
    } catch (e) {
      log("Error in _uploadImage: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred during image upload :$e")),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadImage(pickedFile.path);
    }
  }

  void editProfile() async {
    try {
      if (_formKey.currentState!.validate()) {
        StudentModel newStudent = StudentModel(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          studentID: studentIDController.text.trim(),
          password: passwordController.text.trim(),
          gender: gender,
          level: level,
          profileImage: _image?.path,
        );

        log("Calling profile...");
        StudentModel? updatedStudent = await widget.repo.updateStudent(
          newStudent,
        );
        log("Response received: $updatedStudent");
        if (updatedStudent == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An error occurred during update")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Profile updated successfully")),
          );
          Navigator.popAndPushNamed(
            context,
            ProfileScreen.routeName,
            arguments: updatedStudent,
          );
        }
      }
    } catch (e) {
      log("Error in callSignup: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred during signup")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final StudentModel student =
    //     ModalRoute.of(context)!.settings.arguments as StudentModel;
    // level=student.level;
    return Scaffold(
      appBar: AppBar(title: Text("Profile", style: TextStyle(fontSize: 20.sp))),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        child: CircleAvatar(
                          radius: 50.r,
                          backgroundImage:
                              _image != null
                                  ? FileImage(_image!)
                                  : (student.profileImage != null &&
                                      File(student.profileImage!).existsSync())
                                  ? FileImage(File(student.profileImage!))
                                  : AssetImage(
                                        "assets/Images/Profile-PNG-Photo.png",
                                      )
                                      as ImageProvider,
                        ),
                      ),
                      // Container(
                      //   width: 100.w,
                      //   height: 100.h,
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     image: DecorationImage(
                      //       image: AssetImage(student.profileImage!),
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              _pickImage(ImageSource.gallery);
                            },
                            icon: Icon(Icons.image),
                          ),
                          IconButton(
                            onPressed: () {
                              _pickImage(ImageSource.camera);
                            },
                            icon: Icon(Icons.camera_alt),
                          ),
                        ],
                      ),
                    ],
                  ),

                  _buildTextField(
                    nameController,
                    student.name, // Initial value
                    false, // Read-only
                    "Name", // Label
                    "Name is required",
                  ),
                  SizedBox(height: 12.h),
                  _buildTextField(
                    emailController,
                    student.email,
                    true,
                    "Email",
                    "Email is required",
                    validator: (value) {
                      if (value!.isEmpty) return "Email is required";

                      if (!RegExp(
                        r"^[0-9]+@stud.fci-cu.edu.eg$",
                      ).hasMatch(value.trim())) {
                        return "Invalid FCAI email format";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  _buildTextField(
                    studentIDController,
                    student.studentID,
                    true,
                    "Student ID",
                    "Student ID is required",
                  ),
                  SizedBox(height: 12.h),
                  _buildTextField(
                    passwordController,
                    student.password,
                    false,
                    "Password",
                    "Password is required",
                    isPassword: true,
                    validator: (value) {
                      if (value!.isEmpty) return "Password is required";
                      if (value.length < 8 || !value.contains(RegExp(r'\d'))) {
                        return "Password must be 8+ chars and contain a number";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  // _buildTextField(
                  //   confirmPasswordController,
                  //   "Confirm Password",
                  //   "Confirm password is required",
                  //   isPassword: true,
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return "Confirm password is required";
                  //     }
                  //     if (value != passwordController.text) {
                  //       return "Passwords do not match";
                  //     }
                  //     return null;
                  //   },
                  // ),
                  //SizedBox(height: 12.h),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: "Select Level",
                      border: OutlineInputBorder(),
                    ),
                    value: level,
                    items:
                        [1, 2, 3, 4].map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              "Level $e",
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          );
                        }).toList(),
                    onChanged: (val) => setState(() => level = val),
                  ),
                  SizedBox(height: 12.h),
                  _buildGenderSelection(),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: editProfile,
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable TextField Widget
  Widget _buildTextField(
    TextEditingController controller,
    String initialValue,
    bool readOnly,
    String label,
    String errorMessage, {
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      readOnly: readOnly, // Set the readOnly property
      controller: controller..text = initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      obscureText: isPassword,
      validator: validator ?? (value) => value!.isEmpty ? errorMessage : null,
    );
  }

  /// Gender Selection Widget
  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gender:",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Radio<String>(
              value: "male",
              groupValue: gender,
              onChanged: (val) => setState(() => gender = val),
            ),
            Text("Male", style: TextStyle(fontSize: 14.sp)),
            SizedBox(width: 20.w),
            Radio<String>(
              value: "female",
              groupValue: gender,
              onChanged: (val) => setState(() => gender = val),
            ),
            Text("Female", style: TextStyle(fontSize: 14.sp)),
          ],
        ),
      ],
    );
  }
}
