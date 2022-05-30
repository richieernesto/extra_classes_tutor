import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatelessWidget{
  @override

  Widget build(BuildContext context){
    void _logout(){
      FirebaseAuth.instance.signOut();
    }
    return Scaffold(
      appBar: AppBar(title: Text("Extra Classes Tutor")),
      body: Center(
        child: ElevatedButton(
          onPressed: _logout,
          child: Text("Logout")
        )
      ),
    );
  }
}