import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyModel extends ChangeNotifier {
  bool isLoading = false;
  String? email;
  String? name;
  String? discription;

  void startLoading(){
    isLoading = true;
    notifyListeners();
  }

  void endLoading(){
    isLoading = false;
    notifyListeners();
  }

  void fetchUser() async{
    final user = FirebaseAuth.instance.currentUser;
    email = user?.email;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    this.name = data?['name'];
    this.discription = data?['discription'];

    notifyListeners();
  }

  Future logOut() async{
    await FirebaseAuth.instance.signOut();
  }
}