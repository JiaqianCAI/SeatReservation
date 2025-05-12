//  Cai's Part
//  ListBookingView.swift
//  SeatReservation
//
//  Created by Jiaqian Cai on 9/5/2025.
//
import SwiftUI
import SwiftData

struct ListBookingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [SeatReservationDB]
    @State private var showDeleteConfirmation = false
    @State private var itemToDelete: SeatReservationDB?
    
    private var activeReservations: [SeatReservationDB] {
        items.filter { $0.status == "Booked" }
    }
    
    var body: some View {
        Group {
            if activeReservations.isEmpty {
                ContentUnavailableView(
                    "No Reservations",
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text("You don't have any upcoming reservations")
                )
            } else {
                List {
                    ForEach(activeReservations) { reservation in
                        ReservationCard(reservation: reservation) {
                            itemToDelete = reservation
                            showDeleteConfirmation = true
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("My Reservations")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Cancel Reservation",
            isPresented: $showDeleteConfirmation,
            presenting: itemToDelete
        ) { item in
            Button("Cancel Reservation", role: .destructive) {
                cancelReservation(item)
            }
            Button("Keep Reservation", role: .cancel) {}
        } message: { item in
            Text("Are you sure you want to cancel your reservation for \(item.time)?")
        }
    }
    
    private func cancelReservation(_ item: SeatReservationDB) {
        withAnimation {
            item.status = "Canceled"
            do {
                try modelContext.save()
            } catch {
                print("Error cancelling reservation: \(error)")
            }
        }
    }
}
