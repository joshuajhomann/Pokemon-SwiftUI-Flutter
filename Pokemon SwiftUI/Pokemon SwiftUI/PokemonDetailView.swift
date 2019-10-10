//
//  PokemonDetailView.swift
//  Pokemon SwiftUI
//
//  Created by Joshua Homann on 6/21/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import SwiftUI

struct PokemonDetailView : View {
  let pokemon: Pokemon
  @State var showImage = false
  var body: some View {
    ZStack  {
      RemoteImage(url: pokemon.artURL)
        .onTapGesture {
          withAnimation(.spring()) {
            self.showImage.toggle()
          }
      }
      .scaledToFill()
      .blur(radius: showImage ? 0 : 16)
      .saturation(showImage ? 1 : 0.25)
      .scaleEffect(showImage ? 0.7 : 0.33)
      .opacity(showImage ? 1 : 0.5)
      VStack {
        Text(pokemon.name)
          .font(.largeTitle)
          .fontWeight(.bold)
          .padding()
        Text(pokemon.pokemonDescription)
          .frame(width: 300)
          .lineLimit(.max)
        Spacer()
        VStack {
          Text("EVOLUTIONS:")
            .font(.subheadline)
            .bold()
            .underline()
          Text(pokemon
            .evolutions.map{ $0.to }
            .joined(separator: ", ")
          )
        }
        .padding()
        VStack {
          Text("TYPES:")
            .font(.subheadline)
            .bold()
            .underline()
          Text(pokemon
            .types
            .joined(separator: ", ")
          )
        }
        .padding()
      }
      .scaleEffect(showImage ? 1e-8 : 1)
    }
  }
}

#if DEBUG
struct PokemonDetailView_Previews : PreviewProvider {
  static var previews: some View {
    Group {
      PokemonDetailView(pokemon: Pokemon.all.first!)
        .previewDevice(PreviewDevice(stringLiteral: "iPhone SE"))
      PokemonDetailView(pokemon: Pokemon.all.first!)
        .previewDevice(PreviewDevice(stringLiteral: "iPhone XS Max"))
    }
  }
}
#endif
