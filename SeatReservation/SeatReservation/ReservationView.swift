//  Cai's Part
//  ReservationView.swift
//  SeatReservation
//
//  Created by Jiaqian Cai on 9/5/2025.
//

import SwiftUI

struct ReservationView: View {
    var title: String
    var image: String
    
    enum SeatStatus {
        case available
        case selected
        case booked
    }
    
    @State private var seatsData: [[SeatStatus]] = Array(
        repeating: Array(repeating: .available, count: 5),
        count: 4
    )
    
    @State private var selectedSeats: [String] = []
    @State private var timesAvailable = ["10:00 AM", "12:30 PM", "3:00 PM", "5:30 PM", "8:00 PM"]
    @State private var selectedTime = "10:00 AM"
    @State private var showAlert = false
    @State private var navigateToPersonView = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack(alignment: .bottomLeading) {
                    Image(image)
                        .resizable()
                        .aspectRatio(3/2, contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                    
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    Text(title)
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.white)
                        .padding()
                }
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
    }
}
