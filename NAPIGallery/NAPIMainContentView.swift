//
//  NAPIMainContentView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/6/21.
//

import SwiftUI

struct NAPIMainContentView: View {
    let menuItems = [
        NAPIMenuItem(title: "APOD", description: "Astronomical Picture of the Day", targetType: .apod),
        NAPIMenuItem(title: "About", description: "Something about this app", targetType: .about)
    ]

    var body: some View {
        NavigationView {
            List(menuItems) { item in
                NAPIMenuNavigationLink(menuItem: item)
            }
            .navigationTitle("NASA API Gallery")
            .listStyle(GroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#if DEBUG

struct NAPIMainContentView_Previews: PreviewProvider {
    static var previews: some View {
        NAPIMainContentView()
    }
}
#endif
