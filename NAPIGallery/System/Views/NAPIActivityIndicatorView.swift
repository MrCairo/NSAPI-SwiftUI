//
//  NAPIActivityIndicatorView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/31/21.
//

import SwiftUI

//
// Special thanks to @Matteo Pacini of Stack Overflow
//
struct NAPIActivityIndicatorView2: View {

    @Binding var isShowing: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                VStack(alignment: .center) {
                    Text("Loading...")
                    NAPIUIActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}

struct NAPIActivityIndicatorView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text("Loading...")
                    NAPIUIActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}


private struct NAPIUIActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}


#if DEBUG
struct NAPIActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        NAPIActivityIndicatorView(isShowing: .constant(true)) {
            NavigationView {
                Text("")
//                List(["1", "2", "3", "4", "5"], id: \.self) { row in
//                    Text(row)
//                }.navigationBarTitle(Text("A List"), displayMode: .large)
            }
        }

//        GeometryReader { geometry in
//            HStack(alignment: .center) {
//                VStack(alignment: .center) {
//                    NAPIActivityIndicatorView2(isShowing: .constant(true))
//                }
//            }
//        }
    }
}
#endif
