import 'package:a1/view/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const String routeName = "Sign In screen";

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController studentIDController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
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
                          onTap: () => {},
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
                                "SIGN UP",
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
