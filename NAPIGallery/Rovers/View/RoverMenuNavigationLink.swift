//
//  RoverMenuNavigationLink.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 4/3/21.
//

import SwiftUI

///
/// Represents a menu link for navigating the various rover detail views.
///
struct RoverMenuNavigationLink: View {
    var menuItem: NAPIMenuItem
    var roverImageDataModel: RoverCameraImageData? = nil
    @State var datePopupPresented = true
    
    var body: some View {
        switch menuItem.targetType {
        case .roverOpportunity:
            NavigationLink(destination: RoverCameraListView(rover: .opportunity)) {
                NAPIMenuCell(info: menuItem)
            }
        case .roverSpirit:
            NavigationLink(destination: RoverCameraListView(rover: .spirit)) {
                NAPIMenuCell(info: menuItem)
            }
        case .roverCuriosity:
            NavigationLink(destination: RoverCameraListView(rover: .curiosity)) {
                NAPIMenuCell(info: menuItem)
            }
        case .roverPerseverance:
            NavigationLink(destination: RoverCameraListView(rover: .perseverance)) {
                NAPIMenuCell(info: menuItem)
            }
        case .roverImageDetail:
            let model = roverImageDataModel ?? RoverCameraImageData(name: "",
                                                                    description: "",
                                                                    imageData: [])
            NavigationLink(destination: RoverDetailView(cameraImageDataModel: model)) {
                NAPIMenuCell(info: menuItem)
            }

        default:
            Text("Invalid")
        }
    }
}

#if DEBUG
struct RoverMenuNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        RoverMenuNavigationLink(menuItem: NAPIMenuItem(title: "Opportunity",
                                                       description: "Mars Exploration Rover – B (Oppy)",
                                                       imageName: "Rover_Opportunity_Small",
                                                       targetType: .roverOpportunity))
    }
}
#endif
