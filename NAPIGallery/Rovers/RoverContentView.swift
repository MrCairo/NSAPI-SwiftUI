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
    NAPIMenuItem(title: "Sprit",
                 description: "Mars Exploration Rover – A",
                 imageName: "Rover_Spirit_Icon",
                 targetType: .roverSpirit),
    NAPIMenuItem(title: "Opportunity",
                 description: "Mars Exploration Rover – B (Oppy)",
                 imageName: "Rover_Opportunity_Icon",
                 targetType: .roverOpportunity),
    NAPIMenuItem(title: "Curiosity",
                 description: "Mars Curiosity Rover",
                 imageName: "Rover_Curiosity_Icon",
                 targetType: .roverCuriosity),
    NAPIMenuItem(title: "Perseverance",
                 description: "Mars Perseverance Rover",
                 imageName: "Rover_Perseverance_Icon",
                 targetType: .roverPerseverance)
]


#if DEBUG
struct RoverContentView_Previews: PreviewProvider {
    static var previews: some View {
        RoverContentView()
    }
}
#endif
