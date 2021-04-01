//
//  APODContentMixView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/27/21.
//

import SwiftUI

struct APODContentMixView: View {
    let data: APODDataModel
    @State var showingPopover = true
    
    var body: some View {
        APODTextView(text: data.explanation ?? "Missing Explanation")
            .padding()
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity)
        
        if (data.isImage()) {
            APODImageView(mediaType: (data.mediaURL() != nil) ? .imageURL : .imageData,
                          mediaData: data.mediaURL()?.absoluteString.data(using: .utf8) ?? Data())
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity)
                .scaledToFit()
                .onTapGesture {
                    showingPopover = true
                }
        } else {
            APODVideoView(mediaType: .video,
                          mediaData: data.mediaURL()?.absoluteString.data(using: .utf8) ?? Data())
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity)
        }
    }
}

struct APODContentMixView_Previews: PreviewProvider {
    static var previews: some View {
        APODContentMixView(data: APODDataModel.mockModel())
    }
}


