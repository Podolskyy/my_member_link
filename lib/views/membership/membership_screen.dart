import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:my_member_link/models/mymembership.dart';
import 'package:my_member_link/myconfig.dart';
import 'package:my_member_link/views/shared/mydrawer.dart';
import 'package:http/http.dart' as http;
import 'membership_card.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  List<MyMembership> membershipList = [];
  late double screenWidth, screenHeight;
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
    loadMembershipData();
  }

  void loadMembershipData() {
    setState(() {
      status = "Loading...";
    });

    http
        .get(Uri.parse("${MyConfig.servername}/memberlink/api/load_membership.php"))
        .then((response) {
      log(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['memberships'];
          membershipList.clear();
          if (result.isEmpty) {
            // Show SnackBar when no memberships are available
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No data available'),
                backgroundColor: Colors.red, // Red background for error
                duration: Duration(seconds: 2), // Duration for the SnackBar
              ),
            );
          } else {
            for (var item in result) {
              MyMembership myMembership = MyMembership.fromJson(item);
              membershipList.add(myMembership);
            }
            setState(() {}); // Refresh UI with new data
          }
        } else {
          status = "No Data";
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No data available'),
              backgroundColor: Colors.red, // Red background for error
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        status = "Error loading data";
        print("Error");
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for the screen
      appBar: AppBar(
        title: const Text('Membership Screen',
            style: TextStyle(color: Colors.white)), // Set text color to white
        backgroundColor: Colors.black, // Dark app bar
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: membershipList.length,
        itemBuilder: (context, index) {
          return MembershipCard(
            membership: membershipList[index], // Ensure you're passing the correct `MyMembership` instance
            onAddToCart: (MyMembership membership) {
              // This is now a no-op since we removed cart logic
            },
          );
        },
      ),
      drawer: const MyDrawer(),
    );
  }
}
