//
//  Character.swift
//  RickAndMortyExplorer
//
//  Created by Алексей on 16.03.2025.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: OriginModel
    let location: LocationModel
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

extension Character {
    var statusWithEmoji: String {
        switch status.lowercased() {
        case "alive":
            return "🟢 Live"
        case "dead":
            return "💀 Dead"
        default:
            return "❓ Unknown"
        }
    }
}


struct OriginModel: Codable {
    let name: String
    let url: String
}


struct LocationModel: Codable {
    let name: String
    let url: String
}

struct CharacterResponse: Codable {
    let info: Info
    let results: [Character]
}

struct Info: Codable {
    let next: String?
}
