import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'pokemonSearchPage.dart';

void main() => runApp(PokemonApp());

class PokemonApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Pokemon Flutter',
      home: PokemonSearchPage(),
    );
  }
}

