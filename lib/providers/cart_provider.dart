import 'package:flutter/material.dart';
import '../models/tour.dart';

class CartProvider extends ChangeNotifier {
  List<Tour> items = [];

  void add(Tour t) {
    items.add(t);
    notifyListeners();
  }

  double get total =>
      items.fold(0, (sum, item) => sum + item.price);
}