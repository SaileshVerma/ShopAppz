import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/products_deatail_screen.dart';
import 'package:shopapp/Providers/product.dart';
import 'package:shopapp/Providers/cart.dart';

class ProductItem extends StatelessWidget {
//  final String id;
  //final String title;
  //final String imageUrl;

  //ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    //listener of the pr grid provider            // Here LISTEN FALSE will stop the building of the widget aga
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors
                .black87, //HERE WE PUT ICONBTN IN THE CONSUMER SO THAT IT WILL LISTEN THE NITIFIERS UPDATE AND WILL BUILD AGA
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                  icon: Icon(product.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () {
                    product.toggleFavoriteStatus();
                  }),
            ),
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  //here we are sending the items to the cart  which we receives through the product
                  cart.addItem(product.id, product.price, product.title);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Item added to cart"),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                        label: 'UNDO', //omly for the undo dont see u this
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ));
                }),
          ),
        ),
      ),
    );
  }
}
