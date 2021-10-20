import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _uid = '';
  final List<String> _favoriteBooks = [];

  List<String> get favoriteBooks => _favoriteBooks;

  String get uid => _uid;

  void setUid(String province) {
    _uid = province;
    notifyListeners();
  }

  void addFavoriteBook(String bookName) {
    _favoriteBooks.add(bookName);
    notifyListeners();
  }

  void removeFavoriteBook(String bookName) {
    _favoriteBooks.remove(bookName);
    notifyListeners();
  }
}
