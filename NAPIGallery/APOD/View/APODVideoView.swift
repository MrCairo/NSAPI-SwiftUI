//
//  APODVideoView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/13/21.
//

import AVKit
import SwiftUI

struct APODVideoView: View {
    let mediaType: APODMediaType
    let mediaData: Data
    let id = UUID()
    let errorImage = APODImageView.imageFromName("system:exclamationmark.triangle.fill")
    
    var body: some View {
        if let string = String(data: mediaData, encoding: .utf8) {
            switch(mediaType) {
            case .video:
                if let url = URL(string: string) {
                    let request = URLRequest(url: url)
                    // We use the WebView to play videos vs. VideoPlayer for simplicity
                    WebView(request: request)
                } else {
                    errorImage
                }
            default:
                errorImage
            }
        } else {
            errorImage
        }
    }
}

import WebKit

struct WebView : UIViewRepresentable {
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}

#if DEBUG
struct APODVideoView_Previews: PreviewProvider {
    static var previews: some View {
        let vid = "https://www.youtube.com/watch?v=OEf5HsK28FM&list=RDauI9Cx8SGX4&index=4&autoplay=1".data(using: .utf8) ?? Data()
        APODVideoView(mediaType: .video, mediaData: vid)
    }
}
#endif
