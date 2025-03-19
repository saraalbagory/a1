import 'package:a1/models/student_model.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "ProfileScreen";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final StudentModel student =
        ModalRoute.of(context)!.settings.arguments as StudentModel;
    return Text(student.studentID);
  }
}
