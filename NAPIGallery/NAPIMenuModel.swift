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
}

struct NAPIMenuItem: Codable, Equatable, Identifiable, Hashable {
    let title: String
    let description: String
    let targetType: NAPIMenuTargetType
    var id = UUID()
}


#if DEBUG
extension NAPIMenuItem {
    static let mockedData: [NAPIMenuItem] = [
        NAPIMenuItem(title: "Hobbit", description: "One of the first works of J.R.R Tolkien.", targetType: .apod),
        NAPIMenuItem(title: "About", description: "Something about this app", targetType: .about)
    ]
}
#endif
