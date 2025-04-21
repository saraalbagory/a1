import 'dart:developer';
import 'package:a1/models/student_model.dart';
import 'package:a1/database_services/sign_up_logic.dart';
import 'package:a1/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});
  static const String routeName = "Sign Up screen";

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController studentIDController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? gender;
  int? level;
  final _formKey = GlobalKey<FormState>();

  void callSignup() async {
    try {
      if (_formKey.currentState!.validate()) {
        StudentModel newStudent = StudentModel(
          name: nameController.text,
          email: emailController.text,
          studentID: studentIDController.text,
          password: passwordController.text,
          gender: gender,
          level: level,
        );

        log("Calling signUp...");
        String response = await signUp(newStudent);
        //TODO: IF the user registered take the new student and pass it to the new page
        log("Response received: $response");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response)));
        if (response == "Signup success") {
          Navigator.popAndPushNamed(
            context,
            ProfileScreen.routeName,
            arguments: newStudent,
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
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder:
          (_, child) => Scaffold(
            appBar: AppBar(
              title: Text("Sign Up", style: TextStyle(fontSize: 20.sp)),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          nameController,
                          "Name",
                          "Name is required",
                        ),
                        SizedBox(height: 12.h),
                        _buildTextField(
                          emailController,
                          "Email",
                          "Email is required",
                          validator: (value) {
                            if (value!.isEmpty) return "Email is required";
                            //TODO:NEED TO TRIME THE EMAIL BEFORE VALIDATION SAME FOR THE ID
                            if (!RegExp(
                              r"^[0-9]+@stud.fci-cu.edu.eg$",
                            ).hasMatch(value)) {
                              return "Invalid FCAI email format";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12.h),
                        _buildTextField(
                          studentIDController,
                          "Student ID",
                          "Student ID is required",
                        ),
                        SizedBox(height: 12.h),
                        _buildTextField(
                          passwordController,
                          "Password",
                          "Password is required",
                          isPassword: true,
                          validator: (value) {
                            if (value!.isEmpty) return "Password is required";
                            if (value.length < 8 ||
                                !value.contains(RegExp(r'\d'))) {
                              return "Password must be 8+ chars and contain a number";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12.h),
                        _buildTextField(
                          confirmPasswordController,
                          "Confirm Password",
                          "Confirm password is required",
                          isPassword: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Confirm password is required";
                            }
                            if (value != passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12.h),
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
                            onPressed: callSignup,
                            child: Text(
                              "Sign Up",
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
          ),
    );
  }

  /// Reusable TextField Widget
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String errorMessage, {
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
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
