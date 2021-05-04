//
//  RoverInfoView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 4/16/21.
//

import SwiftUI

struct RoverInfoView: View {
    let rover: RoverType
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct RoverInfoView_Previews: PreviewProvider {
    static var previews: some View {
        RoverInfoView(rover: .spirit)
    }
}
