import 'package:app_and_up_take_home_project/model/book_model.dart';
import 'package:flutter/material.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];

  get books => _books;

  set books(value) => _books = value;

  void addBook(Book b) {
    _books.add(b);
    notifyListeners();
  }

  void removeBook(Book b) {
    _books.remove(b);
    notifyListeners();
  }
}
