import 'pokemon.dart';
import 'package:rxdart/rxdart.dart';

class PokemonListBloc {
  final BehaviorSubject<String> searchTerm;
  final Observable<List<Pokemon>> pokemon;
  factory PokemonListBloc() {
    final BehaviorSubject<String> searchTerm = BehaviorSubject<String>();
    final unfilteredPokemon = Observable
        .fromFuture(loadAllPokemon());
    final pokemon = Observable
        .combineLatest2(searchTerm.stream, unfilteredPokemon, (term, pokemon) => [term, pokemon])
        .map((combined) {
          final searchTerm = (combined[0] as String).toLowerCase();
          var allPokemon = (combined[1] as List<Pokemon>);
          allPokemon.sort((l, r) => l.name.compareTo(r.name));
          final isEmpty = searchTerm.trim().isEmpty;
          return isEmpty ? allPokemon == null ? List<Pokemon>(0) : allPokemon
                         : allPokemon.where((pokemon) => pokemon.name.toLowerCase().contains(searchTerm)).toList();
    });
    searchTerm.value = "";
    return PokemonListBloc._(searchTerm, pokemon);
  }
  PokemonListBloc._(this.searchTerm, this.pokemon);
}