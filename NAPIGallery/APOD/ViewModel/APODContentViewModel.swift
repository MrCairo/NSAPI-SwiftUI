//
//  APODContentViewModel.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/16/21.
//
import Foundation
import Combine
import UIKit

let imageExt = ["jpg", "jpeg", "png", "gif"]

final class APODContentViewModel: Identifiable, ObservableObject {
    @Published private(set) var apodData = APODDataModel()
    @Published private(set) var imageData = Data()

    private(set) var service: APODService = APODService()
    private var lastFetch = Date()
    
    var title: String {
        return service.apodData.title
    }
    
    var description: String {
        return service.apodData.description
    }

    var url: URL? {
        return service.apodData.url
    }

    var copyright: String? {
        return service.apodData.copyright
    }

    func isImage() -> Bool {
        return service.apodData.mediaType == "image" && !imageData.isEmpty
    }

    func uiImage() -> UIImage? {
        if !imageData.isEmpty {
            return UIImage(data: imageData)
        }

        //
        // At this point, image information from APOD is represented by
        // a URL to an image file rather than raw image data (or base64 data)
        //
        guard let url = url, let scheme = url.scheme else { return nil }
        guard imageExt.contains(url.pathExtension) else { return nil }

        imageData = Data()
        if scheme == "http" || scheme == "file" {
            if let data = try? Data(contentsOf: url) {
                imageData = data
            }
        }

        return UIImage(data: imageData)
    }

    func isVideo() -> Bool {
        return false
    }
    
    func fetch(queryParms: [URLQueryItem] = []) {
        let _ = service.$apodData
            .sink { _ in
                self.apodData = self.service.apodData
            }
        _ = service.serviceData(queryItems: queryParms)
    }

    init(queryParms: [URLQueryItem] = []) {
        lastFetch = Date()
        self.fetch(queryParms: queryParms)
    }
}

class APODService: NAPIService, ObservableObject {
    @Published private(set) var apodData: APODDataModel = APODDataModel()

    func serviceData(queryItems: [URLQueryItem] = []) -> Bool { // -> AnyPublisher<APODDataModel, NAPIServiceError> {
        guard let request = NAPIService.getURLRequestFor(endpoint: "planetary/apod",
                                                         queryParms: queryItems) else {
            return false
        }

        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(
                type: APODDataModel.self,
                decoder: JSONDecoder()
            )
            .replaceError(with: APODDataModel())
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$apodData)
        
        return true
    }
}

