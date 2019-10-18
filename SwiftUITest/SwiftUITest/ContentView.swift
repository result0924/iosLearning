//
//  ContentView.swift
//  SwiftUITest
//
//  Created by justin on 2019/10/18.
//  Copyright © 2019 jlai. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("Plus one second")
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("First")
                }.tag(0)
            Text("Dark mode test")
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Second")
                }.tag(1)
            Text("Color mixer")
                .tabItem {
                    Image(systemName: "3.circle")
                    Text("Third")
            }.tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
