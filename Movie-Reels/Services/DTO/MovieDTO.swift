//
//  MovieDTO.swift
//  Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import Foundation

struct MovieListDTO: Codable {
    let results: [MovieDTO]
}

struct MovieDTO: Codable {
    let id: Int
    let title: String
    let poster: String
    let releaseDate: String
    let overview: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case poster = "poster_path"
        case releaseDate = "release_date"
        case overview
    }
}
