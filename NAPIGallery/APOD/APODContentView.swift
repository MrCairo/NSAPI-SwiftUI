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
    @StateObject var date = SelectedDate(startDate: Date())
    @State private var apodData = APODDataModel()
    @StateObject private var viewModel = APODContentViewModel()
    
    var body: some View {
        HStack {
            VStack {
                if let title = (viewModel.title) {
                    Text(title)
                        .font(.title)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                }
                // Display the date
                Text(NAPIService.standardDateString(date.startDate))
                        .font(.headline)
                
                GeometryReader { geo in
                    if geo.size.height > geo.size.width {
                        VStack {
                            APODContentMixView(data: viewModel.apodData)
                        }
                    } else {
                        HStack {
                            APODContentMixView(data: viewModel.apodData)
                        }
                    }
                }
            }
            .onAppear(perform: {
                callService()
            })
            .sheet(isPresented: $showingPopover, onDismiss: {
                callService()
            }) {
                NAPIDateSelectionView(viewPresented: $showingPopover, selectedDate: $date.startDate)
            }
        }
        .navigationBarItems(trailing: Button(action: { showingPopover = true},
                                            label: {
                                                Label("Select Date", systemImage: "calendar")
                                                    .labelStyle(IconOnlyLabelStyle())
        }))
    }
    
    private func callService() {
        let dateString = NAPIService.standardDateString(date.startDate)
        let item = URLQueryItem(name: "date", value: dateString)
        _ = viewModel.fetch(queryParms: [item])
    }
}


#if DEBUG
struct APODContentView_Previews: PreviewProvider {
    static var previews: some View {
        APODContentView()
    }
}
#endif
