// ignore_for_file: sized_box_for_whitespace, implementation_imports, must_be_immutable

import 'package:app_and_up_take_home_project/constants/constants.dart';
import 'package:app_and_up_take_home_project/model/book_model.dart';
import 'package:app_and_up_take_home_project/providers/user_provider.dart';
import 'package:app_and_up_take_home_project/services/firebase_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class BookDetailsScreen extends StatefulWidget {
  Book book;
  BookDetailsScreen(this.book, {Key? key}) : super(key: key);

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  FirebaseService firebaseService = FirebaseService();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var docRef = firebaseService.users.doc(context.watch<UserProvider>().uid);
    bool isFavorite =
        context.watch<UserProvider>().favoriteBooks.contains(widget.book.id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        actions: [
          IconButton(
            onPressed: () async {
              if (isFavorite) {
                context.read<UserProvider>().removeFavoriteBook(widget.book.id);

                await docRef.update({
                  'following_books': FieldValue.arrayRemove([widget.book.id])
                });
              } else {
                context.read<UserProvider>().addFavoriteBook(widget.book.id);
                await docRef.update({
                  'following_books': FieldValue.arrayUnion([widget.book.id])
                });
              }
            },
            icon: isFavorite
                ? const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.favorite_border_outlined,
                    color: Colors.white,
                  ),
          )
        ],
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight / 18),
              Container(
                height: 5 * screenHeight / 18,
                width: screenWidth,
                child: Image.network(
                  widget.book.imageLinks['smallThumbnail'].toString(),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: screenHeight / 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.yellow[700],
                  ),
                  AutoSizeText(
                    widget.book.averageRating.toString(),
                    maxFontSize: 16,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Center(child: AutoSizeText(widget.book.title)),
              Center(
                child: AutoSizeText(
                  widget.book.author,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth / 20, right: screenWidth / 20),
                child: const Text('Description'),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth / 20, right: screenWidth / 20),
                child: Text(widget.book.description),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
