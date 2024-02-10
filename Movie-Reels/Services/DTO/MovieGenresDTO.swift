//
//  MovieGenresDTO.swift
//  Movie-Reels
//
//  Created by Apple M1 on 10.02.2024.
//

import Foundation

struct MovieGenresListDTO: Codable {
    let genres: [MovieGenresDTO]
}

struct MovieGenresDTO: Codable {
    let id: Int
    let name: String
}
