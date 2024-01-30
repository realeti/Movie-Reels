//
//  MovieDTO.swift
//  Nitrix-Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import Foundation

struct MovieListDTO: Codable {
    let results: [MovieDTO]
}

struct MovieDTO: Codable {
    let title: String
    let overview: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case poster = "poster_path"
    }
}
