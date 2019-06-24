import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/subjects.dart';
import 'pokemonListBloc.dart';
import 'pokemon.dart';
import 'pokemonDetailPage.dart';

class PokemonSearchPage extends StatelessWidget {
  final _bloc = PokemonListBloc();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Pokemon"),
        ),
        child: SafeArea(
            bottom: false,
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(children: [
                  SearchBar(_bloc.searchTerm),
                  StreamBuilder(
                      stream: _bloc.pokemon,
                      initialData: List<Pokemon>(0),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? Expanded(child: PokemonList(snapshot.data))
                            : CupertinoActivityIndicator(
                          animating: true,
                        );
                      })
                ]))));
  }
}

class PokemonList extends StatelessWidget {
  final List<Pokemon> _pokemon;

  PokemonList(this._pokemon);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _pokemon.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
              return PokemonDetailPage(_pokemon[index]);
            }));
          },
          child: Card(
            key: Key(_pokemon[index].id),
            elevation: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(_pokemon[index].name,
                    style: Theme.of(context).textTheme.title),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                              width: 64,
                              height: 64,
                              child: Image.network(_pokemon[index].artUrl,
                                  fit: BoxFit.contain)),
                          Expanded(
                              child: Text(_pokemon[index].description,
                                  style: Theme.of(context).textTheme.body1)),
                        ]))
              ],
            ),
          ));
        });
  }
}

class SearchBar extends StatelessWidget {
  final _textController = TextEditingController();
  final BehaviorSubject<String> _searchTerm;

  SearchBar(this._searchTerm);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        Icons.search,
        color: Colors.black54,
        size: 30.0,
      ),
      Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: CupertinoTextField(
                onChanged: (text) {
                  _searchTerm.value = text;
                },
                controller: _textController,
                placeholder: "Search for Pokemon"),
          )),
      CupertinoButton(
          onPressed: () {
            _textController.clear();
          },
          padding: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
          color: Colors.blueAccent,
          child: Text("Clear"))
    ]);
  }
}