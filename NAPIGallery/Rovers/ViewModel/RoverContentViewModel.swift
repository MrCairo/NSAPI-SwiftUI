//
//  RoverContentViewModel.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 4/3/21.
//

import Foundation
import Combine
import UIKit

fileprivate let imageExt = ["jpg", "jpeg", "png", "gif"]

public enum RoverType: String {
    case opportunity, spirit, curiosity, perseverance
}

struct RoverCameraImageData: Identifiable {
    let cameraName: String
    let cameraImageData: [RoverImageDataModel]
    let id = UUID()
}

final class RoverContentViewModel: NAPIService, Identifiable, ObservableObject {
    public private(set) var roverType: RoverType
    public private(set) var aggregate = [RoverCameraImageData]()
    @Published private(set) var model = RoverPhotosModel()

    private let queryParms: [URLQueryItem]
    private var lastFetch = Date()
    private var cancellables = Set<AnyCancellable>()
    
    public func update(roverType type: RoverType) {
        roverType = type
    }
    
    func fetch(queryParms: [URLQueryItem] = []) -> Bool {
        //
        // If there is an earth_date or sol included in the queryParms, it's not
        // going to be the latest but a query based upon the earth date or sol.
        // This has an impact on the last path component of the URL
        //
        let period = queryParms.firstIndex { (item) -> Bool in
            return item.name == "earth_date" || item.name == "sol"
        }

        // Was a period specified?
        let finalPath = (period != nil) ? "photos" : "latest_photos"
        let endpoint = "mars-photos/api/v1/rovers/\(roverType.rawValue)/\(finalPath)"
        print("Rover Query: \(endpoint)")
        let request = NAPIService.getURLRequestFor(endpoint: endpoint,
                                                   queryParms: queryParms)

        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(
                type: RoverPhotosModel.self,
                decoder: JSONDecoder()
            )
            .replaceError(with: RoverPhotosModel())
            .sink { [weak self] model in
                DispatchQueue.main.sync {
                    self?.model = model
                    self?.aggregateModel()
                }
            }
            .store(in: &cancellables)
        
        return true
    }
    
    func aggregateModel() {
        var cameraName: String = ""
        let mainArray = model.latestPhotos ?? model.photos
        var imageDataArray = [RoverImageDataModel]()
        aggregate.removeAll()
        
        cameraName = mainArray?.first?.camera.fullName ?? ""
        mainArray?.forEach({ (imageModel) in
            if cameraName != imageModel.camera.fullName {
                if imageDataArray.count > 0 {
                    aggregate.append(RoverCameraImageData(cameraName: cameraName,
                                                          cameraImageData: imageDataArray))
                }
                imageDataArray = [RoverImageDataModel]()
                cameraName = imageModel.camera.fullName
            }
            imageDataArray.append(imageModel)
        })
        if imageDataArray.count > 0 {
            aggregate.append(RoverCameraImageData(cameraName: cameraName,
                                                  cameraImageData: imageDataArray))
        }
    }


    init(queryParms: [URLQueryItem] = [], roverType: RoverType? = .opportunity) {
        self.queryParms = queryParms
        self.roverType = roverType ?? .opportunity
        lastFetch = Date()
    }
}
