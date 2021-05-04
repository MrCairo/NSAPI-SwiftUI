//
//  NAPIDateSelectionView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/22/21.
//

import SwiftUI

class NAPISelectedDate: ObservableObject {
    @Published var startDate: Date = Date.distantPast
    @Published var endDate: Date = Date.distantFuture
    
    init(startDate: Date, endDate: Date = Date.distantFuture) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func startDateIsToday() -> Bool {
        return NAPIDate.displayDate(startDate) == NAPIDate.displayDate(Date())
    }
}

struct NAPIDateSelectionView: View {
    @Binding var viewPresented: Bool
    @Binding var selectedDate: Date
    public var dateBounds: ClosedRange<Date>
    @State private var pickerDate = NAPISelectedDate(startDate: Date.distantPast)
    
    private var dateProxy: Binding<Date> {
        Binding<Date>(get: {
            if self.pickerDate.startDate == Date.distantPast {
                self.pickerDate.startDate = selectedDate
            }
            return self.pickerDate.startDate
            
        }, set: {
            self.pickerDate = NAPISelectedDate(startDate: $0)
        })
    }

    var body: some View {
        VStack {
            Text("Selected Date: \(NAPIDate.displayDate((pickerDate.startDate == Date.distantPast) ? selectedDate : pickerDate.startDate))")
                .font(.title2)
            Spacer()
            Form {
                DatePicker(
                    "Start Date:",
                    selection: dateProxy,
                    in: dateBounds,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                buttonBar
            }
        }
    }

    var buttonBar: some View {
        HStack {
            Button("Cancel") {
                viewPresented = false
            }
            .foregroundColor(.red)
            .buttonStyle(BorderlessButtonStyle())
            .padding()
            Spacer()
            Button("Today") {
                self.pickerDate.startDate = Date()
                selectedDate = Date()
            }
            .padding()
            .buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button("Done") {
                viewPresented = false
                selectedDate = self.pickerDate.startDate
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding()
        }
    }
}

#if DEBUG
struct NAPIDateSelectionView_Previews: PreviewProvider {
    static var previews: some View {

        NAPIDateSelectionView(viewPresented: .constant(true),
                              selectedDate: .constant(Date()),
                              dateBounds: NAPIDate.dateFromDisplayDate("Jul 16, 1995")...Date())
    }
}
#endif
