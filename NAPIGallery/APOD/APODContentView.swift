//
//  APODContentView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/10/21.
//

import SwiftUI
import Combine

struct APODContentView: View {
    @State private var showingDatePicker = false
    @StateObject var date = NAPISelectedDate(startDate: Date())
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
            .sheet(isPresented: $showingDatePicker, onDismiss: {
                callService()
            }) {
                NAPIDateSelectionView(viewPresented: $showingDatePicker,
                                      selectedDate: $date.startDate,
                                      dateBounds: NAPIDate.dateFromDisplayDate("Jul 16, 1995")...Date())
            }
        }
        .navigationBarItems(trailing: Button(action: { showingDatePicker = true},
                                            label: {
                                                Label("Select Date", systemImage: "calendar")
                                                    .labelStyle(IconOnlyLabelStyle())
        }))
    }
    
    private func callService() {
        let dateString = NAPIService.standardDateString(date.startDate)
        let item = URLQueryItem(name: "date", value: dateString)
        viewModel.fetch(queryParms: [item])
    }
}


#if DEBUG
struct APODContentView_Previews: PreviewProvider {
    static var previews: some View {
        APODContentView()
    }
}
#endif
