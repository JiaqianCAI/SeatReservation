//  Bo's Part
//  SeatReservationDB.swift
//  SeatReservation
//
//  Created by Jiaqian Cai on 10/5/2025.
//
import Foundation
import SwiftData

@Model
class SeatReservationDB {
    // The seat(s) selected for this reservation, e.g., "1-2, 2-3"
    var seat:String = ""
    
    // The time selected for the reservation, e.g., "12:30 PM"
    var time:String = ""
    
    // The full name of the customer
    var name:String = ""
    
    // Customer's phone number (only digits allowed)
    var phone:String = ""
    
    // Any additional notes from the customer (optional)
    var note:String = ""
    
    // Reservation status: "Booked" or "Canceled"
    var status:String = "" //booked //cancel
    
    // Initializer to create a new reservation object
    init(seat: String, time: String, name: String, phone: String, note: String, status: String) {
        self.seat = seat
        self.time = time
        self.name = name
        self.phone = phone
        self.note = note
        self.status = status
    }
}

