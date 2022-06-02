import 'package:book_list_sample2/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBookModel extends ChangeNotifier {
  String? title;
  String? author;

  Future addBook() async{
    if (title == null || title == ""){
      throw '本のタイトルが空です';
    }
    if (author == null || author!.isEmpty){
      throw '本の著者が空です';
    }

    await FirebaseFirestore.instance.collection('books').add({
      'title': title,
      'author': author,
    });
  }
}