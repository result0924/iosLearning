//
//  MovieResponse.swift
//  CombineTest
//
//  Created by jlai on 2020/10/27.
//

import Foundation

struct MovieResponse: Codable {
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}
