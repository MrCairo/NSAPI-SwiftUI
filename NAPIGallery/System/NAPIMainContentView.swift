//
//  NAPIMainContentView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/6/21.
//

import SwiftUI

public var apiKey: String = ""

struct NAPIMainContentView: View {
    @Binding var text: String? // this is updated as the user types in the text field
    @State private var alertPresenting: Bool = true
    @State private var inputText: String?
    
    let menuItems = [
        NAPIMenuItem(title: "APOD", description: "Astronomical Picture of the Day", targetType: .apod),
        NAPIMenuItem(title: "Rovers", description: "Martian Rover Imagery", targetType: .rovers),
        NAPIMenuItem(title: "About", description: "Something about this app", targetType: .about)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                NavigationView {
                    if alertPresenting {
                        NAPIKeyAlertView(isPresenting: $alertPresenting)
                    } else {
                        List(menuItems) { item in
                            NAPIMenuNavigationLink(menuItem: item)
                        }
                        .navigationTitle("NASA API Gallery")
                        .listStyle(GroupedListStyle())
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
            }
        }
    }
    
    struct NAPIKeyAlertView: View {
        @Binding var isPresenting: Bool
        
        var body: some View {
            HStack {
                Text("")
            }
            .keyTextFieldAlert(isPresented: $isPresenting) { () -> NAPIKeyPromptView in
                NAPIKeyPromptView(title: "API Key", message: "Enter your own NASA API Key")
            }
        }
    }
}

#if DEBUG

//struct NAPIMainContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        NAPIMainContentView()
//    }
//}
#endif
