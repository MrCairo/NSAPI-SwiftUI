//
//  APODImageView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/13/21.
//

import SwiftUI
import Combine

///
/// Represents a view with an image - like a UIKit UIImageView
///
struct APODImageView: View {
    let mediaType: APODMediaType
    let mediaData: Data
    let id = UUID()
    
    /// A system image to present in the case of a failure.
    let failImage = imageFromName("system:exclamationmark.triangle.fill")
    
    /// An image to display while waiting for something - like an image to load!
    let waitImage = imageFromName("system:slowmo")
    
    /// Observing changes in the ImageLoader.
    /// This would really be just the change in the Image object within the loader
    @StateObject private var loader = ImageLoader()

    var body: some View {
        if let string = String(data: mediaData, encoding: .utf8) {
            switch(mediaType) {
            // The image is located via a URL. Could also be a file URL
            case .imageURL:
                if string.hasPrefix("http") || string.hasPrefix("file") {
                    if let image = loader.load(string) {
                        return Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        return waitImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                } else {
                    // The image URL wasn't a URL (http(s):// or file://) so try to
                    // load it as a system type image.
                    return APODImageView.imageFromName(string)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                
            // The imageData represents a binary image. Convert it an display it.
            case .imageData:
                if let uiImage = UIImage(data: mediaData) {
                    return Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    return Image("xmark.octagon.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }

            default:
                return failImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }

        return failImage
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
    
    init(mediaType: APODMediaType, mediaData: Data) {
        self.mediaType = mediaType
        self.mediaData = mediaData
    }

    ///
    /// Given a name, this function will return an image based upon that string.
    /// Optionally, the name can begin with ```system:``` in which case, the
    /// image will be considered a system image.
    ///
    static func imageFromName(_ named: String) -> Image {
        var name = named
        var newImage: Image = Image("xmark.octagon.fill")
        
        if named.hasPrefix("system:") {
            name = named.replacingOccurrences(of: "system:", with: "")
            newImage = Image(systemName: name)
        } else {
            newImage = Image(name)
        }
        return newImage
    }

}

#if DEBUG
struct APODImageView_Previews: PreviewProvider {
    static var previews: some View {
        APODImageView(mediaType: .imageURL,
                      mediaData: "https://www.loc.gov/static/home/images/featured/programs/2021concerts-mar_1200x560.jpg"
                        .data(using: .utf8) ?? Data())
    }
}
#endif
