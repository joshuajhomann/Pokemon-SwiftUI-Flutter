//
//  ContentView.swift
//  Pokemon SwiftUI
//
//  Created by Joshua Homann on 6/19/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import SwiftUI
import Combine

class PokemonListModel: ObservableObject {
  @Published var pokemon: [Pokemon] = Pokemon.all
  var searchTerm: CurrentValueSubject<String, Never> = .init("")
  private var searchSubscription: AnyCancellable?
  init () {
    searchSubscription = searchTerm
      .map { term -> [Pokemon]  in
        guard !term.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
          return Pokemon.all
        }
        return Pokemon.all.filter { $0.name.contains(term) }
      }
      .assign(to: \.pokemon, on: self)
  }
}

struct PokemonListView : View {
  @ObservedObject var pokemonListModel: PokemonListModel
  private let searchText: Binding<String>
  init(pokemonListModel: PokemonListModel) {
    self.pokemonListModel = pokemonListModel
    searchText = Binding<String>(
      get: {""},
      set: { term in pokemonListModel.searchTerm.value = term }
    )
  }
  var body: some View {
    NavigationView {
      VStack {
        SearchBar(text: searchText)
        List(pokemonListModel.pokemon, id: \.name) { pokemon in
          PokemonRow(pokemon: pokemon)
        }
      }
      .navigationBarTitle(Text("Pokemon"))
    }
  }
}

struct SearchBar : View {
  @Binding var text: String
  var body: some View {
    HStack {
        Image(systemName: "magnifyingglass")
        TextField("Pokemon Search...", text: $text)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        Button(action: { self.text = "" }) {
          Text("Clear")
        }
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        .background(Color.accentColor)
        .foregroundColor(Color.white)
        .cornerRadius(4)
      }
      .padding(EdgeInsets(top: 8, leading: 12, bottom: 0, trailing: 12))
  }
}

struct PokemonRow : View {
  let pokemon: Pokemon
  var body: some View {
    NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
      VStack(alignment: .center)  {
        Text(pokemon.name)
          .font(.headline)
        HStack(alignment: .top) {
          RemoteImage(url: pokemon.artURL)
            .scaledToFill()
            .frame(width: 80, height: 80)
            .background(Color(white: 0.90))
            .cornerRadius(16)
          Text(pokemon.pokemonDescription)
            .lineLimit(.max)
            .font(.footnote)
        }.frame(minHeight: 150)
      }
    }
  }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    Group {
      PokemonListView(pokemonListModel: PokemonListModel())
        .previewDevice(PreviewDevice(stringLiteral: "iPhone SE"))
      PokemonListView(pokemonListModel: PokemonListModel())
        .previewDevice(PreviewDevice(stringLiteral: "iPhone XS Max"))
        .colorScheme(.dark)
    }
  }
}
#endif
