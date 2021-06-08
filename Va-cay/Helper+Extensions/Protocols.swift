//
//  Protocols.swift
//  Va-cay
//
//  Created by Jenny Morales on 6/5/21.
//

import Foundation
import MapKit

protocol DatePickerDelegate: AnyObject {
    func dateSelected(_ date: Date?)
}

protocol HandleMapSearch: AnyObject {
    func dropPinZoomIn(placemark: MKPlacemark)
}

protocol MapPinDropped: AnyObject {
    func droppedPin(title: String)
}
