//
//  NAPIGalleryApp.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/6/21.
//

import SwiftUI

@main
struct NAPIGalleryApp: App {
    @State private var alertPresenting: Bool = true
    @State private var inputText: String?
    
    private var key = NAPIKey.shared.value

    var body: some Scene {
        WindowGroup {
            NAPIMainContentView(text: $inputText)
        }
    }
}
