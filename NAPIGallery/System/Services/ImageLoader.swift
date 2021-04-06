//
//  ImageLoader.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/27/21.
//

import UIKit
import Combine

///
/// A simple data struct that will cache an image by a string key
///
struct CachedImage {
    let image: UIImage
    let date = Date()

    var age: TimeInterval {
        return Date().timeIntervalSince(date)
    }
}

class ImageCache {
    static public let shared = ImageCache()
    private var cache: [String: CachedImage] = [:]
    
    public func store(cachedImage: CachedImage, identifiedBy: String) -> Bool {
        if cache[identifiedBy] == nil {
            cache[identifiedBy] = cachedImage
            return true
        }
        
        return false
    }
    
    public func cachedImage(identifiedBy: String) -> CachedImage? {
        return cache[identifiedBy]
    }
    
    public func removeCachedImage(identifiedBy: String) -> Bool {
        let found = cache[identifiedBy] != nil
        if found {
            cache.removeValue(forKey: identifiedBy)
        }
        return found
    }
}

///
/// Loads an image and retrurns is by way of the @ObservableObject protocol.
/// The image is cached for performance and only refreshed after 3600 seconds.
///
class ImageLoader: ObservableObject {

    public static let shared = ImageLoader()
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    
    deinit {
        cancellable?.cancel()
    }

    private func cache(_ image: UIImage?, urlString: String) {
        if let image = image {
            _ = ImageCache.shared.store(cachedImage: CachedImage(image: image),
                                        identifiedBy: urlString)
            self.image = image
        }
    }

    ///
    /// Loads the image given a URL string
    /// - parameter urlString: The URL as a string value
    /// - returns: An optional UIImage. If the image is cached, it is returned.
    ///            If not cached a ```nil``` value will be returned but a
    ///            request will be made to fetch the image. Once it's retrieved,
    ///            the class will publish the new image. The new image is also
    ///            cached keyed by the string URL.
    ///
    /// - note: An image is cached for 3600 seconds (1 hour).
    ///
    func load(_ urlString: String) -> UIImage? {
        if let cached = ImageCache.shared.cachedImage(identifiedBy: urlString) {
            if cached.age < 3600.0 {
                if self.image == nil {
                    self.image = cached.image
                } else if self.image != cached.image {
                    self.image = cached.image
                }
                return self.image
            } else {
                _ = ImageCache.shared.removeCachedImage(identifiedBy: urlString)
            }
        }

        guard let url = URL(string: urlString) else { return nil }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .sink(receiveCompletion: { (completion) in
                print(completion)
            }, receiveValue: { [weak self] in
                let image = $0 ?? UIImage(systemName: "xmark.octagon")
                self?.cache(image, urlString: url.absoluteString)
            })
        
        return nil
    }

    func cancel() {
        cancellable?.cancel()
    }
    
    private init() {
        if let errSymbol = UIImage(systemName: "xmark.octagon") {
            _ = ImageCache.shared.store(cachedImage: CachedImage(image: errSymbol),
                                        identifiedBy: "__error")
        }
    }
}

class ImageLoader2: ObservableObject {

    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    private var cache = [String: UIImage]()
    private var errorImage: UIImage

    deinit {
        cancellable?.cancel()
    }

    ///
    /// Loads the image given a URL string
    /// - parameter urlString: The URL as a string value
    /// - returns: An optional UIImage. If the image is cached, it is returned.
    ///            If not cached a ```nil``` value will be returned but a
    ///            request will be made to fetch the image. Once it's retrieved,
    ///            the class will publish the new image. The new image is also
    ///            cached keyed by the string URL.
    ///
    /// - note: An image is cached for 3600 seconds (1 hour).
    ///
    func load(_ urlString: String) -> UIImage? {
        if let cachedImage = cache[urlString] {
            return cachedImage
        }

        guard let url = URL(string: urlString) else { return nil }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .sink(receiveCompletion: { (completion) in
                print(completion)
            }, receiveValue: { [weak self] in
                let image = $0 ?? self?.errorImage
                self?.image = image
                self?.cache[urlString] = image
            })
        
        return nil
    }

    func cancel() {
        cancellable?.cancel()
    }
    
    init() {
        errorImage = UIImage(systemName: "xmark.octagon")!
    }
}
