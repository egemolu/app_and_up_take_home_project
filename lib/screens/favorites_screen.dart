// ignore_for_file: sized_box_for_whitespace, implementation_imports

import 'package:app_and_up_take_home_project/constants/constants.dart';
import 'package:app_and_up_take_home_project/model/book_model.dart';
import 'package:app_and_up_take_home_project/providers/book_provider.dart';
import 'package:app_and_up_take_home_project/providers/user_provider.dart';
import 'package:app_and_up_take_home_project/screens/book_details_screen.dart';
import 'package:app_and_up_take_home_project/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class FavoritesScreen extends StatefulWidget {
  double topPadding;

  FavoritesScreen(this.topPadding, {Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  FirebaseService firebaseService = FirebaseService();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    List<String> favoriteBooks = context.watch<UserProvider>().favoriteBooks;

    return Container(
      height: 16.5 * (screenHeight - widget.topPadding) / 18,
      child: favoriteBooks.isEmpty
          ? const Center(
              child: Text('No favorites yet'),
            )
          : ListView.builder(
              itemCount: favoriteBooks.length,
              itemBuilder: (context, index) {
                Book b = findBookById(favoriteBooks.elementAt(index));
                var docRef = firebaseService.users
                    .doc(context.watch<UserProvider>().uid);
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        b.title,
                        maxLines: 1,
                      ),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                BookDetailsScreen(b),
                          ),
                        );
                      },
                      trailing: GestureDetector(
                          child: const Icon(
                            Icons.highlight_remove_outlined,
                            color: mainColor,
                          ),
                          onTap: () async {
                            context
                                .read<UserProvider>()
                                .removeFavoriteBook(b.id);
                            await docRef.update({
                              'following_books': FieldValue.arrayRemove([b.id])
                            });
                          }),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
    );
  }

  Book findBookById(String id) {
    for (Book b in context.read<BookProvider>().books) {
      if (b.id == id) return b;
    }
    throw "Cannot find a book with given id";
  }
}
