import 'package:flutter/material.dart';
import 'package:my_member_link/views/product/product_screen.dart';
import 'package:my_member_link/views/newsletter/main_screen.dart';
class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
                // You can add color or other styling here if needed
                ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            onTap: () {
              // Define onTap actions here if needed
              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const MainScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0); // Slide in from the right
                    const end = Offset.zero;
                    const curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );

            },
            title: const Text("Newsletter"),
          ),
          const ListTile(
            title: const Text("Events"),
              // Define onTap actions here if needed
          ),
          const ListTile(
            title: Text("Members"),
          ),
          const ListTile(
            title: Text("Payment"),
          ),
          ListTile(
            title: Text("Product"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const ProductScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0); // Slide in from the right
                    const end = Offset.zero;
                    const curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );

             },
          ),
          const ListTile(
            title: Text("Vetting"),
          ),
          const ListTile(
            title: Text("Settings"),
          ),
        ],
      ),
    );
  }
}