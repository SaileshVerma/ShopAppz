import 'package:flutter/cupertino.dart';

class CartItem {
  //model for cart class

  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
//here my key is th e product id;
  Map<String, CartItem> _item = {};

  Map<String, CartItem> get item {
    //this our geetter

    return {..._item};
  }

  //  NOTE   GETTERS DO NOT REQ A PARNTHERSIS()
  int get itemCount {
    return _item.length;
  }

  double get totalAmount {
    var total = 0.0;
    _item.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_item.containsKey(productId)) {
      _item.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price));
    } else {
      _item.putIfAbsent(
          productId, // this fuction executes when there is item already present
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _item.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String prodid) {
    if (!_item.containsKey(prodid)) {
      return;
    }

    if (_item[prodid].quantity > 1) {
      _item.update(
          prodid,
          (exiistingCartItem) => CartItem(
              id: exiistingCartItem.id,
              title: exiistingCartItem.id,
              quantity: exiistingCartItem.quantity - 1,
              price: exiistingCartItem.price));
    } else {
      _item.remove(prodid);
    }
    notifyListeners();
  }

  void clear() {
    _item = {};
    notifyListeners();
  }
}
