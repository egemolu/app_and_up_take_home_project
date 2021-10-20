// ignore_for_file: sized_box_for_whitespace, implementation_imports

import 'package:app_and_up_take_home_project/model/book_model.dart';
import 'package:app_and_up_take_home_project/providers/book_provider.dart';
import 'package:app_and_up_take_home_project/screens/book_details_screen.dart';
import 'package:app_and_up_take_home_project/services/firebase_service.dart';
import 'package:app_and_up_take_home_project/widgets/custom_sized_box.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class HomeScreen extends StatefulWidget {
  double topPadding;

  HomeScreen(this.topPadding, {Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseService firebaseService = FirebaseService();
  TextEditingController searchBoxController = TextEditingController();
  List<Book> searchResults = [];

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    List<Book> books = context.watch<BookProvider>().books;

    return Container(
      height: 16.5 * (screenHeight - widget.topPadding) / 18,
      child: Padding(
        padding:
            EdgeInsets.only(left: screenWidth / 20, right: screenWidth / 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSizedBox(0.5, screenHeight),
            Container(
              alignment: Alignment.centerLeft,
              height: 2 * screenHeight / 18,
              child: const Text(
                'Explore thousands of books on the go',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            CustomSizedBox(0.5, screenHeight),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              height: 1.5 * screenHeight / 18,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth / 20,
                      right: screenWidth / 20,
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchBoxController,
                      onChanged: (value) {
                        updateBooksList(books);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search for books...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomSizedBox(0.5, screenHeight),
            Container(
              height: screenHeight / 18,
              child: searchBoxController.text.isEmpty
                  ? const Text(
                      'Famous Books',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    )
                  : const Text(
                      'Search Results',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
            ),
            CustomSizedBox(0.25, screenHeight),
            Container(
              height: 9.35 * screenHeight / 18,
              child: ListView.builder(
                itemCount: searchBoxController.text.isEmpty
                    ? books.length
                    : searchResults.length,
                itemBuilder: (context, index) {
                  Book b = searchBoxController.text.isEmpty
                      ? books.elementAt(index)
                      : searchResults.elementAt(index);
                  return Padding(
                    padding: EdgeInsets.only(bottom: 0.5 * screenHeight / 18),
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                BookDetailsScreen(b),
                          ),
                        );
                      },
                      child: Container(
                        height: 4 * screenHeight / 18,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(screenWidth / 20),
                              child: Container(
                                width: 6 * screenWidth / 20,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Image.network(
                                  b.imageLinks["smallThumbnail"].toString(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    "by" + books.elementAt(index).author,
                                    maxFontSize: 12,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  AutoSizeText(
                                    b.title,
                                    maxFontSize: 16,
                                    maxLines: 3,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow[700],
                                      ),
                                      AutoSizeText(
                                        b.averageRating.toString(),
                                        maxFontSize: 16,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 8 * screenWidth / 20,
                                    decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                      child: AutoSizeText(
                                        b.category,
                                        maxFontSize: 12,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.blue[700],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateBooksList(List<Book> books) {
    setState(() {
      searchResults.clear();
    });

    for (Book book in books) {
      if (book.title
          .toLowerCase()
          .contains(searchBoxController.text.toLowerCase())) {
        searchResults.add(book);
      }
    }
    setState(() {});
  }
}
