//
//  ColorMixerView.swift
//  SwiftUITest
//
//  Created by justin on 2019/10/24.
//  Copyright © 2019 jlai. All rights reserved.
//

import SwiftUI

struct ColorMixerView: View {
    
    @State var colorR: Double
    @State var colorG: Double
    @State var colorB: Double

    var body: some View {
        
        ZStack {
            Color(red: colorR, green: colorG, blue: colorB, opacity: 1.0)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                  ZStack {
                    Rectangle()
                        .cornerRadius(16)
                        .frame(height: 100)
                        .foregroundColor(Color(red: 1.25 - (colorR + colorG * 2.0 + colorB) / 3.0, green: 1.25 - (colorR + colorG  * 2.0  + colorB) / 3.0, blue: 1.25 - (colorR + colorG  * 2.0  + colorB) / 3.0, opacity: 0.5))
                    HStack {
                      Text("R: \(Int(colorR * 255.0))")
                      Text("G: \(Int(colorG * 255.0))")
                      Text("B: \(Int(colorB * 255.0))")
                    }
                        .font(Font.custom("Futura", size: 28))
                        .foregroundColor(Color(red: colorR, green: colorG, blue: colorB, opacity: 1.0))
                  }
                }
                .padding(.all, 30)
                .padding(.top, 80)
                Spacer()
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color(red: 1.0 - max(colorR, max(colorG,colorB)), green: 1.0 - max(colorR, max(colorG,colorB)), blue: 1.0 - max(colorR, max(colorG,colorB)), opacity: 0.5), radius: 32)
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "r.circle")
                                .foregroundColor(Color.red.opacity(0.5))
                                .font(.system(size: 20))
                            Slider(value: $colorR, in: 0.0...1.0)
                                .accentColor(Color.red.opacity(colorR))
                            Image(systemName: "r.circle.fill")
                                .foregroundColor(Color.red)
                                .font(.system(size: 25))
                        }.padding()
                        HStack {
                            Image(systemName: "g.circle")
                                .foregroundColor(Color.green.opacity(0.5))
                                .font(.system(size: 20))
                            Slider(value: $colorG, in: 0.0...1.0)
                                .accentColor(Color.green.opacity(colorG))
                            Image(systemName: "g.circle.fill")
                                .foregroundColor(Color.green)
                                .font(.system(size: 25))
                                .accentColor(Color.blue.opacity(colorB))
                        }.padding()
                        HStack {
                            Image(systemName: "b.circle")
                            .foregroundColor(Color.blue.opacity(0.5))
                            .font(.system(size: 20))
                            Slider(value: $colorB, in: 0.0...1.0)
                            Image(systemName: "b.circle.fill")
                            .foregroundColor(Color.blue)
                            .font(.system(size: 25))
                        }.padding()
                    }
                }
                .padding(.all, 32)
                .frame(height: 300)
                Text("a little work with 🌈")
                    .foregroundColor(Color(red: 1.25 - max(colorR, max(colorG,colorB)), green: 1.25 - max(colorR, max(colorG,colorB)), blue: 1.25 - max(colorR, max(colorG,colorB)), opacity: 0.75))
                    .font(.system(size: 17, weight: .regular))
                    .italic()
                    .padding(.top, 16)
                    .padding(.bottom, 16)
            }
        }
    }
}

#if DEBUG
struct ColorMixerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ColorMixerView(colorR: 0.5, colorG: 0.5, colorB: 0.5)
                .previewDevice("iPhone 11")
            
        }
    }
}
#endif
