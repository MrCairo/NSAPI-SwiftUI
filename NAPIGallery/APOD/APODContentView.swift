//
//  APODContentView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/10/21.
//

import SwiftUI
import Combine

struct APODContentView: View {
    @State private var showingPopover = false
    @State private var date = SelectedDate(startDate: Date())
    @State private var apodData = APODDataModel()
    private var viewModel = APODContentViewModel()

    let emptyData = Data()
    
    var body: some View {
        HStack {
            VStack {
                if let title = (viewModel.service.apodData.title) {
                    Text(title)
                        .font(.title)
                }
                
                GeometryReader { geo in
                    if geo.size.height > geo.size.width {
                        VStack {
                            APODContentMixView(data: viewModel.service.apodData)
                        }
                    } else {
                        HStack {
                            APODContentMixView(data: viewModel.service.apodData)
                        }
                    }
                }
            }
            .onAppear(perform: {
                let dateString = NAPIService.standardDateString(date.startDate)
                let item = URLQueryItem(name: "date", value: dateString)
                let _ = viewModel.$apodData
                    .sink {
                        self.apodData = $0
                    }
                viewModel.fetch(queryParms: [item])
            })
        }
        .navigationBarItems(trailing: Button(action: { showingPopover = true},
                                            label: {
                                                Label("Info", systemImage: "info.circle")
                                                    .labelStyle(IconOnlyLabelStyle())
        }))
        .sheet(isPresented: $showingPopover, onDismiss: {
            print("dismissed")
        }) {
            NAPIDateSelectionView(viewPresented: $showingPopover, selectedDate: $date)
        }
    }
}


private struct InfoLinkButton<Destination : View>: View {
    var destination:  Destination
    
    var body: some View {
        NavigationLink(destination: self.destination) { Image(systemName: "info.circle") }
    }
}

#if DEBUG
struct APODContentView_Previews: PreviewProvider {
    static var previews: some View {
        APODContentView()
    }
}
#endif
