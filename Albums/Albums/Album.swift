//
//  Album.swift
//  Albums
//
//  Created by Jordan Christensen on 10/1/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation

struct Album: Codable {
    enum PokemonKeys: String, CodingKey {
        case name
        case abilities
        
        enum AbilityContentKeys: String, CodingKey {
            case ability
            
            enum AbilityNameKeys: String, CodingKey {
                case name
            }
        }
    }
    enum AlbumKeys: String, CodingKey {
        case artist
        case genres
        case name
        case songs
        case id
        case coverArt
    }
    
    var artist: String
    var genres: [String]
    var name: String
    var id: UUID
    var songs: [Song]
    var coverArt: [String]
    
    init(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlbumKeys.self)
        artist = try container.decode(String.self, forKey: .artist)
        name = try container.decode(String.self, forKey: .name)
        genres = try container.decode([String].self, forKey: .genres)
        let idString = try container.decode(String.self, forKey: .id)
        id = UUID(uuidString: idString) ?? UUID()
        songs = try container.decode([Song].self, forKey: .songs)
        coverArt = ["hehe"]
    }
}

struct Song: Codable {
    enum SongKeys: String, CodingKey {
        
        enum NameKeys: String, CodingKey { case name }
        enum DurationKeys: String, CodingKey { case duration }
        
        case name
        case duration
        case id
    }
    
    var name: String
    var duration: Int
    var id: UUID
    
    init(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SongKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        
        var nameContentContainer = try container.nestedUnkeyedContainer(forKey: .name)
        var durationContentContainer = try container.nestedUnkeyedContainer(forKey: .duration)
        
        let durationString = try durationContentContainer.decode(String.self)
        let colonIndex = durationString.firstIndex(of: ":")
        guard let firstIndex = colonIndex,
            let min = Int(String(durationString[..<firstIndex])),
            let sec = Int(String(durationString[firstIndex...])) else { return }
                
        name = try nameContentContainer.decode(String.self)
        id = UUID(uuidString: idString) ?? UUID()
        duration = min * 60 + sec
    }
}
