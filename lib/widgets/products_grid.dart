
import 'package:flutter/material.dart';

import 'product_item.dart';

import 'package:provider/provider.dart';
import 'package:shopapp/Providers/products.dart';




class ProductsGrid extends StatelessWidget {
  final bool showfavs;
  ProductsGrid(this.showfavs);

  @override
  Widget build(BuildContext context) {

final  productsData =Provider.of<Products>(context);  //listeenerrrr
final products =     showfavs ? productsData.favoriteItems: productsData.items;

    return GridView.builder(


     padding: EdgeInsets.all(15),
     itemCount: products.length,
     itemBuilder: (ctx, item) => ChangeNotifierProvider.value(
      // builder: (c)=> products[item]  ,
         value: products[item],
            child: ProductItem(    //here we use the provider as it th eplace where the fav iccon is there it the root 
         //products[item].id,
           //products[item].title, 
           //products[item].imageUrl
           ),
     ),
     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: 2,
         childAspectRatio: 3/4,
         crossAxisSpacing: 10,
         mainAxisSpacing: 10),
      );
  }
}