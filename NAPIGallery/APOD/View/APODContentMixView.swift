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
    @State var maxHeight: CGFloat = .infinity
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        ScrollView {
            VStack {
                if (data.isImage()) {
                    APODImageView(mediaType: (data.mediaURL() != nil) ? .imageURL : .imageData,
                                  mediaData: data.mediaURL()?.absoluteString.data(using: .utf8) ?? Data())
                        .scaleEffect((self.horizontalSizeClass ?? .compact) == .compact ? 1.0 : 0.75)
                } else {
                    APODVideoView(mediaType: .video,
                                  mediaData: data.mediaURL()?.absoluteString.data(using: .utf8) ?? Data())
                        .scaleEffect((self.horizontalSizeClass ?? .compact) == .compact ? 1.0 : 0.75)
                }
                Spacer(minLength: 15)
                Text(data.explanation ?? "Description not provided.")
                    .font(.body)
                    .padding()
            }
        }
    }
    
    func maxHeight(geo: GeometryProxy) -> CGFloat {
        if geo.size.height < geo.size.width {
            return .infinity
        } else {
            return geo.size.height / 2
        }
    }
}

#if DEBUG
struct APODContentMixView_Previews: PreviewProvider {
    static var previews: some View {
        APODContentMixView(data: APODDataModel.mockImageModel)

        APODContentMixView(data: APODDataModel.mockVideoModel)
    }
}
#endif

