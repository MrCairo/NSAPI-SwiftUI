//
//  NAPIAboutContentView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/7/21.
//

import SwiftUI

struct NAPIAboutContentView: View {
    var body: some View {
        Text("Welcome to the NASA API Gallery!")
    }
}

#if DEBUG
struct NAPIAboutView_Previews: PreviewProvider {
    static var previews: some View {
        NAPIAboutContentView()
    }
}
#endif
