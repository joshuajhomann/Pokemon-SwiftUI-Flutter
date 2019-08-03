//
//  RemoteImage.swift
//  Pokemon SwiftUI
//
//  Created by Joshua Homann on 6/21/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import SwiftUI
import Combine
import UIKit

class ImageCache {
  enum ImageCacheError: Error {
    case dataConversionFailed
  }
  static let shared = ImageCache()
  private let cache = NSCache<NSURL, UIImage>()
  private init() { }
  func image(for url: URL, completion: @escaping (Result<UIImage, Error>) -> ()) {
    guard let image = cache.object(forKey: url as NSURL) else {
      URLSession.shared.dataTask(with: url) { [cache] data, _, error in
        guard let image = data.flatMap(UIImage.init(data:)) else {
          return completion(.failure(error ?? ImageCacheError.dataConversionFailed))
        }
        completion(.success(image))
        cache.setObject(image, forKey: url as NSURL)
      }.resume()
      return
    }
    completion(.success(image))
  }
}

class ImageModel: ObservableObject {
  var didChange = PassthroughSubject<Void, Never>()
  var image: UIImage?
  init(url: URL) {
    ImageCache.shared.image(for: url) { result in
      if case .success(let image) = result {
        self.image = image
        DispatchQueue.main.async {
          self.didChange.send(())
        }
      }
    }
  }
}

struct RemoteImage : View {
  @ObservedObject var imageModel: ImageModel
  init(url: URL) {
    imageModel = ImageModel(url: url)
  }
  var body: some View {
    imageModel.image.map{Image(uiImage:$0).resizable()} ?? Image(systemName: "questionmark").resizable()
  }
}

#if DEBUG
struct RemoteImage_Previews : PreviewProvider {
  static var previews: some View {
    RemoteImage(url: URL(string: "http://assets22.pokemon.com/assets/cms2/img/pokedex/full/001.png")!)
  }
}
#endif
