import 'package:a1/database_services/repositry.dart';
import 'package:a1/models/student_model.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:a1/database_services/sign_up_logic.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        );

        log("Calling signUp...");
        StudentModel? updatedStudent = await widget.repo.updateStudent(newStudent);
        //TODO: IF the user registered take the new student and pass it to the new page
        log("Response received: $updatedStudent");
        if(updatedStudent == null){
          ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("An error occurred during signup")));
        }else{
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Profile updated successfully")));
        Navigator.popAndPushNamed(
          context,
          ProfileScreen.routeName,
          arguments: updatedStudent,
        );
      }}
    } catch (e) {
      log("Error in callSignup: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred during signup")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final StudentModel student =
        ModalRoute.of(context)!.settings.arguments as StudentModel;
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
                  _buildTextField(
                    nameController,
                    student.name,// Initial value
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
      initialValue: initialValue, // Set the initial value
      readOnly: readOnly, // Set the readOnly property
      controller: controller,
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
