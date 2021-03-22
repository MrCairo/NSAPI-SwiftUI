//
//  APODContentView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/10/21.
//

import SwiftUI
import Combine

struct APODContentView: View {
    @ObservedObject public var viewModel = APODContentViewModel()
    let emptyData = Data()
    
    var body: some View {
        VStack {
            if let title = viewModel.service.apodData.title {
                Text(title)
                    .font(.title)
            }
        }
        GeometryReader { geo in
            if geo.size.height > geo.size.width {
                VStack {
                    APODContentMixView(data: viewModel.service.apodData)
                }
            } else {
                HStack {
                    APODContentMixView(data: viewModel.service.apodData)
                }
            }
        }
    }
}


private struct APODContentMixView: View {
    let data: APODDataModel
    
    var body: some View {
        APODTextView(text: data.description)
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity)
        
            if (data.mediaType == "image") {
            APODImageView(mediaType: (data.url != nil) ? .imageURL : .imageData,
                          mediaData: data.url?.absoluteString.data(using: .utf8) ?? Data())
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity)
            
        } else {
            APODVideoView(mediaType: .video,
                          mediaData: data.url?.absoluteString.data(using: .utf8) ?? Data())
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity)
        }
    }
}

#if DEBUG
struct APODContentView_Previews: PreviewProvider {
    static var previews: some View {
        APODContentView()
    }
}
#endif
