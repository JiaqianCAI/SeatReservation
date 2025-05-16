# SeatReservation
iOS App for restaurant seat booking (Assignment 3 - UTS 41889)

## Description
This is our group topic "SeatReservation" which is a SwiftUI-based iOS app that allows users to view restaurants,search available seats, and make reservations. This app is designed for user persona and follows an iterative design process to achieve a minimum viable product.



## Group Members and Responsibilities
### Member A: Jiaqian Cai , SID: 25504883
**Role:** UI desig & Interaction & README (front-end, search, navigation)
Responsible for visual stuff and user interation logic, also responsible for assigning group work and completeing README.Also responsible for assigning group work, completing the README, and final project integration (bug fixes and formatting improvements).
- 'ContentView.swift' - main layout (TabView + navigation)
- 'ReservationView' - seat and time selection interface
- 'ListBookingView' - reservation list and cancel interaction
- 'SearchBar' - custom search bar for filtering bookings
- 'Assets' - added restaurant image resources for UI

### Member B: Ruoyu Bo , SID: 24641007
**Role:** Data modeling & logic (back-end, state management, info display)
Responsible for app startup, data defination, and secondary view logic. Also did Presentation Slides.
- 'PersonalView.swift' - handles user information display interface
- 'InformationView.swift' - shows restaurant information details
- 'SeatReservation.swift' - manages seat selection and booking logic
- 'SeatReservationDB.swift' - defines and stores seat reservation data
- 'RestaurantData.swift' - stores hardcoded restaurant information for testing

## Repository Link
** https://github.com/JiaqianCAI/SeatReservation **

## How to Run

1. **Open in Xcode**  
   - Clone the repository from GitHub:  https://github.com/JiaqianCAI/SeatReservation
   - Open the `.xcodeproj` file in Xcode

2. **Build and Run**  
   - Select a simulator (e.g., iPhone 15 Pro)
   - Click the ▶️ "Run" button

3. **Explore the App**  
   - Navigate between Home and Booking tabs
   - Try searching, selecting time slots, reserving seats, and cancelling bookings


## Notes
   - The app uses `@State`, `UserDefaults`, and SwiftData-like mock storage for interaction logic and UI feedback
   - All data is currently stored in memory or local mock data
## Reference
///
