//
//  NAPIAboutContentView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/7/21.
//

import SwiftUI

struct NAPIAboutContentView: View {
    @Environment(\.openURL) var openURL
    
    var body: some View {
        GeometryReader { metrics in
                Image("About_Background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .frame(width: metrics.size.width,
                           height: metrics.size.height,
                           alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .overlay(info)
            }
    }
    
    var info: some View {
        VStack {
            Text("Welcome to the\nNASA API Gallery")
                .font(Font.title.weight(.bold))
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.top, 50)
            Spacer()
            Text("This app will allow you to view the various images and other data. The information is readily available from the NASA API but this app makes it easy to retrieve and visualize the inrormation!")
                .font(.title2)
                .multilineTextAlignment(.leading)
                .padding()
                .foregroundColor(.white)
            infoWithLink
                .font(.title2)
                .multilineTextAlignment(.leading)
                .padding()
                .foregroundColor(.white)
                .onTapGesture {
                    openURL(URL(string: "https://api.nasa.gov")!)
                }
            Spacer()
            Text("You can use the DEMO_KEY provided but it will only allow for a limited number of data requests (30 requests/hr, 50 requests/day.")
                .multilineTextAlignment(.leading)
                .font(Font.caption.weight(.bold))
                .padding()
                .foregroundColor(.white)
            Spacer()
        }
    }
    
    var infoWithLink: some View {
            ((Text("Please visit ")
                + Text("https://api.nasa.gov ")
                    .foregroundColor(.yellow)
                    .underline(color: .white))
                + Text("to generate a free API Key which will allow for more data requests per hour"))
    }
}

#if DEBUG
struct NAPIAboutView_Previews: PreviewProvider {
    static var previews: some View {
        NAPIAboutContentView()
    }
}
#endif
