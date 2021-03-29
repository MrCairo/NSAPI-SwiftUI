//
//  NAPIDateSelectionView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/22/21.
//

import SwiftUI

class SelectedDate {
    var startDate: Date = Date.distantPast
    var endDate: Date = Date.distantFuture
    
    init(startDate: Date, endDate: Date = Date.distantFuture) {
        self.startDate = startDate
        self.endDate = endDate
    }
}

struct NAPIDateSelectionView: View {
    @Binding var viewPresented: Bool
    @Binding var selectedDate: SelectedDate
    @State private var pickerDate = SelectedDate(startDate: Date())
    
    private var dateProxy: Binding<Date> {
        Binding<Date>(get: { self.pickerDate.startDate }, set: {
            self.pickerDate = SelectedDate(startDate: $0)
        })
    }

    var body: some View {
        VStack {
            Text("Select Date: \(NAPIDateSelectionView.displayDate(pickerDate.startDate))")
                .font(.title)
            Spacer()
            Form {
                DatePicker(
                    "Start Date",
                    selection: dateProxy,
                    displayedComponents: [.date]
                )
            }
            Button("Done") {
                viewPresented = false
                selectedDate = self.pickerDate
                print("Picked Date: \(pickerDate.startDate)")
            }
        }
    }
    
    static func displayDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        return dateFormatter.string(from: date)
    }
}

//
//struct NAPIDateSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        NAPIDateSelectionView()
//    }
//}
