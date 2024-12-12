import 'package:flutter/material.dart';
import 'package:my_member_link/models/myproduct.dart';

class ProductCard extends StatefulWidget {
  final MyProduct product;
  final Function(MyProduct, int) onAddToCart; // Callback to update cart count

  ProductCard({required this.product, required this.onAddToCart});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late int selectedQuantity;

  @override
  void initState() {
    super.initState();
    selectedQuantity = int.tryParse(widget.product.productQuantity ?? '1') ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    int productQuantity = int.tryParse(widget.product.productQuantity ?? '0') ?? 0;

    return Card(
      color: Colors.grey[900], // Dark card color
      elevation: 4.0,
      child: InkWell(
        onTap: () {
          // Open the dialog to show product details
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[850], // Dark background for dialog
              title: Text(widget.product.productName ?? 'No Name', style: TextStyle(color: Colors.white)),
              content: StatefulBuilder(
                builder: (context, setStateDialog) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.product.productPicture != null)
                        Image.asset(widget.product.productPicture!, height: 100)
                      else
                        const Icon(Icons.image_not_supported, size: 100, color: Colors.white),
                      const SizedBox(height: 10),
                      Text('Price: RM${widget.product.productPrice ?? 'N/A'}', style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),
                      Text(widget.product.productDescription ?? 'No Description Available', style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),
                      Text('Quantity Left: $productQuantity', style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),
                      
                      // Quantity Selector with Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: selectedQuantity > 1
                                ? () {
                                    setStateDialog(() {
                                      selectedQuantity--;
                                    });
                                  }
                                : null, // Disable "-" button if quantity is 1
                            icon: const Icon(Icons.remove, color: Colors.white),
                          ),
                          Text(
                            '$selectedQuantity',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: selectedQuantity < productQuantity
                                ? () {
                                    setStateDialog(() {
                                      selectedQuantity++;
                                    });
                                  }
                                : null, // Disable "+" button if quantity is at max
                            icon: const Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      ),
                      Text('Selected Quantity: $selectedQuantity', style: TextStyle(color: Colors.white)),
                    ],
                  );
                },
              ),
              actions: [
                // Add to Cart Button
                TextButton(
                  onPressed: () {
                    // Logic to add the product to the cart (e.g., update cart state)
                    print('Added $selectedQuantity of ${widget.product.productName} to cart');
                    
                    // Update the quantity after adding to the cart
                    widget.product.productQuantity = (productQuantity - selectedQuantity).toString();
                    
                    // Callback to update the cart count
                    widget.onAddToCart(widget.product, selectedQuantity);

                    // Show SnackBar with success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to cart successfully'),
                        backgroundColor: Colors.green, // Green background color
                        duration: Duration(seconds: 2), // Duration for the SnackBar
                      ),
                    );
                    
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('Add to Cart', style: TextStyle(color: Colors.white)),
                ),
                // Close Button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: widget.product.productPicture != null
                  ? Image.asset(
                      widget.product.productPicture!,
                      fit: BoxFit.cover,
                    )
                  : const Center(child: Icon(Icons.image_not_supported, color: Colors.white)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product.productName ?? 'No Name',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('\RM${widget.product.productPrice ?? 'N/A'}', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
