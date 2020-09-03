import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/cart.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';

import 'package:shopapp/widgets/products_grid.dart';
import 'package:shopapp/widgets/badge.dart';
import '../Providers/products.dart';

enum FilterOption { Favourite, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showOnlyFavorite = false;
  var _isinit = true;
  var _isloading = false; //for the loadded spinnerr

//THIS THE PLACE WHERE ER SHULOD  CALL OUR FETCH FUNCTION

  @override
  void initState() {
    // Provider.of<Products>(context,listen: false).fetchAndSetProducts();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        _isloading = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isloading = false;
        });
      });
    }
    _isinit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productsConatiner  = Provider.of<Products>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("ShoppME"),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOption selectedValue) {
                setState(() {
                  if (selectedValue == FilterOption.Favourite) {
                    showOnlyFavorite = true;
                  } else {
                    showOnlyFavorite = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('favourite '),
                      value: FilterOption.Favourite,
                    ),
                    PopupMenuItem(
                      child: Text('Show All '),
                      value: FilterOption.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),

            //this the child of th e consumer  benefit is that it would not be rebuild
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                size: 24,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(showOnlyFavorite),
    );
  }
}
