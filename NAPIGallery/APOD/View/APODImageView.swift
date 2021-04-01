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
    
    /// Observing changes in the ImageLoader.
    /// This would really be just the change in the Image object within the loader
    @StateObject private var loader = ImageLoader.shared
    @State private var showAI: Bool = true

    var body: some View {
        if let string = String(data: mediaData, encoding: .utf8) {
            switch(mediaType) {

            // The image is located via a URL. Could also be a file URL
            case .imageURL:
                if string.hasPrefix("http") || string.hasPrefix("file") {
                    if let image = loader.load(string) {
                        return AnyView(Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill))
                    } else {
                        // We add this NavigationView because it takes up the entire
                        // view bounds and thus can be centered properly. I'm sure there
                        // is a better way of doing it...
                        return AnyView(NAPIActivityIndicatorView(isShowing: $showAI) {
                            NavigationView {
                                Text("")
                            }
                        })
                    }
                } else {
                    // The image URL wasn't a URL (http(s):// or file://) so try to
                    // load it as a system type image.
                    return AnyView(APODImageView.imageFromName(string)
                        .resizable()
                        .aspectRatio(contentMode: .fill))
                }
                
            // The imageData represents a binary image. Convert it an display it.
            case .imageData:
                if let uiImage = UIImage(data: mediaData) {
                    return AnyView(Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit))
                } else {
                    return AnyView(Image("xmark.octagon.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit))
                }

            default:
                return AnyView(APODImageView.failImage())
            }
        }

        return AnyView(APODImageView.failImage())
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
    
    static func failImage() -> some View {
        let failImage = APODImageView.imageFromName("system:exclamationmark.triangle.fill")
        return failImage
            .resizable()
            .frame(width: 150, height: 150, alignment: .center)
            .aspectRatio(contentMode: .fit)
    }

    static func waitImage() -> some View {
        let waitImage = imageFromName("system:slowmo")
        return waitImage
            .resizable()
            .frame(width: 150, height: 150, alignment: .center)
            .aspectRatio(contentMode: .fit)
    }
}


#if DEBUG
struct APODImageView_Previews: PreviewProvider {
    static var previews: some View {
        APODImageView(mediaType: .imageURL,
                      mediaData: "https://www.loc.gov/static/home/images/featured/programs/2021concerts-mar_1200x560.jpg"
                        .data(using: .utf8) ?? Data())

        APODImageView(mediaType: .imageURL,
                      mediaData: "bad"
                        .data(using: .utf8) ?? Data())
    }
}
#endif
