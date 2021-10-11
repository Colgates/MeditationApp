//
//  APICaller.swift
//  MeditationApp
//
//  Created by Evgenii Kolgin on 30.08.2021.
//

import Combine
import UIKit

class APICaller {
    
    static let shared = APICaller()
    
    func createRequest(route: Route) -> URLRequest {
        
        let url = URL(string: Route.baseURL)
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = route.description
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        return request
    }
    
    func getMeditationDataUsingCombine() -> AnyPublisher<[Meditation], Error> {
        
        return URLSession.shared.dataTaskPublisher(for: createRequest(route: .meditations))
            .map(\.data)
            .decode(type: ResponseWrapper.self, decoder: JSONDecoder())
            .map {$0.data.data.meditations ?? []}
            .eraseToAnyPublisher()
    }
    
    func getSoundDataUsingCombine() -> AnyPublisher<[Sound], Error> {
        
        return URLSession.shared.dataTaskPublisher(for: createRequest(route: .sounds))
            .map(\.data)
            .decode(type: ResponseWrapper.self, decoder: JSONDecoder())
            .map {$0.data.data.sounds ?? []}
            .eraseToAnyPublisher()
    }
}
