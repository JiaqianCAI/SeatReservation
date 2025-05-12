//  Cai's Part
//  SearchBar.swift
//  SeatReservation
//
//  Created by Jiaqian Cai on 9/5/2025.
//

import Foundation
import SwiftUI

//A custom search bar that uses UIKit's UISearchBar inside SwiftUI
struct SearchBar: UIViewRepresentable {
    //Keep track of the text entered in the search bar
    @Binding var text: String

    //Coordinator handles events like typing in the search bar
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        //Save a reference to the binding from the parent
        init(text: Binding<String>) {
            _text = text
        }

        //Called when the text changes in the search bar
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    //Tell SwiftUI which object should handle the UISearchBar’s behavior
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    //Create the UISearchBar and set its delegate
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        // Set the delegate of the search bar to the Coordinator.
        searchBar.delegate = context.coordinator
        return searchBar
    }

    //Keep the search bar text in sync with SwiftUI state
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}

