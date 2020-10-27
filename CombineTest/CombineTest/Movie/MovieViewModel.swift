//
//  MovieViewModel.swift
//  CombineTest
//
//  Created by jlai on 2020/10/27.
//

import Foundation
import Combine

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    var cancellationToken: AnyCancellable?
    
    init() {
        getMovies()
    }
}

extension MovieViewModel {
    // Subscriber implementation
    func getMovies() {
        cancellationToken = MovieDB.request(.trendingMoviesWeekly)
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                    self.movies = $0.movies
            })
    }
}
