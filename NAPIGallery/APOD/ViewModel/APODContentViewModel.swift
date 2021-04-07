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
        return apodData.isImage()
    }

    func isVideo() -> Bool {
        return false
    }
    
    func reset() {
        apodData = APODDataModel()
    }
    
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
                DispatchQueue.main.async {
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
