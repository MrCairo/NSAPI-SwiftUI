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
            ZStack {
                Image("About_Background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: metrics.size.width,
                           height: metrics.size.height,
                           alignment: .center)
            }
            ScrollView {
                info
            }
            .frame(width: metrics.size.width, height: metrics.size.height, alignment: .center)
        }
    }

    var info: some View {
        VStack {
            Text("Welcome to the\nNASA API Gallery")
                .font(Font.title.weight(.bold))
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.top)
            Spacer(minLength: 25.0)
            Text("This app will allow you to view the various images and other data. The information is publicly available from the NASA API but this app makes it easy to retrieve and visualize the information!")
                .font(.title2)
                .multilineTextAlignment(.leading)
                .padding()
                .foregroundColor(.white)
            Spacer(minLength: 25.0)
            infoWithLink
                .font(.title2)
                .multilineTextAlignment(.leading)
                .padding()
                .foregroundColor(.white)
                .onTapGesture {
                    openURL(URL(string: "https://api.nasa.gov")!)
                }
            Spacer(minLength: 50.0)
            Text("You can use the DEMO_KEY provided but it will only allow for a limited number of data requests (30 requests/hr, 50 requests/day.")
                .multilineTextAlignment(.leading)
                .font(Font.caption.weight(.bold))
                .padding()
                .foregroundColor(.white)
            Spacer()
            Text("Version \(NAPIService.appVersion)")
                .font(Font.caption.weight(.bold))
                .padding()
                .foregroundColor(.white)
        }
    }
    
    var infoWithLink: some View {
            ((Text("Please visit ")
                + Text("https://api.nasa.gov ")
                    .foregroundColor(.yellow)
                    .font(Font.title2.weight(.bold))
                    .underline(color: .white))
                + Text("to generate a free API Key which will allow for more data requests per hour."))
    }
}

#if DEBUG
struct NAPIAboutView_Previews: PreviewProvider {
    static var previews: some View {
        NAPIAboutContentView()
    }
}
#endif
