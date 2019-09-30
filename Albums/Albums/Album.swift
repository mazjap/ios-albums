//
//  Album.swift
//  Albums
//
//  Created by Jordan Christensen on 10/1/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation

struct Album: Codable {
    enum AlbumKeys: String, CodingKey {
        case artist
        case genres
        case name
        case song
    }
    
    let artist: String
    let genres: [String]
    let name: String
    
    let songs: [Song]
    
    init(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlbumKeys.self)
        artist = try container.decode(String.self, forKey: .artist)
        name = try container.decode(String.self, forKey: .name)
        
        var abilitiesContainer = try container.nestedUnkeyedContainer(forKey: .abilities)
        var abilityNames: [String] = []
        while !abilitiesContainer.isAtEnd {
            let abilityContentContainer = try abilitiesContainer.nestedContainer(keyedBy: PokemonKeys.AbilityContentKeys.self)
            let abilityNameContainer = try abilityContentContainer.nestedContainer(keyedBy: PokemonKeys.AbilityContentKeys.AbilityNameKeys.self, forKey: .ability)
            let abilityName = try abilityNameContainer.decode(String.self, forKey: .name)
            abilityNames.append(abilityName)
        }
        abilities = abilityNames
    }
}

struct Song: Codable {
    let name: String
    let duration: Int
}
