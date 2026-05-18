import 'package:flutter/material.dart';

class TourProvider with ChangeNotifier {
  List<Map<String, dynamic>> _tours = [];

  bool _isLoading = false;

  List<Map<String, dynamic>> get tours => _tours;
  bool get isLoading => _isLoading;

  void addTour(Map<String, dynamic> tour) {
    _tours.add(tour);
    notifyListeners();
  }

  void setTours(List<Map<String, dynamic>> data) {
    _tours = data;
    notifyListeners();
  }

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
