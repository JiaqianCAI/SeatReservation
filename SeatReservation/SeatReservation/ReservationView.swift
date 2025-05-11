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
                
                //Seat status legend - shows what each seat color means
                //Blue: available, Green: selected, Gray: booked
                HStack(spacing: 20) {
                    LegendItem(color: .blue, text: "Available")
                    LegendItem(color: .green, text: "Selected")
                    LegendItem(color: .gray, text: "Booked")
                }
                //Adds some space above the legend
                .padding(.top, 8)
                
                //Button to continue the reservation process
                Button(action: proceedToBooking) {
                    HStack {
                        Text("Continue")
                            .font(.headline.weight(.semibold))
                        //Push the arrow icon to the right
                        Spacer()
                        //Arrow icon to show the action goes forward
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    //If user hasn’t selected any seats, show the button in gray (disabled)
                    //If seats selected, button turns blue and becomes active
                    .background(selectedSeats.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(10)
                    .disabled(selectedSeats.isEmpty)
                }
                .padding()
                //Alert message shown when user clicks "Continue" without selecting any seats
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("No Seats Selected"),
                        message: Text("Please select at least one seat to continue."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            //Vertical spacing around the whole view
            .padding(.vertical)
        }
        .background(Color(.systemBackground))
        //Set the title of this screen as "Reservation"
        .navigationTitle("Reservation")
        .navigationBarTitleDisplayMode(.inline)
        // NavigationLink controls the jump to the next screen
        // This link stays hidden (EmptyView), but when navigateToPersonView becomes true, it will activate
        .background(
            NavigationLink(
                destination: PersonView(seat: selectedSeats.joined(separator: ", "), time: selectedTime),
                //This binding controls whether to navigate
                isActive: $navigateToPersonView
            ) { EmptyView() }
        )
    }
    //MARK: - Logic Function
    //This function runs when a seat is tapped.
    //It updates the status of the seat (available / selected)
    private func toggleSeat(row: Int, column: Int) {
        let seatNumber = "\(row+1)-\(column+1)"
        
        switch seatsData[row][column] {
        case .available:
            //If seat was available, mark it selected and add it to selected list
            seatsData[row][column] = .selected
            selectedSeats.append(seatNumber)
        case .selected:
            //Was already selected
            seatsData[row][column] = .available
            selectedSeats.removeAll { $0 == seatNumber }
        case .booked:
            //Is booked
            break
        }
    }
    //This function runs when user taps the "Continue" button
    //If no seats selected, show warning
    //If seats are selected, move to next screen
    private func proceedToBooking() {
        if selectedSeats.isEmpty {
            showAlert = true
        } else {
            navigateToPersonView = true
        }
    }
}

//MARK: - Subviews

