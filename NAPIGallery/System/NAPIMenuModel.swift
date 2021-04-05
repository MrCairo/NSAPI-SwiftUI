//
//  NAPIMenuModel.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/6/21.
//

import SwiftUI

enum NAPIMenuTargetType: Int, Codable {
    case about
    case apod
    case rovers
    case roverOpportunity
    case roverSpirit
    case roverCuriosity
    case roverImageDetail
}

struct NAPIMenuItem: Codable, Equatable, Identifiable, Hashable {
    let title: String
    let description: String
    let imageName: String?
    let targetType: NAPIMenuTargetType
    var id = UUID()
    
    init(title: String, description: String = "", imageName: String? = nil, targetType: NAPIMenuTargetType) {
        self.title = title
        self.description = description
        self.imageName = imageName
        self.targetType = targetType
    }
}


#if DEBUG
extension NAPIMenuItem {
    static let mockedData: [NAPIMenuItem] = [
        NAPIMenuItem(title: "Hobbit", description: "One of the first works of J.R.R Tolkien.", targetType: .apod),
        NAPIMenuItem(title: "About", description: "Something about this app", targetType: .about),
        NAPIMenuItem(title: "Opportunity",
                     description: "Mars Exploration Rover – B (Oppy)",
                     imageName: "Rover_Opportunity_Small",
                     targetType: .roverOpportunity)
    ]
}
#endif
