//import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

//import 'package:a1/database_services/local_database_service.dart';
import 'package:a1/database_services/repositry.dart';
import 'package:a1/models/sign_in_credentials.dart';
import 'package:a1/models/student_model.dart';
import 'package:a1/view/profile_screen.dart';
import 'package:a1/view/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});
  static const String routeName = "Sign In screen";
  final Repository repo = Repository();

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController studentIDController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    studentIDController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StudentModel? student;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffb51837), Color(0xff661c3a), Color(0xff301939)],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          spacing: 25.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hello",
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w700,
                fontSize: 26.r,
              ),
            ),
            // IconButton(onPressed: ()=>{
            //   Navigator.pop(context)
            // },padding: EdgeInsets.symmetric(vertical: 30.h,horizontal: 25.w),
            //  icon: Icon(Icons.arrow_back,color: Colors.white,size: 24.r,)),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 25.w),
              child: Text(
                "Sign In",
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w700,
                  fontSize: 26.r,
                ),
              ),
            ),

            Expanded(
              child: Container(
                // margin: EdgeInsets.symmetric(horizontal: 25.w),
                padding: EdgeInsets.only(top: 75.h, left: 20.w, right: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 15.h,
                      children: [
                        TextFormField(
                          controller: studentIDController,
                          // key: _formKey,
                          decoration: InputDecoration(
                            labelText: "Student ID",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            suffixIcon: Icon(Icons.person),
                          ),
                        ),
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) return "Password is required";
                            if (value.length < 8 ||
                                !value.contains(RegExp(r'\d'))) {
                              return "Password must be 8+ chars and contain a number";
                            }
                            return null;
                          },
                          // key: _formKey,
                          decoration: InputDecoration(
                            labelText: "password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            suffixIcon: Icon(Icons.password),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap:
                              () async => {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate())
                                  {
                                    student = await widget.repo.signIn(
                                      SignInCredentials(
                                        studentId:
                                            studentIDController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                      ),
                                    ),
                                    if (student != null)
                                      {
                                        print("student found"),
                                        if (student!.password !=
                                            passwordController.text.trim())
                                          {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text("wrong password"),
                                              ),
                                            ),
                                          }
                                        else
                                          {
                                            print(student),
                                            Navigator.popAndPushNamed(
                                              context,
                                              ProfileScreen.routeName,
                                              arguments: student,
                                            ),
                                          },
                                      },
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Invalid credentials'),
                                      ),
                                    ),
                                  },

                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(
                                //     content: Text('Processing Data'),
                                //   ),
                                // ),
                              },

                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            width: double.infinity,
                            height: 55.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xffb51837),
                                  Color(0xff661c3a),
                                  Color(0xff301939),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "SIGN IN",
                                style: TextStyle(
                                  fontSize: 20.r,
                                  color: Color.fromARGB(255, 249, 248, 249),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).popAndPushNamed(SignUpView.routeName);
                            },
                            child: Text(
                              "dont have an account? sign up",
                              style: TextStyle(
                                fontSize: 12.r,
                                color: Color(0xff301939),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
