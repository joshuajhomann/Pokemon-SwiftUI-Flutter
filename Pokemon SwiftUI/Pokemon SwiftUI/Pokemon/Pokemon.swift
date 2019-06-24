//
//  Pokemon.swift
//  Pokemon SwiftUI
//
//  Created by Joshua Homann on 6/20/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - Pokemon
struct Pokemon: Codable {
  let id: String
  let pkdxID, nationalID: Int
  let name: String
  let v: Int
  let imageURL: URL
  let pokemonDescription: String
  let artURL: URL
  let types: [String]
  let evolutions: [Evolution]

  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case pkdxID = "pkdx_id"
    case nationalID = "national_id"
    case name
    case v = "__v"
    case imageURL = "image_url"
    case pokemonDescription = "description"
    case artURL = "art_url"
    case types, evolutions
  }
  static let all: [Pokemon] = (Bundle.main.url(forResource: "pokemon", withExtension: "json")
    .flatMap {try! Data(contentsOf: $0)}
    .flatMap {try! JSONDecoder().decode([Pokemon].self, from: $0)} ?? [])
    .sorted { $0.name < $1.name }

}

// MARK: - Evolution
struct Evolution: Codable {
  let level: Int?
  let method: Method
  let to, id: String

  enum CodingKeys: String, CodingKey {
    case level, method, to
    case id = "_id"
  }
}

enum Method: String, Codable {
  case levelUp = "level_up"
  case other = "other"
  case stone = "stone"
  case trade = "trade"
}
