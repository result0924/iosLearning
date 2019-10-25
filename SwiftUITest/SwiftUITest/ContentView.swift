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
            PlusOneSecondView()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("First")
                }.tag(0)
            DartModeView()
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Second")
                }.tag(1)
            ColorMixerView(colorR: 0.5, colorG: 0.5, colorB: 0.5)
                .tabItem {
                    Image(systemName: "3.circle")
                    Text("Third")
            }.tag(2)
        }.edgesIgnoringSafeArea(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().previewDevice(PreviewDevice(rawValue: "iPhone X"))
            ContentView().previewDevice(PreviewDevice(rawValue: "iPhone SE"))
        }
    }
}
