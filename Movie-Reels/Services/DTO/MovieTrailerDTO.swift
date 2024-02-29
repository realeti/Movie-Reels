//
//  MovieTrailerDTO.swift
//  Movie-Reels
//
//  Created by Apple M1 on 29.02.2024.
//

import Foundation

struct MovieTrailerListDTO: Codable {
    let results: [MovieTrailerDTO]
}

struct MovieTrailerDTO: Codable {
    let name: String
    let key: String
    let type: String
}
