import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:my_member_link/models/myproduct.dart';
import 'package:my_member_link/myconfig.dart';
import 'package:my_member_link/views/newsletter/main_screen.dart';
import 'package:my_member_link/views/shared/mydrawer.dart';
import 'package:http/http.dart' as http;
import 'product_card.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<MyProduct> productsList = [];
  late double screenWidth, screenHeight;
  String status = "Loading...";
  int currentPage = 1;
  int totalPages = 1;

  // Cart variables
  int cartItemCount = 0; // Tracks number of items in the cart

  @override
  void initState() {
    super.initState();
    loadProductsData(currentPage);
  }

 void loadProductsData(int page) {
  setState(() {
    status = "Loading...";
  });

  http
      .get(Uri.parse(
          "${MyConfig.servername}/memberlink/api/load_products.php?pageno=$page"))
      .then((response) {
    log(response.body.toString());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "success") {
        var result = data['data']['products'];
        totalPages = data['numofpage'];
        productsList.clear();
        if (result.isEmpty) {
          // Show SnackBar when no products are available
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No data available'),
              backgroundColor: Colors.red, // Red background for error
              duration: Duration(seconds: 2), // Duration for the SnackBar
            ),
          );
        } else {
          for (var item in result) {
            MyProduct myproduct = MyProduct.fromJson(item);
            productsList.add(myproduct);
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
      setState(() {});
    }
  });
}

  // Callback to update the cart when items are added
  void onAddToCart(MyProduct updatedProduct, int quantityAdded) {
    setState(() {
      cartItemCount += quantityAdded; // Increase cart item count
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for the screen
      appBar: AppBar(
        title: const Text('Product Screen', style: TextStyle(color: Colors.white)), // Set text color to white
        backgroundColor: Colors.black, // Dark app bar
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: productsList.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: productsList[index],
                  onAddToCart: onAddToCart, // Pass the callback function here
                );
              },
            ),
          ),
          // Pagination controls
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalPages, (index) {
                int pageNum = index + 1;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      loadProductsData(pageNum);
                      setState(() {
                        currentPage = pageNum;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: pageNum == currentPage
                            ? Colors.greenAccent
                            : Colors.grey[800], // Minimal color for other pages
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          '$pageNum',
                          style: TextStyle(
                            color: pageNum == currentPage
                                ? Colors.white
                                : Colors.grey[400], // Lighter color for inactive pages
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (content) => const MainScreen()),
          );
        },
        tooltip: 'View Cart',
        backgroundColor: Colors.grey[800], // Dark color for FAB
        child: Stack(
          clipBehavior: Clip.none, // Allows overflow
          children: [
            const Icon(Icons.shopping_cart, color: Colors.white),
            if (cartItemCount > 0)
              Positioned(
                right: -20,
                top: -20,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.greenAccent,
                  child: Text(
                    '$cartItemCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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
