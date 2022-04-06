import 'package:flutter/material.dart';

class GlobalsStyles {
  var colorTextForte = Colors.grey[900];
  var colorTextMedio = Colors.grey[700];
  var colorTextFraco = Colors.grey[500];
  
  var colorPrimary = Colors.deepPurple;
  var colorBackground = Colors.white;

  //Tamanhos
  double sizeTitle = 20;
  double sizeSubTitle = 18;
  double sizeText = 14;

}

class GlobalsWidgets {
  sombreado() {
    return const BoxShadow(
      color: Colors.black12,
      blurRadius: 15.0, // has the effect of softening the shadow
      spreadRadius: 0.2, // has the effect of extending the shadow
      offset: Offset(
        4.0, // horizontal, move right 10
        4.0, // vertical, move down 10
      ),
    );
  }
}
