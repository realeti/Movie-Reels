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
    func storeGenres(genres: [Genre])
}

protocol FavoriteMoviesStoring {
    func storeFavoriteMovie(movie: Movie, completion: @escaping (Error?) -> Void)
    func removeFavoriteMovie(movieID id: Int, completion: @escaping (Error?) -> Void)
}

protocol MoviesLoadingStorage {
    func loadMovies<T: NSManagedObject & MovieEntity>(entityType: T.Type, entityName: String, completion: @escaping (Result<[Movie], Error>) -> Void)
    func loadMovieGenres(completion: @escaping (Result<[Genre], Error>) -> Void)
}

protocol MovieEntity {
    var id: Int64 { get set }
    var overview: String? { get set }
    var poster: String? { get set }
    var releaseDate: String? { get set }
    var title: String? { get set }
    var genreIds: Data? { get set }
    var voteAverage: Float { get set }
}

typealias MovieStoring = MoviesStoring & FavoriteMoviesStoring

final class CoreDataController: MovieStoring, MoviesLoadingStorage {
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
        
        context.perform {
            let request = NSFetchRequest<MovieCD>(entityName: Constants.movieEntityName)
            
            movies.forEach { movie in
                var movieCD: MovieCD?
                
                request.predicate = NSPredicate(format: "id == %@", NSNumber(value: movie.id))
                
                if let existingMovieCD = try? context.fetch(request).first {
                    movieCD = existingMovieCD
                } else {
                    movieCD = MovieCD(context: context)
                }
                
                movieCD?.id = Int64(movie.id)
                movieCD?.title = movie.title
                movieCD?.releaseDate = movie.releaseDate
                movieCD?.poster = movie.poster
                movieCD?.overview = movie.overview
                movieCD?.genreIds = try? JSONEncoder().encode(movie.genreIds)
            }
            try? context.save()
        }
    }
    
    func storeGenres(genres: [Genre]) {
        let context = persistentContainer.newBackgroundContext()
        
        context.perform {
            let request = NSFetchRequest<MovieGenreCD>(entityName: Constants.movieGenreEntityName)
            
            genres.forEach { genre in
                var movieGenreCD: MovieGenreCD?
                
                request.predicate = NSPredicate(format: "id == %@", NSNumber(value: genre.id))
                
                if let existingMovieGenreCD = try? context.fetch(request).first {
                    movieGenreCD = existingMovieGenreCD
                } else {
                    movieGenreCD = MovieGenreCD(context: context)
                }
                
                movieGenreCD?.id = Int64(genre.id)
                movieGenreCD?.name = genre.name
            }
            try? context.save()
        }
    }
    
    func loadMovies<T: NSManagedObject & MovieEntity>(entityType: T.Type, entityName: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let context = persistentContainer.newBackgroundContext()
        
        context.perform {
            let request = NSFetchRequest<T>(entityName: entityName)
            
            do {
                let movieObjects = try context.fetch(request)
                
                guard !movieObjects.isEmpty else {
                    completion(.success([]))
                    return
                }
                
                let movies = movieObjects.map { movie in
                    let genreIds = movie.genreIds ?? Data()
                    let movieGenreIds = try? JSONDecoder().decode([Int].self, from: genreIds)
                    
                    return Movie(
                        id: Int(movie.id),
                        title: movie.title ?? "",
                        poster: movie.poster ?? "",
                        releaseDate: movie.releaseDate ?? "",
                        voteAverage: movie.voteAverage,
                        overview: movie.overview ?? "",
                        genreIds: movieGenreIds ?? []
                    )
                }
                
                completion(.success(movies))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func loadMovieGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        let context = persistentContainer.newBackgroundContext()
        
        context.perform {
            let request = NSFetchRequest<MovieGenreCD>(entityName: Constants.movieGenreEntityName)
            
            do {
                let genreObjects = try context.fetch(request)
                
                guard !genreObjects.isEmpty else {
                    completion(.success([]))
                    return
                }
                
                let genres = genreObjects.map { genre in
                    Genre(
                        id: Int(genre.id),
                        name: genre.name ?? ""
                    )
                }
                completion(.success(genres))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func storeFavoriteMovie(movie: Movie, completion: @escaping (Error?) -> Void) {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<FavoritesMovieCD>(entityName: Constants.favoritesMovieEntityName)
        request.predicate = NSPredicate(format: "id == %@", NSNumber(value: movie.id))

        do {
            var newFavoriteMovie: FavoritesMovieCD?
            
            if let existingFavoriteMovieCD = try context.fetch(request).first {
                newFavoriteMovie = existingFavoriteMovieCD
            } else {
                newFavoriteMovie = FavoritesMovieCD(context: context)
            }
            
            newFavoriteMovie?.id = Int64(movie.id)
            newFavoriteMovie?.title = movie.title
            newFavoriteMovie?.releaseDate = movie.releaseDate
            newFavoriteMovie?.voteAverage = movie.voteAverage
            newFavoriteMovie?.poster = movie.poster
            newFavoriteMovie?.overview = movie.overview
            newFavoriteMovie?.genreIds = try? JSONEncoder().encode(movie.genreIds)

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
            if let movieForDelete = try context.fetch(request).first {
                context.delete(movieForDelete)
                try context.save()
                completion(nil)
            }
        } catch {
            completion(error)
        }
    }
}

extension MovieCD: MovieEntity {}
extension FavoritesMovieCD: MovieEntity {}
