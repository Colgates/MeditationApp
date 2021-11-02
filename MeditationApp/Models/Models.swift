//
//  Models.swift
//  MeditationApp
//
//  Created by Evgenii Kolgin on 31.08.2021.
//

import Foundation

// MARK: - ResponseWrapper
struct ResponseWrapper: Codable {
    let data: Model
}

// MARK: - Model
struct Model: Codable, Hashable {
    let meditations: [Meditation]?
    let sounds: [Sound]?
}

// MARK: - Meditation
struct Meditation: Codable {
    let title: String
    let description: String
    let items: [Item]
}

// MARK: - Sound
struct Sound: Codable {
    let title: String
    let items: [Item]
}

// MARK: - Item
struct Item: Codable, Hashable {
    let title: String
    let author: String?
    let length: String
    let url: String
    let imageURL: String
}

extension Model: Equatable {
    static func == (lhs: Model, rhs: Model) -> Bool {
        return lhs.meditations == rhs.meditations && lhs.sounds == rhs.sounds
    }
}

extension Meditation: Equatable, Hashable {
    static func == (lhs: Meditation, rhs: Meditation) -> Bool {
        return lhs.title == rhs.title && lhs.description == rhs.description
    }
}

extension Sound: Equatable, Hashable {
    static func == (lhs: Sound, rhs: Sound) -> Bool {
        return lhs.title == rhs.title
    }
}
