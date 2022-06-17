//
//  MyWidget.swift
//  MyWidget
//
//  Created by lai Kuan-Ting on 2022/6/4.
//

import WidgetKit
import SwiftUI
import Intents

struct EmojiEntry: TimelineEntry {
    let date: Date = Date()
    let emoji: Emoji
}

struct Provider: TimelineProvider {
    @AppStorage("emoji", store: UserDefaults(suiteName: "group.h2syncapp.debug.com")) var emojiData: Data = Data()

    func placeholder(in context: Context) -> EmojiEntry {
        return EmojiEntry(emoji: Emoji(icon: "🤩", name: "N/A", description: "N/A"))
    }
    
    // snapshot with context and completion Handler the essentially going to be a really quick rendering of what your widget look like. I believe that this is going to be shown in the app library like when you're going to add the widget to either the home screen or the widgets screen so whenever you're going to be actually selecting this specific widget it's going to be using the snapshot in order to display that data  now you might want to put in dummy data you could put in realistic data but for the most part you want to have this data come back as quick as possible you do not want to do like any heavy processing on this
    func getSnapshot(in context: Context, completion: @escaping (EmojiEntry) -> Void) {
        guard let emoji = try? JSONDecoder().decode(Emoji.self,  from: emojiData) else { return }
        let entry = EmojiEntry(emoji: emoji)
        completion(entry)
    }
    
    // this timeline with context completion now this method is specifically meant to update your widget with new data so what you would normally do is you usually actually create your emoji entry and pass in a new date whenever you want this to expire so you would essentially want to create a new date and you would say oh i wanted to expire after amount of seconds or min hours however often you would want your widget update that's where you would do this and then you would run this logic in order to pull in the new data and re-render it what we're gonna do is just gonna recreate another simple emoji entry so we won't be handling that today but this is where you would actually handle updating your widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<EmojiEntry>) -> Void) {
        guard let emoji = try? JSONDecoder().decode(Emoji.self, from: emojiData) else { return }
        
        let entry = EmojiEntry(emoji: emoji)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    // going to be what actually holds the date of when the widget is supposed to be updated and presented as well as some additional data whatever you find to be valuable in order to populate your widget in our case that's going to be an emoji so that we can actually create the reset of our provider as well
    typealias Entry = EmojiEntry
    
}

struct WidgetEntryView: View {
    let entry: Provider.Entry
    
    var body: some View {
        EmojiView(emoji: entry.emoji)
    }
}

@main
struct MyWidget: Widget {
    private let kind = "MyWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
    }
    
}
