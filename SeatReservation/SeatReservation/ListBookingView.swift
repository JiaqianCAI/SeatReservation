//  Cai's Part
//  ListBookingView.swift
//  SeatReservation
//
//  Created by Jiaqian Cai on 9/5/2025.
//
import SwiftUI
import SwiftData

//Displays all the user's reservations that are currently "Booked"
struct ListBookingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [SeatReservationDB]
    @State private var showDeleteConfirmation = false
    @State private var itemToDelete: SeatReservationDB?
    
    //Only show reservations where the status is "Booked"
    private var activeReservations: [SeatReservationDB] {
        items.filter { $0.status == "Booked" }
    }
    
    var body: some View {
        Group {
            //If no active bookings, show a placeholder message
            if activeReservations.isEmpty {
                ContentUnavailableView(
                    "No Reservations",
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text("You don't have any upcoming reservations")
                )
            } else {
                //Display list of current reservations
                List {
                    ForEach(activeReservations) { reservation in
                        //Each reservation is shown inside a custom card
                        ReservationCard(reservation: reservation) {
                            //When cancel button is tapped, store the selected item
                            itemToDelete = reservation
                            showDeleteConfirmation = true
                        }
                        //Hide separator between rows
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Color.clear)
                    }
                }
                //Remove default background
                .listStyle(.plain)
            }
        }
        //Set the navigation title
        .navigationTitle("My Reservations")
        .navigationBarTitleDisplayMode(.inline)
        //Confirmation dialog shown before actually canceling a reservation
        .confirmationDialog(
            "Cancel Reservation",
            isPresented: $showDeleteConfirmation,
            presenting: itemToDelete
        ) { item in
            //Confirm cancel
            Button("Cancel Reservation", role: .destructive) {
                cancelReservation(item)
            }
            //Let user back out
            Button("Keep Reservation", role: .cancel) {}
        } message: { item in
            //Show seat time
            Text("Are you sure you want to cancel your reservation for \(item.time)?")
        }
    }
    
    //Updates the reservation status to "Canceled" and saves it
    private func cancelReservation(_ item: SeatReservationDB) {
        withAnimation {
            item.status = "Canceled"
            do {
                //Save cancellation to database
                try modelContext.save()
                
                //Remove this seat from UserDefaults for the corresponding time slot
                let time = item.time
                let seat = item.seat
                let key = "bookedSeats_\(time)"
                let raw = UserDefaults.standard.string(forKey: key) ?? ""
                var seats = raw.components(separatedBy: ",").filter { !$0.isEmpty }
                seats.removeAll { $0 == seat }
                UserDefaults.standard.set(seats.joined(separator: ","), forKey: key)
                
            } catch {
                print("Error cancelling reservation: \(error)")
            }
        }
    }
}
//Shows the details of a single reservation
//Includes name, phone, time, seat, and optional note
//Also includes a cancel button that triggers a callback
struct ReservationCard: View {
    let reservation: SeatReservationDB
    let onCancel: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            //Top row: name and phone on the left, time on the right
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(reservation.name)
                        .font(.headline)
                    
                    Text(reservation.phone)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(reservation.time)
                    .font(.subheadline.weight(.semibold))
            }
            
            Divider()
            
            //Middle row: seat info and optional note (if exists)
            HStack {
                Label(reservation.seat, systemImage: "chair")
                    .font(.subheadline)
                
                Spacer()
                
                if !reservation.note.isEmpty {
                    Label(reservation.note, systemImage: "note.text")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            //Cancel button at the bottom
            Button(action: onCancel) {
                Label("Cancel Reservation", systemImage: "xmark")
                    .font(.subheadline.weight(.medium))
                    .frame(maxWidth: .infinity)
                    .padding(8)
            }
            .buttonStyle(.bordered)
            .tint(.red)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        ListBookingView()
            .modelContainer(for: SeatReservationDB.self, inMemory: true)
    }
}
