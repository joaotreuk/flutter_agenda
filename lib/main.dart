import 'package:agenda/views/inicio.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda de Contatos',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}