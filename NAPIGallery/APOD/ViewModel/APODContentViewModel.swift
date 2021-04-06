//
//  APODContentViewModel.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/16/21.
//
import Foundation
import Combine
import UIKit

fileprivate let imageExt = ["jpg", "jpeg", "png", "gif"]

final class APODContentViewModel: NAPIService, Identifiable, ObservableObject {
    @Published private(set) var apodData = APODDataModel()
    @Published private(set) var imageData = Data()

    private var lastFetch = Date()
    private var urlRequest = URLRequest(url: URL(fileURLWithPath: "."))
    private var cancellables = Set<AnyCancellable>()
    
    var title: String {
        return apodData.title
    }
    
    var description: String {
        return apodData.explanation ?? ""
    }

    var explanation: String {
        return self.description
    }

    var url: URL? {
        return URL(string: apodData.url ?? "")
    }
    
    var hdurl: URL? {
        return URL(string: apodData.hdurl ?? "")
    }

    var copyright: String? {
        return apodData.copyright
    }

    func isImage() -> Bool {
        return apodData.isImage() && !imageData.isEmpty
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
    
    
//    private var apodDataPublisher: AnyPublisher<APODDataModel, Never> {
//        URLSession.shared.dataTaskPublisher(for: urlRequest)
//            .map(\.data)
//            .decode(
//                type: APODDataModel.self,
//                decoder: JSONDecoder()
//            )
//            .replaceError(with: APODDataModel())
//            .eraseToAnyPublisher()
//            .receive(on: DispatchQueue.main)
//            .assign(to: &$apodData)
//    }

    func fetch(queryParms: [URLQueryItem] = []) {
        urlRequest = NAPIService.getURLRequestFor(endpoint: "planetary/apod",
                                                  queryParms: queryParms)

        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(
                type: APODDataModel.self,
                decoder: JSONDecoder()
            )
            .replaceError(with: APODDataModel(asFailure: true))
            .sink { [weak self] model in
                DispatchQueue.main.sync {
                    self?.apodData = model
                }
            }
            .store(in: &cancellables)
    }
    
    init(queryParms: [URLQueryItem] = []) {
        lastFetch = Date()
        self.urlRequest = NAPIService.getURLRequestFor(endpoint: "planetary/apod",
                                                       queryParms: queryParms)
    }
}

//class APODService: NAPIService, ObservableObject {
//    @Published private(set) var apodData: APODDataModel = APODDataModel()
//
//    func serviceData(queryItems: [URLQueryItem] = []) -> Bool { // -> AnyPublisher<APODDataModel, NAPIServiceError> {
//        guard let request = NAPIService.getURLRequestFor(endpoint: "planetary/apod",
//                                                         queryParms: queryItems) else {
//            return false
//        }
//
//        URLSession.shared.dataTaskPublisher(for: request)
//            .map(\.data)
//            .decode(
//                type: APODDataModel.self,
//                decoder: JSONDecoder()
//            )
//            .replaceError(with: APODDataModel())
//            .eraseToAnyPublisher()
//            .receive(on: DispatchQueue.main)
//            .assign(to: &$apodData)
//        
//        return true
//    }
//}
//
