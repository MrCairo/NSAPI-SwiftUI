//
//  RoverModelTests.swift
//  NAPIGalleryTests
//
//  Created by Mitch Fisher on 4/3/21.
//

import XCTest
@testable import NAPIGallery

// //////////////////////////////////////////////////////////////////////////////////////////////////
//
// NOTE: Bundle decode function is an extension located in Bundle+JSONDecoder
//
// //////////////////////////////////////////////////////////////////////////////////////////////////
class RoverModelTests: XCTestCase {
    
    func testCanDecodeLatestPhotos() {
        let photoData = Bundle(for: RoverModelTests.self).decode(RoverPhotosModel.self,
                                                                 from: "RoverModelLatestPhoto.json")
        guard let latest = photoData.latestPhotos else {
            XCTFail("latest_photos should exist and have more than one element.")
            return
        }
        XCTAssert(latest.count > 0, "Invalid latest_photos count: \(latest.count)")
        if let first = latest.first {
            XCTAssert(first.id > 1, "Invalid id")
        } else {
            XCTFail()
        }
    }
    
    func testCanDecodeImageDataModel() {
        let imageData = Bundle(for: RoverModelTests.self).decode(RoverImageDataModel.self,
                                                                 from: "RoverImageDataModel.json")
        XCTAssert(imageData.id == 820369, "Invalid ImageData ID")
        XCTAssert(imageData.sol == 3078, "Invalid sol value")
        XCTAssert(imageData.camera.id == 23, "Invalid camera.id value")
        XCTAssert(imageData.camera.name == "CHEMCAM", "Invalid camera.name value")
    }
    
    func testCanDecodeCameraDataModel() {
        let cameraData = Bundle(for: RoverModelTests.self).decode(RoverCameraModel.self,
                                                                  from: "RoverCameraDataModel.json")
        XCTAssert(cameraData.id == 23, "Invalid id")
        XCTAssert(cameraData.roverId == 5, "Invalid rover_id")
        XCTAssert(cameraData.fullName == "Chemistry and Camera Complex", "Invalid full_name")
    }
}
