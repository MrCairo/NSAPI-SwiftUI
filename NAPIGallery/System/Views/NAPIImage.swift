//
//  NAPIImage.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 4/15/21.
//

import SwiftUI

struct NAPIMagnificationImage: View {
    let uiImage: UIImage
    @GestureState var magnifyBy = CGFloat(2.0)

    var magnification: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { currentState, gestureState, transaction in
                gestureState = currentState
                print($magnifyBy)
            }
    }

    var body: some View {
        GeometryReader { geo in
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200 * magnifyBy, height: 200 * magnifyBy, alignment: .center)
                .gesture(magnification)
        }
    }
}

//struct NAPIImage_Previews: PreviewProvider {
//    static var previews: some View {
//        NAPIImage()
//    }
//}
