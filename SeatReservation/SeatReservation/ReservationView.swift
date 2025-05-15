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
    @State private var seatsByTime: [String: [[SeatStatus]]] = [:]

    private var seatsData: [[SeatStatus]] {
        seatsByTime[selectedTime] ?? Array(repeating: Array(repeating: .available, count: 5), count: 4)
    }
    
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
        .onAppear {
            for time in timesAvailable {
                seatsByTime[time] = Array(
                    repeating: Array(repeating: .available, count: 5),
                    count: 4
                )
                let booked = getBookedSeats(for: time)
                for seat in booked {
                    let parts = seat.split(separator: "-")
                    if parts.count == 2,
                       let row = Int(parts[0]), let col = Int(parts[1]) {
                        seatsByTime[time]?[row - 1][col - 1] = .booked
                    }
                }
            }
        }
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

        switch seatsByTime[selectedTime]?[row][column] {
        case .available:
            //Select the seat and add to selected list
            seatsByTime[selectedTime]?[row][column] = .selected
            selectedSeats.append(seatNumber)

        case .selected:
            //Unselect
            seatsByTime[selectedTime]?[row][column] = .available
            selectedSeats.removeAll { $0 == seatNumber }

        case .booked, .none:
            //Do nothing if seat is already booked or invalid
            break
        }
    }
    
    // MARK: - Seat Persistence (Save/Load)
    func saveBookedSeats(_ seats: [String], for time: String) {
        let key = "bookedSeats_\(time)"
        let value = seats.joined(separator: ",")
        UserDefaults.standard.set(value, forKey: key)
    }
    func getBookedSeats(for time: String) -> [String] {
        let key = "bookedSeats_\(time)"
        let raw = UserDefaults.standard.string(forKey: key) ?? ""
        return raw.components(separatedBy: ",").filter { !$0.isEmpty }
    }
    
    // MARK: - Reservation Logic
    //This function runs when user taps the "Continue" button
    //If no seats selected, show warning
    //If seats are selected, move to next screen
    private func proceedToBooking() {
        if selectedSeats.isEmpty {
            showAlert = true
        } else {
            for seat in selectedSeats {
                let parts = seat.split(separator: "-")
                if parts.count == 2,
                   let row = Int(parts[0]), let col = Int(parts[1]) {
                    seatsByTime[selectedTime]?[row - 1][col - 1] = .booked
                }
            }

            let key = "bookedSeats_\(selectedTime)"
            let raw = UserDefaults.standard.string(forKey: key) ?? ""
            var seats = raw.components(separatedBy: ",").filter { !$0.isEmpty }
            seats.append(contentsOf: selectedSeats)
            seats = Array(Set(seats)) //
            UserDefaults.standard.set(seats.joined(separator: ","), forKey: key)

            navigateToPersonView = true
        }
    }
}

//MARK: - Subviews
//TimeSlotView: Reusable component to display each time slot
//Shows whether the time is selected and handles user tap
struct TimeSlotView: View {
    let time: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(time)
                .font(.subheadline.weight(.medium)) //White text if selected
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.blue : Color(.systemFill)) //Blue if selected
                .cornerRadius(8)
        }
    }
}

//SeatView: Represents a single seat in the grid
//Handles color, icon, and border
struct SeatView: View {
    let status: ReservationView.SeatStatus
    let number: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                //Use system icon to show seat, change if booked
                Image(systemName: status == .booked ? "chair.lounge.fill" : "chair")
                    .font(.title3)
                    .foregroundColor(seatColor)
                
                //Show seat number below the icon
                Text(number)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(width: 44, height: 44)
            .background(backgroundColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: 1) //Colored border to match status
            )
        }
        .disabled(status == .booked) //Disable button if seat is already booked
    }
    
    //Seat icon color depending on status
    private var seatColor: Color {
        switch status {
        case .available: return .blue
        case .selected: return .green
        case .booked: return .gray
        }
    }
    
    //Background colour for seat depending on status
    private var backgroundColor: Color {
        switch status {
        case .available: return Color(.systemBackground)
        case .selected: return Color.green.opacity(0.1)
        case .booked: return Color(.systemFill)
        }
    }
    
    //Border color for seat depending on status
    private var borderColor: Color {
        switch status {
        case .available: return .blue
        case .selected: return .green
        case .booked: return .clear
        }
    }
}

//SelectedSeatsView: Displays the list of seats the user has selected
//Appears above the seat grid only when there are selected seats
struct SelectedSeatsView: View {
    let seats: String
    
    var body: some View {
        HStack {
            //Icon to indicate selected status
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            //Show the selected seat numbers
            Text("Selected: \(seats)")
                .font(.subheadline)
            Spacer()
        }
        .padding(12)
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
    }
}

//LegendItem: Small colored dot + label used in legend section
//Explains what seat colors mean (Available / Selected / Booked)
struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

//Preview for ReservationView
struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            //Preview a sample reservation screen
            ReservationView(title: "QUAY Restaurant", image: "image1")
        }
    }
}
