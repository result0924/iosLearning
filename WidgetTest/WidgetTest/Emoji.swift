//
//  Emoji.swift
//  WidgetTest
//
//  Created by lai Kuan-Ting on 2022/6/4.
//

import Foundation

struct Emoji: Identifiable, Codable {
    var id: String { icon }
    
    let icon: String
    let name: String
    let description: String
}
