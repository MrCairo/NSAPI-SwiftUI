//
//  RoverCameraListView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 4/4/21.
//

import SwiftUI

struct RoverCameraListView: View {
    public let rover: RoverType
    @State private var roverImageData: RoverImageDataModel = RoverImageDataModel()
    @StateObject var viewModel = RoverContentViewModel()
    
    var body: some View {
        photoList
            .onAppear {
                viewModel.update(roverType: rover)
                callService()
            }
    }
    
    private func callService() {
        _ = viewModel.fetch()
    }
    
    private var photoList: some View {
        return List(self.viewModel.aggregate) { camData in
            RoverMenuNavigationLink(menuItem: NAPIMenuItem(title: "Rover Image",
                                                           description: camData.cameraName,
                                                           targetType: .roverImageDetail),
                                    roverImageDataModel: camData)
        }
    }
}

struct RoverCameraListView_Previews: PreviewProvider {
    static var previews: some View {
        RoverCameraListView(rover: .opportunity)
    }
}
