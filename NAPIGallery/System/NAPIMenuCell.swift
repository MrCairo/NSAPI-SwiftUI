//
//  NAPIMenuCell.swift
//  NAPIS
//
//  Created by Mitchell Fisher on 2/9/21.
//  Copyright © 2021 Committed Code. All rights reserved.
//

import SwiftUI

struct NAPIMenuCell: View, Identifiable {
    var id = UUID()
    var info: NAPIMenuItem
    @State private var image: Image = Image(systemName: "xmark.octagon")
    
    var body: some View {
        HStack {
            if let name = info.imageName {
                Image(name)
            }
            VStack(alignment: .leading) {
                Text(info.title)
                    .fontWeight(.bold)
                    .font(.title)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                Text(info.description)
                    .font(.headline)
            }
            Spacer()
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

#if DEBUG
struct NAPIMenuCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NAPIMenuCell(info: NAPIMenuItem.mockedData[0])
        }
    }
}
#endif
