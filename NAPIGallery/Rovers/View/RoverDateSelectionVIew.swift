//
//  RoverDateSelectionVIew.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 4/5/21.
//

import SwiftUI

struct RoverDateSelectionVIew: View {
    @State var date = Date()
    @State var presented = true
    var body: some View {
        VStack {
            NAPIDateSelectionView(viewPresented: $presented,
                                  selectedDate: $date)
            Form {
                
            }
        }
    }
}

struct RoverDateSelectionVIew_Previews: PreviewProvider {
    static var previews: some View {
        RoverDateSelectionVIew()
    }
}
