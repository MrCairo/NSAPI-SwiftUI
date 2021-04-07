//
//  RoverImageView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 4/6/21.
//

import SwiftUI

struct RoverImageView: View {
    public let imageUrlString: String
    @StateObject private var loader = NAPIImageLoader()
    @State private var showAI: Bool = true

    var body: some View {
        if let image = loader.load(imageUrlString) {
            return AnyView(Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit))
        } else {
            // We add this NavigationView because it takes up the entire
            // view bounds and thus can be centered properly. I'm sure there
            // is a better way of doing it...
            return AnyView(NAPIActivityIndicatorView(isShowing: $showAI) {
                List {
                    Text("")
                }
            }
            .aspectRatio(contentMode: .fit))
        }
    }    
}

struct RoverImageView_Previews: PreviewProvider {
    static var previews: some View {
        RoverImageView(imageUrlString: "")
    }
}
