import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;
import "dart:convert";

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    final oldstatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();

    final url = 'https://shopapp-44e3f.firebaseio.com/product/$id.json';
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavourite': isFavourite,
        }),
      );
      if (response.statusCode >= 400) {
        isFavourite = oldstatus;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = oldstatus;
      notifyListeners();
    }
  }
}
