//
//  RoverImageModel.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 4/2/21.
//

import Foundation

///
/// Represents the camer information that is tied to a particular Rover
/// There are multiple cameras per rover
///
struct RoverCameraModel: Codable, Identifiable {
    let id: Int
    let name: String
    let roverId: Int
    let fullName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case roverId = "rover_id"
        case fullName = "full_name"
    }
    
    init() {
        id = -1
        name = ""
        roverId = -1
        fullName = ""
    }
}

///
/// Represents a smaller manifest of the Rover itself.
///
struct RoverMiniManifestModel: Codable, Identifiable {
    let id: Int
    let name: String
    let landingDate: String
    let launchDate: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
    }
    
    init() {
        id = -1
        name = ""
        landingDate = NAPIDateSelectionView.displayDate(Date())
        launchDate = NAPIDateSelectionView.displayDate(Date())
        status = "unknown"
    }
}

///
/// The main structure containing the image of a given camera
/// on a given rover for a givel Martian Sol or Earth Date
///
struct RoverImageDataModel: Codable, Identifiable {
    let id: Int
    let sol: Int
    let camera: RoverCameraModel
    let imageUrlString: String
    let earthDate: String
    let rover: RoverMiniManifestModel
    
    enum CodingKeys: String, CodingKey {
        case id
        case sol
        case camera
        case imageUrlString = "img_src"
        case earthDate = "earth_date"
        case rover
    }
    
    init() {
        id = -1
        sol = 0
        camera = RoverCameraModel()
        imageUrlString = ""
        earthDate = "1970-01-01"
        rover = RoverMiniManifestModel()
    }
}

struct RoverPhotosModel: Codable, Identifiable {
    let photos: [RoverImageDataModel]?
    let latestPhotos: [RoverImageDataModel]?
    var id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case photos
        case latestPhotos = "latest_photos"
    }
    
    init() {
        photos = []
        latestPhotos = nil
    }
}

// MARK: -
// MARK: Sample JSON
/*
     {
      "id": 102685,
      "sol": 1004,
      "camera": {
        "id": 20,
        "name": "FHAZ",
        "rover_id": 5,
        "full_name": "Front Hazard Avoidance Camera"
      },
      "img_src": "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01004/opgs/edr/fcam/FLB_486615455EDR_F0481570FHAZ00323M_.JPG",
      "earth_date": "2015-06-03",
      "rover": {
        "id": 5,
        "name": "Curiosity",
        "landing_date": "2012-08-06",
        "launch_date": "2011-11-26",
        "status": "active"
      }
    },

 */
