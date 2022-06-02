import 'package:book_list_sample2/add_book/add_book_page.dart';
import 'package:book_list_sample2/book_list/book_list_model.dart';
import 'package:book_list_sample2/domain/book.dart';
import 'package:book_list_sample2/edit_book/edit_book_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("本一覧"),
        ),
        body: Center(
          child: Consumer<BookListModel>(builder: (context, model, child) {
            final List<Book>? books = model.books;

            if (books == null){
              return CircularProgressIndicator();
            }
            final List<Widget> widgets = books.map(
              (book) => Slidable(
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(onDismissed: () {}),
                    children: [
                      SlidableAction(
                        onPressed: null,
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: '削除',
                      ),
                      SlidableAction(
                        onPressed: (_) async{
                          final String? title = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBookPage(book),
                            ),
                          );

                          if (title != null){
                            final snackBar = SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("$titleを編集しました"),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                          model.fetchBookList();
                        },
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: '編集',
                      ),
                    ],
                ),
                child: ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                ),

              ),
            ).toList();
            return ListView(
              children: widgets,
            );
          }),
        ),
        floatingActionButton: Consumer<BookListModel>(builder: (context, model, child) {
            return FloatingActionButton(
              onPressed: () async{
                final bool? added = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddBookPage(),
                    fullscreenDialog: true,
                  ),
                );

                if (added != null && added){
                  final snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("本を追加しました"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                model.fetchBookList();
              },
              tooltip: 'Increment',
              child: Icon(Icons.add),
            );
          }
        ),
      ),
    );
  }
}