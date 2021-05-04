//
//  RoverInfoService.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 4/16/21.
//

import Foundation
import Combine

final class RoverInformationService: NAPIService, Identifiable, ObservableObject {
    @Published private(set) var roverInfo = RoverInformationModel()

    private var lastFetch = Date()
    private var urlRequest = URLRequest(url: URL(fileURLWithPath: "."))
    private var cancellables = Set<AnyCancellable>()
    
    
    var name: String {
        return roverInfo.name
    }
    
    var lanndingDate: String {
        return roverInfo.landing_date ?? ""
    }
    
    var launchDate: String {
        return roverInfo.launch_date ?? ""
    }
    
    var status: String {
        return roverInfo.status ?? "unknown"
    }
    
    var maxSol: Int {
        return roverInfo.max_sol ?? -1
    }
    
    var maxDate: String {
        return roverInfo.max_date ?? ""
    }
    
    var totalPhotos: Int {
        return roverInfo.total_photos ?? -1
    }
    
    var cameras: [RoverCameraModel] {
        return roverInfo.cameras
    }

    func reset() {
        roverInfo = RoverInformationModel()
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
