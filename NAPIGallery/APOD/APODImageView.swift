//
//  APODImageView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/13/21.
//

import SwiftUI

struct APODImageView: View {
    let mediaType: APODMediaType
    let mediaData: Data
    let id = UUID()
    
    var body: some View {
        let failImage = APODImageView.imageFromName("system:exclamationmark.triangle.fill")
        
        if let string = String(data: mediaData, encoding: .utf8) {
            switch(mediaType) {
            case .imageURL:
                if string.hasPrefix("http") || string.hasPrefix("file"),
                   let imageURL = URL(string: string) {
                    APODImageView.imageFromURL(imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    APODImageView.imageFromName(string)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                
            case .imageData:
                if let uiImage = UIImage(data: mediaData) {
                    Image(uiImage: uiImage)
                } else {
                    Image("xmark.octagon.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
            default:
                failImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
    
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
    
    
    static func imageFromURL(_ imageURL: URL) -> Image {
        var image: Image = Image(systemName: "xmark.octagon.fill")
        if let data = try? Data(contentsOf: imageURL),
           let uiImage = UIImage(data: data) {
            image = Image(uiImage: uiImage)
        }
        
        return image
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
