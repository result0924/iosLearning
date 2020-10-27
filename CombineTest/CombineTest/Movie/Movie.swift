//
//  Movie.swift
//  CombineTest
//
//  Created by jlai on 2020/10/27.
//

import Foundation

struct Movie: Codable, Identifiable {
    var id = UUID()
    let movieId: Int
    let originalTitle: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case originalTitle = "original_title"
        case title
    }
}
