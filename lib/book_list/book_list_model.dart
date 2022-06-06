import 'package:book_list_sample2/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookListModel extends ChangeNotifier {
  final _userCollection = FirebaseFirestore.instance.collection('books');

  List<Book>? books;

  void fetchBookList() async{
    final QuerySnapshot snapshot = await _userCollection.get();
    
    final List<Book> books = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String title = data['title'];
      final String author = data['author'];
      final String? imgURL = data['imgURL'];
      final String id = document.id;
      return Book(title, author, id, imgURL);
    }).toList();

      this.books = books;
      notifyListeners();
  }

  Future delete(Book book){
    return FirebaseFirestore.instance.collection('books').doc(book.id).delete();
  }
}