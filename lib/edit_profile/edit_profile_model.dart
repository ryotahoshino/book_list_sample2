import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileModel extends ChangeNotifier {
  EditProfileModel(this.name, this.discription) {
    nameController.text = name!;
    discriptionController.text = discription!;
  }

  final nameController = TextEditingController();
  final discriptionController = TextEditingController();

  String? name;
  String? discription;

  void setName(String name){
    this.name = name;
    notifyListeners();
  }

  void setDiscription(String discription){
    this.discription = discription;
    notifyListeners();
  }


  bool isUpdated(){
    return name != null || discription != null;
  }

  Future updateBook() async{
    this.name = nameController.text;
    this.discription = discriptionController.text;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
      'discription': discription,
    });
  }
}