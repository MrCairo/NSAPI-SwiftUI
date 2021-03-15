//
//  APODMediaView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/7/21.
//

import SwiftUI
import AVKit

struct APODMediaView: View, Identifiable {
    let mediaType: APODMediaType
    let mediaData: Data
    let id = UUID()
    
    var body: some View {
        switch(mediaType) {
        case .imageURL:
            APODImageView(mediaType: mediaType, mediaData: mediaData)
            
        case .imageData:
            APODImageView(mediaType: mediaType, mediaData: mediaData)
            
        case .video:
            APODVideoView(mediaType: .video, mediaData: mediaData)
        }
    }
}

#if DEBUG
struct APODMediaView_Previews: PreviewProvider {
    static var previews: some View {
        
        //        let vid = "https://www.youtube.com/watch?v=OEf5HsK28FM&list=RDauI9Cx8SGX4&index=4".data(using: .utf8) ?? Data()
        //        APODMediaView(mediaType: .video, mediaData: vid)
        
        APODImageView(mediaType: .imageURL, mediaData: "https://www.loc.gov/static/home/images/featured/programs/2021concerts-mar_1200x560.jpg".data(using: .utf8) ?? Data())
    }
    
    static func getImageData() -> Data? {
        guard let url = URL(string: "https://www.loc.gov/static/home/images/featured/programs/2021concerts-mar_1200x560.jpg") else { return nil }
        
        return try? Data(contentsOf: url)
    }
}
#endif
