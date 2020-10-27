//
//  MovieDBAPI.swift
//  CombineTest
//
//  Created by jlai on 2020/10/27.
//

import Foundation
import Combine

enum MovieDB {
    static let apiClient = APIClient()
    static let baseURL = URL(string: "https://api.themoviedb.org/3/")!
}

enum APIPath: String {
    case trendingMoviesWeekly = "trending/movie/week"
}

extension MovieDB {
    static func request(_ path: APIPath) -> AnyPublisher<MovieResponse, Error> {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true) else {
            fatalError("Couldn't create URLComponents")
        }
        components.queryItems = [URLQueryItem(name: "api_key", value: "your_api_key_here")]
        let request = URLRequest(url: components.url!)
        
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
