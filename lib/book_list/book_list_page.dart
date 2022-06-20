import 'package:book_list_sample2/add_book/add_book_page.dart';
import 'package:book_list_sample2/book_list/book_list_model.dart';
import 'package:book_list_sample2/domain/book.dart';
import 'package:book_list_sample2/edit_book/edit_book_page.dart';
import 'package:book_list_sample2/login/login_page.dart';
import 'package:book_list_sample2/mypage/my_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          actions: [
            IconButton(onPressed: () async {
              //画面遷移
              if (FirebaseAuth.instance.currentUser != null){
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPage(),
                    fullscreenDialog: true,
                  ),
                );
              }else{
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                      fullscreenDialog: true,
                    ),
                );
              }

            }, icon: const Icon(Icons.person)),
          ],
        ),
        body: Center(
          child: Consumer<BookListModel>(builder: (context, model, child) {
            final List<Book>? books = model.books;

            if (books == null){
              return CircularProgressIndicator();
            }
            final List<Widget> widgets = books.map(
              (book) => Slidable(
                child: ListTile(
                  // ignore: unnecessary_null_comparison
                  leading: book.imgURL != null ? Image.network(book.imgURL!) : null,
                  title: Text(book.title),
                  subtitle: Text(book.author),
                ),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(onDismissed: () {}),
                    children: [
                      SlidableAction(
                        onPressed: (_) async{
                          await showConfirmDialog(context, book, model);
                        },
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

  Future showConfirmDialog(BuildContext context, Book book, model) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("削除の確認"),
          content: Text("「${book.title}」を削除しますか？"),
          actions: [
            TextButton(
              child: Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("はい"),
              onPressed: () async{
                await model.delete(book);
                Navigator.pop(context);
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("${book.title}を削除しました"),
                );
                model.fetchBookList();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );

  }
}