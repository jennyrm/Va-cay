//
//  DateExtension.swift
//  Va-cay
//
//  Created by Jenny Morales on 6/4/21.
//

import Foundation

extension Date {
    func formatToString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
//        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    func formatToStringWithShortDateAndTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    func formatToStringWithLongDateAndTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}//End of extension

