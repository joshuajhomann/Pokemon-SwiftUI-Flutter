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
  func search(term: String) {
    guard !term.isEmpty else {
      return pokemon = Pokemon.all
    }
    pokemon = Pokemon.all.filter { $0.name.contains(term)}
  }
}

struct PokemonListView: View {
  @ObservedObject var pokemonListModel: PokemonListModel
  private let searchText: Binding<String>
  init(pokemonListModel: PokemonListModel) {
    self.pokemonListModel = pokemonListModel
    searchText = Binding<String>(
      get: { "" },
      set: { pokemonListModel.search(term: $0) }
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
    .navigationViewStyle(DoubleColumnNavigationViewStyle())
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
      .padding(8)
      .background(Color.accentColor)
      .foregroundColor(Color.white)
      .cornerRadius(4)
    }
    .padding()
  }
}

struct PokemonRow : View {
  @Environment (\.colorScheme) var scheme
  let pokemon: Pokemon
  var body: some View {
    NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
      HStack(alignment: .top) {
        RemoteImage(url: pokemon.artURL)
          .scaledToFill()
          .frame(width: 80, height: 80)
          .background(scheme == .dark ?  Color(white: 0.10) : Color(white: 0.90))
          .cornerRadius(16)
        VStack(alignment: .leading)  {
          Text(pokemon.name)
            .font(.headline)
          Text(pokemon.pokemonDescription)
            .font(.body)
        }
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
