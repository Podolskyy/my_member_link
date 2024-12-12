import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_member_link/models/news.dart';
import 'package:my_member_link/myconfig.dart';
import 'package:my_member_link/views/newsletter/edit_news.dart';
import 'package:my_member_link/views/shared/mydrawer.dart';
import 'package:my_member_link/views/newsletter/new_news.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<News> newsList = [];
  final df = DateFormat('yyyy-MM-dd hh:mm a');
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  late double screenWidth, screenHeight;
  var color;

  @override
  void initState() {
    super.initState();
    loadNewsData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          "Newsletter",
          style: TextStyle(
            color: Colors.white, // Set title text color to white
            fontSize: 20, // Optional: Change font size
            fontWeight: FontWeight.bold, // Optional: Add bold style
          ),
        ),
        actions: [
          IconButton(
            onPressed: loadNewsData,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: newsList.isEmpty
          ? const Center(
              child: Text(
                "Loading...",
                style: TextStyle(color: Colors.white),
              ),
            )
          : Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Page: $curpage / Result: $numofresult",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color(0xFF1E1E1E),
                        child: ListTile(
                          onLongPress: () => deleteDialog(index),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                truncateString(
                                    newsList[index].newsTitle.toString(), 30),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                df.format(
                                  DateTime.parse(
                                      newsList[index].newsDate.toString()),
                                ),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            truncateString(
                                newsList[index].newsTitle.toString(), 100),
                            textAlign: TextAlign.justify,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward,
                                color: Colors.white),
                            onPressed: () => showNewsDetailsDialog(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      color = (curpage - 1 == index)
                          ? Colors.deepPurple
                          : Colors.white;
                      return TextButton(
                        onPressed: () {
                          curpage = index + 1;
                          loadNewsData();
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple[700],
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (content) => const NewNewsScreen()),
          );
          loadNewsData();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String truncateString(String str, int length) {
    return str.length > length ? "${str.substring(0, length)}..." : str;
  }

  void loadNewsData() {
    http
        .get(Uri.parse(
            "${MyConfig.servername}/memberlink/api/load_news.php?pageno=$curpage"))
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['news'];
          newsList.clear();
          for (var item in result) {
            newsList.add(News.fromJson(item));
          }
          numofpage = int.tryParse(data['numofpage'].toString()) ?? 1;
          numofresult = int.tryParse(data['numberofresult'].toString()) ?? 0;
          setState(() {});
        }
      } else {
        log("Error loading data");
      }
    });
  }

  void showNewsDetailsDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(
            newsList[index].newsTitle.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            newsList[index].newsTitle.toString(),
            textAlign: TextAlign.justify,
            style: const TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (content) => EditNewsScreen(news: newsList[index]),
                  ),
                );
                loadNewsData();
              },
              child: const Text("Edit?", style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(
            "Delete \"${truncateString(newsList[index].newsTitle.toString(), 20)}\"",
            style: const TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Are you sure you want to delete this news?",
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () {
                deleteNews(index);
                Navigator.pop(context);
              },
              child: const Text("Yes", style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void deleteNews(int index) {
    http.post(
      Uri.parse("${MyConfig.servername}/memberlink/api/delete_news.php"),
      body: {"newsid": newsList[index].newsId},
    ).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("News deleted successfully"),
            backgroundColor: Colors.green,
          ));
          loadNewsData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to delete news"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
