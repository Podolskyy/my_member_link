import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_member_link/myconfig.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Set a larger height
        child: AppBar(
          automaticallyImplyLeading: false, // Hide the default back button
          title: const Align(
            alignment: Alignment.center, // Align the title to the right
            child: Padding(
              padding: EdgeInsets.only(top: 20, right: 9), // Adjust position
              child: Text(
                'USER REGISTRATION',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          backgroundColor: const Color(0xFF1E1E1E),
          elevation: 0,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: namecontroller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Your Name",
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phonecontroller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Your Phone Number",
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailcontroller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Your Email",
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: true,
                controller: passwordcontroller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Your Password",
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                elevation: 0,
                onPressed: onRegisterDialog,
                minWidth: 400,
                height: 50,
                color: Colors.deepPurple[700],
                child: const Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Already registered? Login",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onRegisterDialog() {
    String name = namecontroller.text;
    String phone = phonecontroller.text;
    String email = emailcontroller.text;
    String password = passwordcontroller.text;

    if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter all the required fields"),
      ));
      return;
    }

    final RegExp emailRegExp =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

    // Check if the email is in valid format
    if (!emailRegExp.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter a valid email address"),
      ));
      return;
    }

    // Check if the password is at least 6 characters long
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password must be at least 6 characters long"),
      ));
      return;
    }

    // Regular expression to check if the phone number is valid (e.g., 10 digits)
    final RegExp phoneRegExp = RegExp(r"^\+?[0-9]{10,15}$");

    // Check if the phone number is valid
    if (!phoneRegExp.hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter a valid phone number"),
      ));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: const Text(
            "Register new account?",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Are you sure?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.deepPurple),
              ),
              onPressed: () {
                userRegistration();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void userRegistration() {
    String name = namecontroller.text;
    String phone = phonecontroller.text;
    String email = emailcontroller.text;
    String pass = passwordcontroller.text;

    // Send all the necessary fields to the server
    http.post(
      Uri.parse("${MyConfig.servername}/memberlink/api/register_user.php"),
      body: {
        "name": name, // Send the user's name
        "phoneNumber": phone, // Send the user's phone number
        "email": email, // Send the user's email
        "password": pass // Send the user's password
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Success"),
            backgroundColor: Color(0xFF121212),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
