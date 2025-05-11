//  Cai's Part
//  ReservationView.swift
//  SeatReservation
//
//  Created by Jiaqian Cai on 9/5/2025.
//

import SwiftUI

//View for making a reservation
struct ReservationView: View {
    var title: String //Name of the restaurant
    var image: String //Name of the image asset
    
    //Enum to represent the status of each seat
    enum SeatStatus {
        case available //Not taken
        case selected //Has selected
        case booked //Already booked
    }
    
    //Seat statuses：A 2D array (4 rows x 5 columns)
    @State private var seatsData: [[SeatStatus]] = Array(
        repeating: Array(repeating: .available, count: 5),
        count: 4
    )
    
    //Stores the identifiers of seats selected
    @State private var selectedSeats: [String] = []
    //Available time slots to choose
    @State private var timesAvailable = ["10:00 AM", "12:30 PM", "3:00 PM", "5:30 PM", "8:00 PM"]
    //Currently selected time
    @State private var selectedTime = "10:00 AM"
    //Controls whether a confirmation alert is shown
    @State private var showAlert = false
    //Controls navigation to the next view
    @State private var navigateToPersonView = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                //Top section with restaurant image and title
                ZStack(alignment: .bottomLeading) {
                    Image(image)
                        .resizable()
                        .aspectRatio(3/2, contentMode: .fill)
                        .frame(height: 200)
                        .clipped() //Make sure the image doesn't overflow
                    
                    //Add a dark gradient from bottom to top
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    //Show the restaurant title at the bottom left
                    Text(title)
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.white)
                        .padding()
                }
                .cornerRadius(12) //Round the image corners
                .padding(.horizontal) //Add side padding
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("SELECT TIME")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(timesAvailable, id: \.self) { time in
                                TimeSlotView(time: time, isSelected: time == selectedTime) {
                                    selectedTime = time
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Seat selection
                VStack(alignment: .leading, spacing: 16) {
                    Text("SELECT SEATS")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    if !selectedSeats.isEmpty {
                        SelectedSeatsView(seats: selectedSeats.joined(separator: ", "))
                            .padding(.horizontal)
                    }
                    
                    // Seat map area
                    VStack(spacing: 16) {
                        //Grey line as the screen indicator
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 4)
                            .padding(.horizontal, 40)
                            .padding(.bottom, 8)
                        
                        //Seats arranged in a grid layout
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: seatsData[0].count), spacing: 16) {
                            ForEach(0..<seatsData.count, id: \.self) { row in
                                ForEach(0..<seatsData[row].count, id: \.self) { column in
                                    //Show each seat with its number and status
                                    SeatView(
                                        status: seatsData[row][column],
                                        number: "\(row+1)-\(column+1)"
                                    ) {
                                        //Toggle seat selection when tapped
                                        toggleSeat(row: row, column: column)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                
            }
        }
    }
}
