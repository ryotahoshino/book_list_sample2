import 'package:book_list_sample2/edit_profile/edit_profile_page.dart';
import 'package:book_list_sample2/mypage/my_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
      create: (_) => MyModel()..fetchUser(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("マイページ"),
          actions: [
            Consumer<MyModel>(builder: (context, model, child) {
                return IconButton(onPressed: () async {
                  //画面遷移
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(model.name!, model.discription!),
                    ),
                  );
                  model.fetchUser();
                }, icon: const Icon(Icons.edit_note));
              }
            ),
          ],
        ),
        body: Center(
          child: Consumer<MyModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(model.name ?? '名前なし',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(model.email ?? 'メールアドレス'),
                      Text(model.discription ?? '自己紹介なし'),
                      TextButton(onPressed: () async{
                        //ログアウト
                        await model.logOut();
                        Navigator.of(context).pop();
                      },
                          child: const Text('ログアウト'),
                      ),
                    ],
                  ),
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}