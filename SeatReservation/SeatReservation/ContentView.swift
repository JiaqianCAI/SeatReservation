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
    //State to store user search input
    @State private var searchText = ""
    // Current selected sorting option
    @State private var sortType: SortType = .name
    //Selected tab
    @State private var selectedTab = 0
    //Restaurant data source
    var restaurantData = RestaurantData()
    
    //Main color for dark accents
    private let primaryColor = Color(red: 0.2, green: 0.2, blue: 0.3)
    private let accentColor = Color.blue //Accent color for stars and highlights
    private let backgroundColor = Color(red: 0.98, green: 0.98, blue: 0.98) //Light background for overall screen
    private let cardBackground = Color.white //Card background for sections
    
    //Filtered list of restaurant titles based on search input
    var filteredTitles: [String] {
        if searchText.isEmpty {
            // nothing is searched, return full list
            return restaurantData.mytitle
        } else {
            // filter by case-insensitive match
            return restaurantData.mytitle,filter { $0.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    // Returns a list of tuples with full info (title, image, rating, address, descriptoin)
    var sortedTitles:[(title: String, imageName: String, popularity: Int, address: String, descriprion: String)]{
        switch sortType {
        case .name:
            // Sort Alphabetically (A-Z)
            return filteredTitles.compactMap{
                title in guard let index = restaurantData.mytitle.firstIndex(of: title) else { return nil }
                return (title: title, imageName: restaurantData.image[index], popularity: restaurantData.popularity[index], address: restaurantData.address[index], description: restaurantData.detailDescription[index])
            }.sorted(by: { $0.title < $1.title})
        case .rating:
            //Sort by popularity in descending order
            return filteredTitles.compactMap{ title in guard let index = restaurantData.mytitle.firstIndex(of: title) else { return nil}
                return (title: title, imageName: restaurantData.image[index], popularity: restaurantData.popularity[index], address: restaurantData.address[index], description: restaurantData.detailDescription[index])
            }.sorted(by: { $0.popularity > $1.popularity })
        }
    }
    
    //Content body
    var body: some View{
        TabView(selection: $selectedTab) {
            // Home Tab
            NavigationView {
                ZStack{
                    //Set background color to ignore safe area
                    backgroundColor.ignoresSafeArea()
                    VStack(spacing: 0){
                        //Top header section (search and sort)
                        VStack(spacing: 20){
                            HStack{
                                //Magnifying glass icon (SF Symbol)
                                Image(systemName: "magnifyingglass").foregroundStyle(.gray)
                                //User input field for restaurant name
                                TextField("Search restaurants", text: $searchText).textFieldStyle(PlainTextFieldStyle())
                            }
                            .padding()
                            .background(cardBackground)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                            .padding(.horizontal)
                            
                            HStack {
                                Text("Sort by:")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Spacer()
                                Menu {
                                    Button(action: { sortType = .name }) {
                                        Label("Name", systemImage: sortType == .name ? "checkmark" : "")
                                    }
                                    Button(action: { sortType = .rating }) {
                                        Label("Rating", systemImage: sortType == .rating ? "checkmark" : "")
                                    }
                                } label: {
                                    HStack {
                                        Text(sortType == .name ? "Name" : "Rating")
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                        Image(systemName: "chevron.down")
                                            .font(.caption)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 20)
                        .background(cardBackground)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        
                        
                        }
                    }
                }
            }
        }
    }
    
    
}

