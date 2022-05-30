import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';

class HomeSceen extends StatelessWidget{
  @override

  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55), 
          child: CustomAppBar())
    );
  }
}