import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;


List<Pokemon> pokemonFromJson(String str) => new List<Pokemon>.from(json.decode(str).map((x) => Pokemon.fromJson(x)));

String pokemonToJson(List<Pokemon> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<Pokemon>> loadAllPokemon() async {
  final contents = await rootBundle.loadString('assets/pokemon.json');
  return pokemonFromJson(contents);
}

class Pokemon {

  String id;
  int pkdxId;
  int nationalId;
  String name;
  int v;
  String imageUrl;
  String description;
  String artUrl;
  List<String> types;
  List<Evolution> evolutions;

  Pokemon({
    this.id,
    this.pkdxId,
    this.nationalId,
    this.name,
    this.v,
    this.imageUrl,
    this.description,
    this.artUrl,
    this.types,
    this.evolutions,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) => new Pokemon(
    id: json["_id"],
    pkdxId: json["pkdx_id"],
    nationalId: json["national_id"],
    name: json["name"],
    v: json["__v"],
    imageUrl: json["image_url"],
    description: json["description"],
    artUrl: json["art_url"],
    types: new List<String>.from(json["types"].map((x) => x)),
    evolutions: new List<Evolution>.from(json["evolutions"].map((x) => Evolution.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "pkdx_id": pkdxId,
    "national_id": nationalId,
    "name": name,
    "__v": v,
    "image_url": imageUrl,
    "description": description,
    "art_url": artUrl,
    "types": new List<dynamic>.from(types.map((x) => x)),
    "evolutions": new List<dynamic>.from(evolutions.map((x) => x.toJson())),
  };
}

class Evolution {
  int level;
  Method method;
  String to;
  String id;

  Evolution({
    this.level,
    this.method,
    this.to,
    this.id,
  });

  factory Evolution.fromJson(Map<String, dynamic> json) => new Evolution(
    level: json["level"] == null ? null : json["level"],
    method: methodValues.map[json["method"]],
    to: json["to"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "level": level == null ? null : level,
    "method": methodValues.reverse[method],
    "to": to,
    "_id": id,
  };
}

enum Method { LEVEL_UP, OTHER, STONE, TRADE }

final methodValues = new EnumValues({
  "level_up": Method.LEVEL_UP,
  "other": Method.OTHER,
  "stone": Method.STONE,
  "trade": Method.TRADE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}