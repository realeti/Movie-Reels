//
//  Constants.swift
//  Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import Foundation

struct Constants {
    
    // MARK: - Table view
    static let movieCellIdentifier = "movieCell"
    
    // MARK: - Alert messages
    static let alertActionOk = "OK"
    static let alertActionYes = "Yes"
    static let alertActionCancel = "Cancel"
    static let addMovieToFavorites = "Add a movie to your favorites?"
    static let removeFavoriteMovie = "Remove"
    static let alertError = "Error"
    
    // MARK: - Tab bar names
    static let moviesTabBarName = "Home"
    static let catalogTabBarName = "Catalog"
    static let favoritesTabBarName = "Favorites"
    
    // MARK: Coredata
    static let coreDataModelName = "MoviesDataModel"
    static let movieEntityName = "MovieCD"
    static let movieGenreEntityName = "MovieGenreCD"
    static let favoritesMovieEntityName = "FavoritesMovieCD"
    static let moviePosterEntityName = "MoviePosterCD"
    
    init () {}
}
