//
//  Movie.swift
//  Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import Foundation

struct Movie {
    let id: Int
    let title: String
    let poster: String
    let releaseDate: String
    let voteAverage: Float
    let overview: String
    let genreIds: [Int]
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}
