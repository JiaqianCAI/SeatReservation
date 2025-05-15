//  Bo's Part
//  PersonalView.swift
//  SeatReservation
//
//  Created by Jiaqian Cai on 10/5/2025.
//
import SwiftUI
import SwiftData


struct PersonView: View {
    // These values are passed from ReservationView to show seat/time details
    var seat: String
    var time: String

    // Input fields controlled by @State
    @State private var phoneNumber = ""
    @State private var name = ""
    @State private var notes = ""
    @State private var showAlert = false
    @State private var showSuccess = false

    // SwiftData model context (auto-injected)
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            // Section 1: Reservation summary (readonly)
            Section {
                HStack {
                    Image(systemName: "chair")
                    Text("Seats: \(seat)")
                }

                HStack {
                    Image(systemName: "clock")
                    Text("Time: \(time)")
                }
            } header: {
                Text("Reservation Details")
            }

            // Section 2: User contact info
            Section {
                TextField("Full Name", text: $name)
                    .textContentType(.name)

                TextField("Phone Number", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .textContentType(.telephoneNumber)
                    .onChange(of: phoneNumber) { newValue in
                        // Filter out any non-numeric characters
                        phoneNumber = newValue.filter { $0.isNumber }
                    }
            } header: {
                Text("Contact Information")
            } footer: {
                Text("We'll use this information to confirm your reservation.")
            }

            // Section 3: Additional notes (optional)
            Section {
                TextField("Special requests (optional)", text: $notes, axis: .vertical)
                    .lineLimit(4, reservesSpace: true)
            }

            // Section 4: Submit button
            Section {
                Button(action: submitReservation) {
                    HStack {
                        Spacer()
                        Text("Confirm Reservation")
                            .font(.headline)
                        Spacer()
                    }
                }
                .disabled(!formIsValid) // Disable if fields are empty
            }
        }
        .navigationTitle("Confirm Reservation")
        .navigationBarTitleDisplayMode(.inline)

        // Alert: Missing information
        .alert("Missing Information", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please provide your name and phone number.")
        }

        // Alert: Successful submission
        .alert("Reservation Confirmed", isPresented: $showSuccess) {
            Button("Done") {
                dismiss() // Return to previous view
            }
        } message: {
            Text("Your table has been successfully reserved.")
        }
    }

    // Computed property: check if the form is valid
    private var formIsValid: Bool {
        !name.isEmpty && !phoneNumber.isEmpty
    }

    // Action: submit reservation to the database
    private func submitReservation() {
        guard formIsValid else {
            showAlert = true
            return
        }
        let key = "bookedSeats_\(time)"
        let raw = UserDefaults.standard.string(forKey: key) ?? ""
        var seats = raw.components(separatedBy: ",").filter { !$0.isEmpty }
        let newSeats = seat.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        seats.append(contentsOf: newSeats)
        seats = Array(Set(seats))
        UserDefaults.standard.set(seats.joined(separator: ","), forKey: key)

        // Create new reservation object and save
        let newReservation = SeatReservationDB(
            seat: seat,
            time: time,
            name: name,
            phone: phoneNumber,
            note: notes,
            status: "Booked"
        )

        modelContext.insert(newReservation)
        showSuccess = true
    }
}

// Preview for SwiftUI canvas
#Preview {
    NavigationStack {
        PersonView(seat: "1-3, 2-4", time: "11:00 AM")
    }
}
