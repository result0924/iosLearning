//
//  ContentView.swift
//  WidgetTest
//
//  Created by lai Kuan-Ting on 2022/6/4.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @AppStorage("emoji", store: UserDefaults(suiteName: "group.h2syncapp.debug.com")) var emojiData: Data = Data()
    
    let emojis = [
        Emoji(icon: "😀", name: "Happy", description: "This is means the user is about that life!"),
        Emoji(icon: "😐", name: "Stare", description: "That just happened; right here in front of me..."),
        Emoji(icon: "🤬", name: "Heated", description: "Completely done with your ish Karen!")
    ]
    var body: some View {
        VStack(spacing: 30) {
            ForEach(emojis) { emoji in
                EmojiView(emoji: emoji)
                    .onTapGesture {
                        save(emoji)
                    }
            }
        }
    }
    
    func save(_ emoji: Emoji) {
        guard let emojiData = try? JSONEncoder().encode(emoji) else { return }
        self.emojiData = emojiData
        WidgetCenter.shared.reloadAllTimelines()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
