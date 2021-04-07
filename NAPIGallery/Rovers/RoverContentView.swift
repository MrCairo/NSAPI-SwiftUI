//
//  RoverContentView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 4/1/21.
//

import SwiftUI

struct RoverContentView: View {
    var body: some View {
        List(menuItems) { item in
            RoverMenuNavigationLink(menuItem: item)
        }
    }
}

//
// The rover menus to display in the navigation list
//
// The rovers supported in the API are:
// Opportunity, Spirit, Curiosity, and Perseverance
//

private let menuItems = [
    NAPIMenuItem(title: "Opportunity",
                 description: "Mars Exploration Rover – B (Oppy)",
                 imageName: "Rover_Opportunity_Small",
                 targetType: .roverOpportunity),
    NAPIMenuItem(title: "Sprit",
                 description: "Mars Exploration Rover – A",
                 imageName: "Rover_Spirit_Small",
                 targetType: .roverSpirit),
    NAPIMenuItem(title: "Curiosity",
                 description: "Mars Curiosity Rover",
                 imageName: "Rover_Curiosity_Small",
                 targetType: .roverCuriosity),
    NAPIMenuItem(title: "Perseverance",
                 description: "Mars Perseverance Rover",
                 imageName: "Rover_Perseverance_Small",
                 targetType: .roverPerseverance)
]


#if DEBUG
struct RoverContentView_Previews: PreviewProvider {
    static var previews: some View {
        RoverContentView()
    }
}
#endif
