//  Bo's Part
//  Resta.swift
//  SeatReservation
//
//  Created by Jiaqian Cai on 9/5/2025.
//
import Foundation

class RestaurantData{
    //list of the restaurant names(the titles)
    var mytitle: [String] = [
        "Chapter One",
        "Restaurant Patrick Guilbaud",
        "Liath",
        "The Greenhouse",
        "Aniar",
        "Bastible",
        "Campagne"
    ]
    
    // Detailed descriptions for each restaurant
    var detailDescription: [String] = [
        "Michelin-starred Chapter One in Dublin offers contemporary Irish cuisine with French influences. Chef Mickael Viljanen creates exquisite dishes using Ireland's finest seasonal produce in an elegant basement setting.",
        "Ireland's only two-Michelin-starred restaurant, located in Dublin's Merrion Hotel. Chef Patrick Guilbaud delivers exceptional French cuisine with Irish ingredients in a luxurious Georgian setting.",
        "A Michelin-starred gem in Blackrock, County Dublin, where chef Damien Grey creates innovative tasting menus showcasing Ireland's best seafood, meats and foraged ingredients with Japanese influences.",
        "Michelin-starred dining in Dublin city center where chef Mickael Viljanen creates imaginative dishes using hyper-local ingredients, many foraged from the restaurant's own garden.",
        "Galway's Michelin-starred restaurant offering a modern interpretation of Irish cuisine. Chef JP McMahon's tasting menus highlight wild and seasonal ingredients from the west of Ireland.",
        "This Michelin-starred Dublin restaurant in Portobello offers creative seasonal menus in a relaxed setting. Chef Barry Fitzmartin's dishes celebrate Ireland's artisan producers.",
        "Kilkenny's Michelin-starred French restaurant where chef Garrett Byrne creates classic dishes with Irish ingredients. Elegant dining in a beautifully restored 18th-century warehouse."
    ]
    
    //Street addresses for each restaurant
    var address: [String] = [
        "18-19 Parnell Square N, Rotunda, Dublin 1",
        "21 Upper Merrion Street, Dublin 2",
        "19 Main St, Blackrock, Co. Dublin",
        "Dawson St, Dublin 2",
        "53 Lower Dominick Street, Galway",
        "111 South Circular Road, Portobello, Dublin 8",
        "5 The Arches, Gashouse Lane, Kilkenny"
    ]
    
    var image: [String] = [
        "chapter_one",
        "patrick_guilbaud",
        "liath",
        "greenhouse",
        "aniar",
        "bastible",
        "campagne"
    ]
    
    //popularity ratings (from 1 to 5 stars) for each restaurant
    var popularity: [Int] = [5, 5, 4, 4, 3, 3, 2]
}
    
