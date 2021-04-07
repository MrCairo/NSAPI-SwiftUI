//
//  NAPIMenuNavigationLink.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/6/21.
//

import SwiftUI

struct NAPIMenuNavigationLink: View {
    var menuItem: NAPIMenuItem
    
    var body: some View {
        switch menuItem.targetType {
        case .about:
            NavigationLink(destination: NAPIAboutContentView()) {
                NAPIMenuCell(info: menuItem)
            }
        case .apod:
            NavigationLink(destination: APODContentView()) {
                NAPIMenuCell(info: menuItem)
            }
        case .rovers:
            NavigationLink(destination: RoverContentView()) {
                NAPIMenuCell(info: menuItem)
            }
        default:
            Text("Invalid at this level")
        }
    }
}

#if DEBUG
struct NAPINavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        NAPIMenuNavigationLink(menuItem: NAPIMenuItem(title: "Hobbit",
                                                      description: "One of the first works of J.R.R Tolkien.",
                                                      targetType: .apod))
    }
}
#endif
