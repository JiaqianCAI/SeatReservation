//  Bo's Part
//  InformationView.swift
//  SeatReservation
//
//  Created by Jiaqian Cai on 10/5/2025.
//
import SwiftUI

// View for displaying detailed information about a selected restaurant.
// Shows image, address, description, operating hours, and a reservation button.
struct InformationView: View {
    var myimage: String
    var title: String
    var address: String
    var description: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // Restaurant hero image with gradient overlay and title/address
                GeometryReader { geometry in
                    ZStack(alignment: .bottomLeading) {
                        // Full-width image
                        Image(myimage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: 280)
                            .clipped()
                        
                        // Gradient overlay to improve text readability
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 280)
                        
                        // Restaurant name and address text
                        VStack(alignment: .leading, spacing: 6) {
                            Text(title)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(2)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "mappin.and.ellipse")
                                    .font(.system(size: 14))
                                Text(address)
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .frame(height: 280) // Fixed height for the image header
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Section: About restaurant
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text(description)
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .lineSpacing(6)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 16)
                    
                    // Section: General details (hours, price)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Details")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 12) {
                            DetailRow(icon: "mappin.and.ellipse", text: address)
                            DetailRow(icon: "clock", text: "Hours: 11:00 AM - 10:00 PM")
                            DetailRow(icon: "dollarsign.circle", text: "Price: $$$")
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // Section: Reservation navigation button
                    NavigationLink(destination: ReservationView(title: self.title, image: self.myimage)) {
                        HStack {
                            Text("Reserve Now")
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 30)
                }
                .padding(.top, 20)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
}

// Subcomponent used for icon-text rows (e.g., address, hours)
struct DetailRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
    }
}

