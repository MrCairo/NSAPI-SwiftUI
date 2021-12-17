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
            Group {
                Text("Welcome to the\nNASA API Gallery")
                    .font(Font.title.weight(.bold))
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top)
            }
            Spacer(minLength: 25.0)
            Text("This app will allow you to view the various images and other data. The information is publicly available from the NASA API but this app makes it easy to retrieve and visualize the information!")
                .font(.title2)
                .multilineTextAlignment(.leading)
                .padding()
                .foregroundColor(.white)
            Spacer(minLength: 10.0)
            infoWithLink
                .font(.title2)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding()
                .onTapGesture {
                    openURL(URL(string: "https://api.nasa.gov")!)
                }
            Spacer(minLength: 15.0)
            Text("You can use the DEMO_KEY provided but it will only allow for a limited number of data requests (30 requests/hr, 50 requests/day.")
                .multilineTextAlignment(.leading)
                .font(Font.footnote.weight(.bold))
                .padding()
                .foregroundColor(.white)
            Spacer()
            HStack {
            Text("Version \(NAPIService.appVersion)")
                    .font(Font.callout.weight(.bold))
                .foregroundColor(.yellow)
            }
            .padding(20.0)
        }
    }
    
    var infoWithLink: some View {
            ((Text("Please visit the ")
                + Text("{ NASA APIs }")
                .underline()
                .foregroundColor(.white)
                    .font(Font.title2.weight(.bold)))
                + Text(" page to generate a free API Key which will allow for more data requests per hour."))
    }
}

#if DEBUG
struct NAPIAboutView_Previews: PreviewProvider {
    static var previews: some View {
        NAPIAboutContentView()
    }
}
#endif
