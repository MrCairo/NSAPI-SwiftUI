//
//  RoverCameraListView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 4/4/21.
//

import SwiftUI

struct RoverCameraListView: View {
    public let rover: RoverType
    @State private var roverImageData: RoverImageDataModel = RoverImageDataModel()
    @StateObject var viewModel = RoverContentViewModel()
    @State private var showAI = true
    @State private var showingDatePicker = false
    @State private var showingRoverInfo = false
    @StateObject var photoDate = NAPISelectedDate(startDate: Date.distantPast)

    @ViewBuilder
    var body: some View {
        VStack {
        Text("Date: \((photoDate.startDateIsToday()) ? "Latest" : NAPIDate.displayDate(photoDate.startDate))")
            .font(.title2)
            HStack {
                if viewModel.aggregate.count == 0 && viewModel.serviceComplete == true {
                    noImagesView
                } else if viewModel.aggregate.count > 0 {
                    cameraListView
                } else {
                    NAPIActivityIndicatorView(isShowing: $showAI) {
                        List {
                            Text("")
                        }
                    }
                    .onAppear {
                        if photoDate.startDate == Date.distantPast {
                            photoDate.startDate = RoverImageDates.maxDate(rover: rover)
                        }
                        viewModel.update(roverType: rover)
                        callService(usingDate: photoDate.startDate)
                    }
                }
            }
        }
        .navigationBarItems(trailing: navButtons)
    }
    
    var noImagesView: some View {
        Text("There are no images for this date. Please choose a different date.")
            .padding()
            .multilineTextAlignment(.center)
//            .onAppear {
//                viewModel.reset()
//                showAI = false
//            }
    }

    var navButtons: some View {
        HStack {
            Button(action: { showingDatePicker = true },
                   label: {
                    Label("Select Date", systemImage: "calendar")
                        .labelStyle(IconOnlyLabelStyle())
                   })
                .sheet(isPresented: $showingDatePicker, onDismiss: { viewModel.reset() },
                       content: {
                        NAPIDateSelectionView(viewPresented: $showingDatePicker,
                                              selectedDate: $photoDate.startDate,
                                              dateBounds: RoverImageDates.minDate(rover: rover)
                                                ...
                                                RoverImageDates.maxDate(rover: rover))
                       })

//            infoButton
        }
    }
    
    var infoButton: some View {
        Button(action: { showingRoverInfo = true; showingDatePicker = false },
               label: {
                Label("Rover Info", systemImage: "info.circle")
                    .labelStyle(IconOnlyLabelStyle())
               })
            .sheet(isPresented: $showingRoverInfo, content: {
//                    RoverInfoView()
            })
    }

    private func callService(usingDate: Date?) {
        var query = [URLQueryItem]()
        if let date = usingDate {
            if NAPIDate.displayDate(date) != NAPIDate.displayDate(Date()) {
                query.append(URLQueryItem(name: "earth_date",
                                          value: NAPIDate.iso8601DisplayDate(date)))
            }
        }
        _ = viewModel.fetch(queryParms: query)
    }
    
    private var cameraListView: some View {
        return List(self.viewModel.aggregate) { camData in
            RoverMenuNavigationLink(menuItem: NAPIMenuItem(title: "\(camData.name)",
                                                           description: camData.description,
                                                           targetType: .roverImageDetail),
                                    roverImageDataModel: camData)
        }
    }
}

struct RoverCameraListView_Previews: PreviewProvider {
    static var previews: some View {
        RoverCameraListView(rover: .opportunity)
    }
}
