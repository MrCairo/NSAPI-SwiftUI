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
                 description: "Mars Exploration Rover – A",
                 imageName: "Rover_Spirit_Small",
                 targetType: .roverCuriosity)
]


#if DEBUG
struct RoverContentView_Previews: PreviewProvider {
    static var previews: some View {
        RoverContentView()
    }
}
#endif


/*
 Possible other navigation using icons instead.
 
 //        VStack(alignment: .center) {
//            Button("Opportunity", action: {
//            })
//            Image("Rover_Opportunity_Small")
//            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
//            .foregroundColor(.blue)
//            HStack(alignment: .center, spacing: 10) {
//                Spacer()
//                Button("Spirit", action: {
//                })
//                Image("Rover_Opportunity_Small")
//                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
//                .foregroundColor(.blue)
//                Spacer()
//                Button("Rover 2", action: {
//                })
//                Image("Rover_Opportunity_Small")
//                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
//                .foregroundColor(.blue)
//                Spacer()
//            }
//            Button("Rover 3", action: {
//            })
//            Image("Rover_Opportunity_Small")
//            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
//            .foregroundColor(.blue)
//        }

 */
