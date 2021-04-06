//
//  RoverDetailView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 4/3/21.
//

import SwiftUI

struct RoverDetailView: View {
    
    let imageDataModel: RoverCameraImageData
    @StateObject private var loader = ImageLoader2()
    @State var showAI = true
    
    var body: some View {
        List(imageDataModel.cameraImageData) { item in
            remoteImage(urlString: item.imageUrlString)
        }
    }

    private func remoteImage(urlString: String) -> some View {
        if let image = loader.load(urlString) {
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

//struct RoverDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoverDetailView(imageDataModel: RoverImageDataModel())
//    }
//}
