import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyModel extends ChangeNotifier {
  bool isLoading = false;
  String? email;

  void startLoading(){
    isLoading = true;
    notifyListeners();
  }

  void endLoading(){
    isLoading = false;
    notifyListeners();
  }

  void fetchUser(){
    final user = FirebaseAuth.instance.currentUser;
    email = user?.email;
    notifyListeners();
  }
}