//
//  EmojiView.swift
//  WidgetTest
//
//  Created by lai Kuan-Ting on 2022/6/4.
//

import SwiftUI

struct EmojiView: View {
    let emoji: Emoji
    
    var body: some View {
        Text(emoji.icon)
            .font(.largeTitle)
            .padding()
            .background(Color.blue)
            .clipShape(Circle())
    }
}

