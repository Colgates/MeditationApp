//
//  Route.swift
//  MeditationApp
//
//  Created by Evgenii Kolgin on 07.09.2021.
//

import Foundation

enum Route {
    
    static let baseURL = "https://mindfulness-app.herokuapp.com"
    
    case meditations
    case sounds
    
    var description: [String:String] {
        switch self {
        case .meditations:
            return ["query" : "query { meditations { title, description, items { title, author, length, url, imageURL } } }"]
        case .sounds:
            return ["query" : "query { sounds { title, items { title, length, url, imageURL } } }"]
        }
    }
}
