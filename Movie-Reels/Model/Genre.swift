//
//  Genre.swift
//  Movie-Reels
//
//  Created by Apple M1 on 10.02.2024.
//

import Foundation

struct Genre {
    let id: Int
    let name: String
}

extension Genre: Equatable {
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        lhs.id == rhs.id
    }
}
