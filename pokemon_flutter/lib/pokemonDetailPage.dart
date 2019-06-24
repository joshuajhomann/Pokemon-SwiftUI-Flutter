import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'pokemon.dart';
import 'package:flutter/animation.dart';

class PokemonDetailPage extends StatefulWidget {
  final Pokemon _pokemon;

  PokemonDetailPage(this._pokemon);

  @override
  _PokemonDetailPageState createState() => _PokemonDetailPageState(_pokemon);
}

class _PokemonDetailPageState extends State<PokemonDetailPage>
    with SingleTickerProviderStateMixin {
  final Pokemon _pokemon;
  var _showImage = false;
  final opacityTween = Tween(begin: 0.66, end: 1.33);
  Animation<double> _animation;
  AnimationController _animationController;

  _PokemonDetailPageState(this._pokemon);

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(milliseconds: 250), vsync: this);
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.bounceInOut);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Pokemon"),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (!_showImage) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
                _showImage = !_showImage;
              });
            },
            child:
                AnimatedPoekmonDetail(animation: _animation, pokemon: _pokemon),
          ),
        ));
  }
}

class AnimatedPoekmonDetail extends AnimatedWidget {
  static final _scaleTween = Tween<double>(begin: 0.6, end: 1.2);
  static final _opactiyTween = Tween<double>(begin: 0.25, end: 1);
  static final _blurTween = Tween<double>(begin: 5, end: 0);
  static final _textScaleTween = Tween<double>(begin: 1, end: 1e-8);

  final Pokemon pokemon;

  AnimatedPoekmonDetail({Animation<double> animation, this.pokemon})
      : super(listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Stack(children: <Widget>[
      Transform.scale(
          scale: _scaleTween.evaluate(animation),
          child: Opacity(
              opacity: _opactiyTween.evaluate(animation),
              child: Center(
                  child: Image.network(pokemon.artUrl, fit: BoxFit.none)))),
      Positioned.fill(
        child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: _blurTween.evaluate(animation),
                sigmaY: _blurTween.evaluate(animation)),
            child: Container(color: Colors.black.withAlpha(0))),
      ),
      Transform.scale(
          scale: _textScaleTween.evaluate(animation),
          child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                children: <Widget>[
                  Text(pokemon.name, style: Theme.of(context).textTheme.headline),
                  Expanded(
                      child: Text(pokemon.description,
                          style: Theme.of(context).textTheme.body1)),
                  Expanded(child: Container()),
                  Text("EVOLUTIONS", style: Theme.of(context).textTheme.subhead),
                  Text(pokemon.evolutions.map((e) => e.to).join(", "), style: Theme.of(context).textTheme.body2),
                  SizedBox(height: 40),
                  Text("TYPES", style: Theme.of(context).textTheme.subhead),
                  Text(pokemon.types.join(", "), style: Theme.of(context).textTheme.body2),
                ],
              ))),
    ]);
  }
}
