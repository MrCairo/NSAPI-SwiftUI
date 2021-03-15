//
//  APODContentView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/10/21.
//

import SwiftUI
import Combine

struct APODContentView: View {
    private var apodService = APODService()
    let emptyData = Data()
    
    var body: some View {
        VStack {
            if let copyright = apodService.apodData.copyright {
                Text(copyright)
                    .font(.title)
            }
        }
        GeometryReader { geo in
            if geo.size.height > geo.size.width {
                VStack {
                    APODContentMixView(data: apodService.apodData)
                }
            } else {
                HStack {
                    APODContentMixView(data: apodService.apodData)
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
        
        let url = data.url
        if (data.mediaType == "image") {
            APODImageView(mediaType: (url != nil) ? .imageURL : .imageData,
                          mediaData: url?.absoluteString.data(using: .utf8) ?? Data())
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity)
            
        } else {
            APODVideoView(mediaType: .video,
                          mediaData: url?.absoluteString.data(using: .utf8) ?? Data())
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
