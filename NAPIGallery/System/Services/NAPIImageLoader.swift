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
private struct CachedImage {
    let image: UIImage
    let date = Date()
    let id = UUID()

    var age: TimeInterval {
        return Date().timeIntervalSince(date)
    }
}

private class ImageCache {
    static public let shared = ImageCache()
    private var cache: [String: CachedImage] = [:]
    private var queue = DispatchQueue(label: "ImageCache_SyncQueue")
    private var collector: CacheCollectorTimer = CacheCollectorTimer(timeInterval: 5.0)
    private let cacheMaxAge: TimeInterval = 3600.0
    
    public func store(cachedImage: CachedImage, identifiedBy: String) {
        collector.suspend()
        queue.sync {
            if self.cache[identifiedBy] == nil {
                self.cache[identifiedBy] = cachedImage
            }
        }
        collector.resume()
    }
    
    public func cachedImage(identifiedBy: String) -> CachedImage? {
        var image: CachedImage? = nil
        collector.suspend()
        queue.sync {
            let found = cache.first { (arg0) -> Bool in
                let (key, _) = arg0; return key == identifiedBy
            }
            image = found?.value
        }
        collector.resume()
        return image
    }
    
    public func removeCachedImage(identifiedBy: String) -> Bool {
        var removed = false
        collector.suspend()
        queue.sync {
            removed = (cache.removeValue(forKey: identifiedBy) != nil)
        }
        collector.resume()
        return removed
    }
    
    fileprivate func cleanupCache() {
        if !cache.isEmpty {
            cache = cache.filter({ (element) -> Bool in
                return element.value.age < cacheMaxAge
            })
        }
    }
    
    private init() {
        collector.eventHandler = cleanupCache
        collector.resume()
    }
}

///
/// Loads an image and retrurns is by way of the @ObservableObject protocol.
/// The image is cached for performance and only refreshed after 3600 seconds.
///
class NAPIImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
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
        if let stored = ImageCache.shared.cachedImage(identifiedBy: urlString) {
            return stored.image
        }
        
        guard let url = URL(string: urlString) else { return nil }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .sink(receiveCompletion: { (_) in },
                  receiveValue: { [weak self] in
                if let img = $0 ?? self?.errorImage {
                    ImageCache.shared.store(cachedImage: CachedImage(image: img),
                                            identifiedBy: urlString)
                    self?.image = img
                }
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


/// RepeatingTimer mimics the API of DispatchSourceTimer but in a way that prevents
/// crashes that occur from calling resume multiple times on a timer that is
/// already resumed (noted by https://github.com/SiftScience/sift-ios/issues/52
private class CacheCollectorTimer {
    let timeInterval: TimeInterval
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    
    var eventHandler: (() -> Void)?
    
    private enum State {
        case suspended
        case resumed
    }
    
    private var state: State = .suspended
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
    }
    
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}
