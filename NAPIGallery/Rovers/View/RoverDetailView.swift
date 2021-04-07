//
//  RoverDetailView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 4/3/21.
//

import SwiftUI

struct RoverDetailView: View {
    let cameraImageDataModel: RoverCameraImageData
    
    var body: some View {
        ScrollView {
            RoverImageStackView(dataModel: cameraImageDataModel.imageData)
        }
    }
}

private struct RoverImageStackView: View {
    let dataModel: [RoverImageDataModel]
    
    var body: some View {
        LazyVStack {
            ForEach(0..<dataModel.count, id: \.self) {
                index in
                VStack {
                    RoverImageView(imageUrlString: dataModel[index].imageUrlString)
                    Text("Earth Date: \(dataModel[index].earthDate) (Sol: \(dataModel[index].sol))")
                    Text(" ")
                }
            }
        }
        .onDisappear() {
//            viewList.forEach { (key, value) in
//                value.unload()
//            }
//            viewList = [:]
        }
    }
}

//struct RoverDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoverDetailView(imageDataModel: RoverImageDataModel())
//    }
//}
