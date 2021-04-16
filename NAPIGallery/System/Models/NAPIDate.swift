//
//  NAPIDate.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 4/14/21.
//

import Foundation

struct NAPIDate {

    static func displayDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func dateFromDisplayDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        return dateFormatter.date(from: dateString) ?? Date(timeIntervalSince1970: 0)
    }
    
    static func iso8601DisplayDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    static func dateFromIso8601DisplayDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.date(from: dateString) ?? Date(timeIntervalSince1970: 0)
    }
}

