//
//  CoreDataController.swift
//  Movie-Reels
//
//  Created by Apple M1 on 01.02.2024.
//

import Foundation
import CoreData

protocol MoviesStoring {
    func storeMovies(movies: [Movie])
}

protocol FavoriteMoviesStoring {
    func addFavoriteMovie(movie: Movie, completion: @escaping (Error?) -> Void)
    func removeFavoriteMovie(movieID id: Int, completion: @escaping (Error?) -> Void)
}

protocol FavoriteMoviesLoading {
    func loadFavoriteMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
}

typealias MovieStoring = MoviesStoring & FavoriteMoviesStoring
typealias MovieLoading = MoviesLoading & FavoriteMoviesLoading

final class CoreDataController: MovieStoring, MovieLoading {
    static let shared = CoreDataController()
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: Constants.coreDataModelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func storeMovies(movies: [Movie]) {
        let context = persistentContainer.newBackgroundContext()
        let request = NSFetchRequest<MovieCD>(entityName: Constants.movieEntityName)
        let results = try? context.fetch(request)
        
        context.perform {
            movies.forEach { movie in
                let movieCD: MovieCD!
                request.predicate = NSPredicate(format: "title == %@", movie.title)
                
                if results?.count == 0 {
                    movieCD = MovieCD(context: context)
                }
                else {
                    movieCD = results?.first
                }
                
                movieCD.id = Int64(movie.id)
                movieCD.title = movie.title
                movieCD.releaseDate = movie.releaseDate
                movieCD.poster = movie.poster
                movieCD.overview = movie.overview
            }
            try? context.save()
        }
    }
    
    func loadMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let context = persistentContainer.newBackgroundContext()
        let request = NSFetchRequest<MovieCD>(entityName: Constants.movieEntityName)
        
        do {
            let movieObjects = try context.fetch(request)
            let movies = movieObjects.map { movie in
                Movie(
                    id: Int(movie.id),
                    title: movie.title ?? "",
                    poster: movie.poster ?? "",
                    releaseDate: movie.releaseDate ?? "",
                    overview: movie.overview ?? ""
                )
            }
            
            if movies.isEmpty {
                completion(.failure(NetErrors.connectionProblem))
                return
            }
            completion(.success(movies))
        } catch {
            completion(.failure(error))
        }
    }
    
    func loadFavoriteMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let context = persistentContainer.newBackgroundContext()
        let request = NSFetchRequest<FavoritesMovieCD>(entityName: Constants.favoritesMovieEntityName)
        
        do {
            let movieObjects = try context.fetch(request)
            
            guard !movieObjects.isEmpty else {
                completion(.success([]))
                return
            }

            let movies = movieObjects.map { movie in
                Movie(
                    id: Int(movie.id),
                    title: movie.title ?? "",
                    poster: movie.poster ?? "",
                    releaseDate: movie.releaseDate ?? "",
                    overview: movie.overview ?? ""
                )
            }

            completion(.success(movies))
        } catch {
            completion(.failure(error))
        }
    }
    
    func addFavoriteMovie(movie: Movie, completion: @escaping (Error?) -> Void) {
        let context = persistentContainer.viewContext
        
        let request = NSFetchRequest<FavoritesMovieCD>(entityName: Constants.favoritesMovieEntityName)
        request.predicate = NSPredicate(format: "title == %@", movie.title)

        do {
            let existingMovies = try context.fetch(request)
            let newFavoriteMovie: FavoritesMovieCD!
            
            if existingMovies.count == 0 {
                newFavoriteMovie = FavoritesMovieCD(context: context)
            } else {
                newFavoriteMovie = existingMovies.first
            }
            
            newFavoriteMovie.id = Int64(movie.id)
            newFavoriteMovie.title = movie.title
            newFavoriteMovie.releaseDate = movie.releaseDate
            newFavoriteMovie.poster = movie.poster
            newFavoriteMovie.overview = movie.overview

            try context.save()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func removeFavoriteMovie(movieID id: Int, completion: @escaping (Error?) -> Void) {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<FavoritesMovieCD>(entityName: Constants.favoritesMovieEntityName)
        request.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))

        do {
            let results = try context.fetch(request)
            if let movieToDelete = results.first {
                context.delete(movieToDelete)
                try context.save()
                completion(nil)
            }
        } catch {
            completion(error)
        }
    }
}
