//  Cai's Part
//  ContentView.swift
//  SeatReservation
//
//  Created by Jiaqian Cai on 9/5/2025.
//

import SwiftUI

enum SortType {
    case name
    case rating
}
//Main content view of the app
struct ContentView: View {
    @State private var searchText = ""
    @State private var sortType: SortType = .name
    @State private var selectedTab = 0
    var restaurantData = RestaurantData()
    
    private let primaryColor = Color(red: 0.2, green: 0.2, blue: 0.3)
    private let accentColor = Color.blue
    private let backgroundColor = Color(red: 0.98, green: 0.98, blue: 0.98)
    private let cardBackground = Color.white
    
    var filteredTitles: [String] {
        if searchText.isEmpty {
            return restaurantData.mytitle
        } else {
            return restaurantData.mytitle,filter { $0.localizedCaseInsensitiveContains(searchText)}
        }
    }
}

