import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/auth.dart';
import 'package:shopapp/Providers/cart.dart';
import 'package:shopapp/Providers/orders.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/edit_product_screen.dart';

import 'package:shopapp/screens/products_deatail_screen.dart';
import 'package:shopapp/screens/products_overview_screens.dart';
import 'package:shopapp/screens/user_product_screen.dart';
import 'Providers/products.dart';
import 'package:shopapp/screens/order_screen.dart';

void main() => runApp(ShopApp());

class ShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
        // the multi_provider conatians list of the pproviders
        MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products('', [], ''),
          update: (ctx, auth, previousProduct) {
            return Products(
                auth.token,
                previousProduct == null ? [] : previousProduct.items,
                auth.userId);
          },

          // update:(ctx,auth,previousProducts) =>Products(auth.token,previousProducts==null?[]:previousProducts.items),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        // ChangeNotifierProvider.value(
        //   value: Orders(),
        // ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('', [], ''),
          update: (ctx, auth, previousProduct) {
            return Orders(
              auth.token,
              previousProduct == null ? [] : previousProduct.order,
              auth.userId,
            );
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: "ShopApp",
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.amber,
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          debugShowCheckedModeBanner: false,
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
