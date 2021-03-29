//
//  APODContentMixView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/27/21.
//

import SwiftUI

struct APODContentMixView: View {
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
