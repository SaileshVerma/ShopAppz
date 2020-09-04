import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/order_screen.dart';
import 'package:shopapp/screens/user_product_screen.dart';
import 'package:shopapp/Providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friends Chai Pilo'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Shop'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.payment),
              title: Text('Orders'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.edit),
              title: Text('ManageProducts'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductScreen.routeName);
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('LogOut'),
              onTap: () {
                Navigator.of(context).pop();

                Provider.of<Auth>(context, listen: false).logOut();
              }),
        ],
      ),
    );
  }
}
