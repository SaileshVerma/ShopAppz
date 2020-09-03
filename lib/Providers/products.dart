import 'package:flutter/material.dart';
import 'package:shopapp/models/http_exception.dart';
import './product.dart';
import 'package:http/http.dart' as http; //our http package
import 'dart:convert'; //to use json encoder to convert map to json request

class Products with ChangeNotifier {
//  here _ reprseent the priavte classs
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  var showFavouriteOnly = false;

  List<Product> get items {
    // if(showFavouriteOnly){
    //  return _items.where((prod)=>prod.isFavourite ).toList();
    // }
    //Here we  get the the copy items not the above pointer the item
    return [
      ..._items
    ]; //we use this because we have to call a function add products
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

//void showFavourite(){
  //showFavouriteOnly  = true;
  //notifyListeners();
//}
  final String authToken;
  Products(this.authToken, this._items);

//A FETCHER FUNCTION FOR FRTECHING DATA FROM THE SERVER

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://shopapp-44e3f.firebaseio.com/product.json?auth=$authToken'; //our url where we get the data

    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    final List<Product> loadedProducts = []; //this only for the temp list

    //iterating over the map using forEach

    extractedData.forEach((prodId, prodData) {
      loadedProducts.add(Product(
        id: prodId,
        title: prodData['title'],
        description: prodData['description'],
        imageUrl: prodData["imageUrl"],
        price: prodData["price"],
        isFavourite: prodData['isFavourite'],
      ));
    });

    _items = loadedProducts;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    //another error handling method
    const url = 'https://shopapp-44e3f.firebaseio.com/product.json';

    try {
      final response = await http //now here we get the response frm the future

          .post(
        url,
        body: jsonEncode({
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavourite": product.isFavourite,
        }),
      );

      //this method helps in wait for the above request to complete then it will add the product to the  item list after completion of the request
      // print(json.decode(
      //     response.body)); //this print the unique id generated on the server
      final newProduct = Product(
          id: json.decode(response.body)[
              'name'], //it give id that generates onn the response
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);

      _items.add(newProduct);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://shopapp-44e3f.firebaseio.com/product/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            "description": newProduct.description,
            "price": newProduct.price,
            "imageUrl": newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String idd) async {
    final url = 'https://shopapp-44e3f.firebaseio.com/product/$idd.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == idd);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex,
          existingProduct); //to add the product again if the sreve fails
      notifyListeners();
      throw HttpException("could not delete product");
    }
    existingProduct = null;
    // _items.removeWhere((prod) => prod.id == idd);
    // notifyListeners();
  }
}
